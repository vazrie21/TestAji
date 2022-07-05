// ignore_for_file: prefer_const_constructors, unused_import

import 'dart:ffi';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_ongkir/app/modules/home/models/prayer_time.dart';
import 'package:get_ongkir/app/routes/app_pages.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../controllers/home_controller.dart';
import '../../../data/models/city_model.dart';
import '../../../data/models/province_model.dart';
import '../../../data/models/ongkir_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import '../models/prodak.dart';

final Faker faker = Faker();
List<Prodak> dummyData = List.generate(50, (index) {
  return Prodak(
      "https://picsum.photos/id/${index}/200/",
      faker.food.restaurant(),
      10000 + Random().nextInt(100000),
      faker.lorem.sentence());
});

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var statusTheme = true.obs;
    return Obx(() {
      return MaterialApp(
        theme: ThemeData(
          brightness: statusTheme.isFalse ? Brightness.light : Brightness.dark,
        ),
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Cek Ongkir New'),
              centerTitle: true,
              // leading: IconButton(
              //   icon: Icon(Icons.menu),
              //   onPressed: () {
              //     print("Hello Bos");
              //   },
              // ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none),
                ),
                Obx(
                  () => Switch(
                      value: statusTheme.value,
                      onChanged: (Value) {
                        statusTheme.value = !statusTheme.value;
                        print(statusTheme.value);
                      }),
                ),
              ],
              elevation: 15,
              // flexibleSpace: Container(
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [Colors.purple, Colors.green],
              //       begin: Alignment.bottomRight,
              //       end: Alignment.topLeft,
              //     ),
              //   ),
              // ),
              bottom: TabBar(
                indicatorColor: Colors.white,
                indicatorWeight: 2,
                tabs: const [
                  Tab(icon: Icon(Icons.home), text: "Home"),
                  Tab(icon: Icon(Icons.face), text: "Profile"),
                  Tab(icon: Icon(Icons.settings), text: "Setting"),
                ],
              ),
            ),
            drawer: Drawer(
              child: Column(
                children: [
                  Container(
                    color: Colors.purple,
                    height: 170,
                    width: double.infinity,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Menu Pilihan",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            body: WillPopScope(
              onWillPop: onWillPop,
              child: TabBarView(
                children: [
                  jadwalShalat(context),
                  cekOngkir(context),
                  listProdak(context),
                ],
              ),
            ),
            bottomNavigationBar: tombolBawah(context),
          ),
        ),
      );
    });
  }

  Widget cekOngkir(BuildContext context) => Container(
        // color: Colors.teal,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Card(
              elevation: 5,
              // color: Colors.amber.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Lokasi Asal",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownSearch<Province>(
                      popupProps: PopupProps.menu(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) => ListTile(
                                title: Text("${item.province}"),
                              )),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Pilih Provinsi",
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      asyncItems: (String filter) async {
                        var response = await Dio().get(
                          "https://api.rajaongkir.com/starter/province",
                          queryParameters: {
                            "key": "c0a8cb5241c7f423c5c2d3999a6a214f"
                          },
                        );
                        return Province.fromJsonList(
                            response.data["rajaongkir"]["results"]);
                      },
                      onChanged: (val) =>
                          controller.provAsal.value = val?.provinceId ?? "0",
                    ),
                    SizedBox(height: 20),
                    DropdownSearch<City>(
                      popupProps: PopupProps.menu(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) => ListTile(
                                title: Text("${item.cityName}"),
                              )),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Pilih Kota/Kab Asal",
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      asyncItems: (String filter) async {
                        var response = await Dio().get(
                          "https://api.rajaongkir.com/starter/city?province=${controller.provAsal}",
                          queryParameters: {
                            "key": "c0a8cb5241c7f423c5c2d3999a6a214f"
                          },
                        );
                        return City.fromJsonList(
                            response.data["rajaongkir"]["results"]);
                      },
                      onChanged: (val) =>
                          controller.cityAsal.value = val?.cityId ?? "0",
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              // color: Colors.greenAccent.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "Lokasi Tujuan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    DropdownSearch<Province>(
                      popupProps: PopupProps.menu(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) => ListTile(
                                title: Text("${item.province}"),
                              )),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Pilih Provinsi Tujuan",
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      asyncItems: (String filter) async {
                        var response = await Dio().get(
                          "https://api.rajaongkir.com/starter/province",
                          queryParameters: {
                            "key": "c0a8cb5241c7f423c5c2d3999a6a214f"
                          },
                        );
                        return Province.fromJsonList(
                            response.data["rajaongkir"]["results"]);
                      },
                      onChanged: (val) =>
                          controller.provTujuan.value = val?.provinceId ?? "0",
                    ),
                    SizedBox(height: 20),
                    DropdownSearch<City>(
                      popupProps: PopupProps.menu(
                          showSearchBox: true,
                          itemBuilder: (context, item, isSelected) => ListTile(
                                title: Text("${item.cityName}"),
                              )),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          labelText: "Pilih Kota/Kab Tujuan",
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      asyncItems: (String filter) async {
                        var response = await Dio().get(
                          "https://api.rajaongkir.com/starter/city?province=${controller.provTujuan}",
                          queryParameters: {
                            "key": "c0a8cb5241c7f423c5c2d3999a6a214f"
                          },
                        );
                        return City.fromJsonList(
                            response.data["rajaongkir"]["results"]);
                      },
                      onChanged: (val) =>
                          controller.cityTujuan.value = val?.cityId ?? "0",
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              // color: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: [
                    DropdownSearch<Map<String, dynamic>>(
                      items: const [
                        {
                          "code": "jne",
                          "name": "JNE",
                        },
                        {
                          "code": "pos",
                          "name": "POS Indonesia",
                        },
                        {
                          "code": "tiki",
                          "name": "TIKI",
                        },
                      ],
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        itemBuilder: (context, item, isSelected) => ListTile(
                          title: Text("${item['name']}"),
                        ),
                      ),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          // labelText: "Pilih Kurir",
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      dropdownBuilder: (context, itemSelect) =>
                          Text("${itemSelect?['name'] ?? 'Pilih Kurir'}"),
                      onChanged: (e) =>
                          controller.pilihKurir.value = e?['code'] ?? "",
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: controller.beratBarang,
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      decoration: InputDecoration(
                          labelText: "Berat (gram)",
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 25,
                            horizontal: 10,
                          )),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 50,
                          child: Obx(
                            () => ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.cyan.shade600),
                              ),
                              onPressed: () {
                                if (controller.isLoading.isFalse) {
                                  controller.cekOngkir();
                                }
                              },
                              child: Text(controller.isLoading.isFalse
                                  ? "Cek Ongkir"
                                  : "Loading..."),
                            ),
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueGrey.shade500),
                            ),
                            // onPressed: () => Get.toNamed(Routes.PAGE1),
                            onPressed: () =>
                                print(controller.getLokasiSekarang()),
                            child: Text("Masuk Page 1"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  Widget tombolBawah(BuildContext context) => Obx(
        () => BottomNavigationBar(
          onTap: controller.indexTerPilih,
          // currentIndex: controller.tabIndex,
          // fixedColor: Colors.green,
          type: BottomNavigationBarType.shifting,
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.grey,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          // backgroundColor: Colors.black,
          elevation: 50,
          currentIndex: controller.indexTerPilih.value,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home),
              label: 'Home',
              // backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.sportscourt),
              label: 'News',
              // backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bell),
              label: 'Alerts',
              // backgroundColor: Colors.purple,
            ),
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person),
              label: 'Account',
              // backgroundColor: Colors.purple,
            ),
          ],
        ),
      );

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    String pesanW = "Tekan sekali lagi untuk keluar";
    if (controller.waktuSekarang == null ||
        now.difference(controller.waktuSekarang) > Duration(seconds: 2)) {
      controller.waktuSekarang = now;
      Fluttertoast.showToast(msg: pesanW);
      return Future.value(false);
    }
    return Future.value(true);
  }

  Widget jadwalShalat(BuildContext context) => Container(
        // color: Colors.teal,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Image.asset("assets/images/shalat1.png"),
            ),
            SizedBox(),
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Obx(
                () => ListView.builder(
                  // scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: controller.prayerName.length,
                  itemBuilder: (context, position) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 120,
                            child: Text(
                              controller.prayerName[position],
                              style: TextStyle(
                                // color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                            // height: 50,
                          ),
                          Container(
                            width: 150,
                            height: 30,
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 6.0,
                                ),
                              ],
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: Colors.white,
                            ),
                            child: Center(
                              child: Text(
                                controller.prayerTimes[position],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    controller.getLokasiSekarang();
                    controller.setSp();
                  },
                  icon: Icon(
                    Icons.location_on_outlined,
                    // color: Colors.white,
                  ),
                  label: Obx(
                    () => Text(
                      controller.alamatN.isEmpty
                          ? "Mencari Lokasi..."
                          : "${controller.alamatN}",
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget listProdak(BuildContext context) => Container(
        // color: Colors.grey.shade300,
        child: AlignedGridView.count(
          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          // childAspectRatio: MediaQuery.of(context).size.width /
          //     (MediaQuery.of(context).size.height / 2),
          // ),
          itemCount: dummyData.length,
          itemBuilder: (context, index) {
            return Container(
              // color: Colors.white,
              padding: EdgeInsets.all(5),
              // margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                // border: Border.all(color: Colors.grey.shade100),
                color: Colors.white70,
                borderRadius: BorderRadius.circular(10),
              ),

              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(child: Image.network(dummyData[index].imageUrl)),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Text(
                          dummyData[index].judul,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black,
                            // fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          CurrencyFormat.convertToIdr(
                              dummyData[index].harga, 0),
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(onPressed: () {}, child: Text("ADD")),
                      ],
                    )
                  ]),
            );
          },
        ),
      );

  Widget listProdak2(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Wrap(
            alignment: WrapAlignment.spaceEvenly,
            spacing: 0,
            runSpacing: 0,
            direction: Axis.horizontal,
            children: dummyData.map((index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width * 0.4,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: NetworkImage(index.imageUrl))),
                  ),
                  Text(index.judul),
                  Text("Rp ${index.harga}"),
                ],
              );
            }).toList(),
          ),
        ),
      );
}
