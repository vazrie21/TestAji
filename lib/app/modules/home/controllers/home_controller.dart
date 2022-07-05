import 'dart:convert';
// import 'dart:html';
import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ongkir/app/data/models/ongkir_model.dart';
import 'package:get_ongkir/app/modules/home/models/prayer_time.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/prayer_time.dart';
// import '../models/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class CurrencyFormat {
  static String convertToIdr(dynamic number, int decimalDigit) {
    NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id',
      symbol: 'Rp ',
      decimalDigits: decimalDigit,
    );
    return currencyFormatter.format(number);
  }
}

class HomeController extends GetxController {
  RxString provAsal = "0".obs;
  RxString cityAsal = "0".obs;
  RxString provTujuan = "0".obs;
  RxString cityTujuan = "0".obs;
  RxString pilihKurir = "".obs;
  TextEditingController beratBarang = TextEditingController();
  TextEditingController lokasiGMT = TextEditingController();
  RxBool isLoading = false.obs;
  List<Ongkir> ongkir = [];

  var indexTerPilih = 0.obs;
  var timeZone = 7.0.obs;
  var lokasiHP = {}.obs;
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var curLok;
  var alamatN = ''.obs;
  DateTime waktuSekarang = DateTime.now();
  var gmt = DateTime.now().timeZoneOffset.inHours.toDouble();

  RxList<dynamic> prayerTimes = [].obs;
  RxList<dynamic> prayerName = [].obs;
  var initData = [].obs;

  double lat_def = -6.3459975;
  double long_def = 106.6916583;
  String kota_def = "Kota TangerangSelatan, Kecamatan Setu";

  void changeIndex(int index) {
    indexTerPilih.value = index;
  }

  void cekOngkir() async {
    if (provAsal != "0" &&
        cityAsal != "0" &&
        provTujuan != "0" &&
        cityTujuan != "0" &&
        pilihKurir != "") {
      try {
        isLoading.value = true;
        var response = await http.post(
            Uri.parse("https://api.rajaongkir.com/starter/cost"),
            headers: <String, String>{
              'content-type': 'application/x-www-form-urlencoded',
              'key': 'c0a8cb5241c7f423c5c2d3999a6a214f',
            },
            body: {
              "origin": cityAsal.value,
              "destination": cityTujuan.value,
              "weight": beratBarang.text,
              "courier": pilihKurir.value,
            });
        isLoading.value = false;
        List rajaongkir = jsonDecode(response.body)["rajaongkir"]["results"][0]
            ['costs'] as List;
        ongkir = Ongkir.fromJsonList(rajaongkir);

        Get.defaultDialog(
          title: "ONGKIR",
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ongkir
                .map(
                  (e) => ListTile(
                    title: Text("${e.service!.toUpperCase()}"),
                    subtitle:
                        Text(CurrencyFormat.convertToIdr(e.cost![0].value, 0)),
                  ),
                )
                .toList(),
          ),
        );
      } catch (e) {
        Get.defaultDialog(
          title: "Terjadi Kesalahan 1",
          middleText: "Tidak dapat mengecek Ongkir !! ${e} ",
        );
      }
      print("${pilihKurir}");
      //eksekusi
    } else {
      Get.defaultDialog(
        title: "Terjadi Kesalahan 2",
        middleText: "Data Input Tidak Lengkap !! ${pilihKurir} ${provAsal}",
      );
    }
  }

  Future getPrayerTimes(double lat, double lng) async {
    List<String> jadwal = List<String>.empty().obs;
    List<String> waktu = List<String>.empty().obs;
    PrayerTime prayers = PrayerTime();

    prayers.setTimeFormat(prayers.getTime12());
    prayers.setCalcMethod(prayers.getMWL());
    prayers.setAsrJuristic(prayers.getShafii());
    prayers.setAdjustHighLats(prayers.getAdjustHighLats());

    List<int> offsets = [-7, -3, 3, 3, 4, 4, 7];

    var currentTime = DateTime.now();
    prayers.tune(offsets);

    waktu = prayers.getPrayerTimes(currentTime, lat, lng, timeZone.value);
    jadwal = prayers.getTimeNames();

    // sortir
    prayerTimes.value = [];
    prayerName.value = [];
    for (var i = 0; i < jadwal.length; i++) {
      if (i != 1 && i != 4) {
        var set = DateFormat.jm().parse(waktu[i]);
        var date = DateFormat("HH:mm").format(set);
        // print(date);
        prayerName.add(jadwal[i]);
        prayerTimes.add(date);
      }
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future getLokasiSekarang() async {
    _determinePosition().then((value) async {
      curLok = value;
      lat.value = curLok.latitude;
      lng.value = curLok.longitude;
      lokasiHP['lat'] = lat;
      lokasiHP['lng'] = lng;

      print(prayerTimes);
      print(gmt);

      timeZone.value = lokasiGMT.value.text.isNotEmpty
          ? double.parse(lokasiGMT.value.text.toString())
          : gmt;
      await getPrayerTimes(lat.value, lng.value);
      namaAlamat(lat.value, lng.value);
    });
  }

  Future namaAlamat(double lat, double lng) async {
    List<Placemark> p = await placemarkFromCoordinates(lat, lng);
    alamatN.value =
        p[0].subAdministrativeArea.toString() + ", " + p[0].locality.toString();
    // print(p[0]);
  }

  Future<dynamic> getSp() async {
    List dataPref = [];
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("ini pref: ");
    print(pref);

    double? cekLat = pref.getDouble("key_lat");
    double? cekLng = pref.getDouble("key_long");
    String? cekAlamat = pref.getString("key_alamat");

    // print(lat_def);
    print(cekLat);
    print(cekLng);

    dataPref.add(lat_def);
    dataPref.add(long_def);
    dataPref.add(kota_def);
    return dataPref;
  }

  Future<dynamic> setSp() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setDouble("key_lat", lat.value);
    pref.setDouble("key_long", lng.value);
    pref.setString("key_alamat", alamatN.value);
  }

  @override
  Future onInit() async {
    super.onInit();
    getSp().then((value) {
      initData.value = value;
      getPrayerTimes(lat_def, long_def);
    });
    // getPrayerTimes(lat.value, lng.value);
  }
}
