import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_ongkir/app/data/models/ongkir_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  RxBool isLoading = false.obs;

  List<Ongkir> ongkir = [];

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
}
