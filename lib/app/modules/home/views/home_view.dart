// ignore_for_file: prefer_const_constructors, unused_import

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';
import 'package:get_ongkir/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';
import '../../../data/models/city_model.dart';
import '../../../data/models/province_model.dart';
import '../../../data/models/ongkir_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Cek Ongkir New'),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                print("Hello Bos");
              },
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_none),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
              ),
            ],
            // backgroundColor: Colors.green.shade600,
            elevation: 15,

            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.green],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            bottom: TabBar(
              // isScrollable: true,
              indicatorColor: Colors.white,
              indicatorWeight: 2,
              tabs: const [
                Tab(icon: Icon(Icons.home), text: "Home"),
                Tab(icon: Icon(Icons.face), text: "Profile"),
                Tab(icon: Icon(Icons.settings), text: "Setting"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              cekOngkir(context),
              Text("test"),
              Text("test 2"),
            ],
          )),
    );
  }

  Widget cekOngkir(BuildContext context) => ListView(
        padding: EdgeInsets.all(20),
        children: [
          Card(
            elevation: 5,
            color: Colors.amber.shade300,
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
            color: Colors.greenAccent.shade400,
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
            color: Colors.grey.shade300,
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
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                child: Obx(
                  () => ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
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
              // SizedBox(height: 30),
              Container(
                width: 150,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blueGrey.shade500),
                  ),
                  onPressed: () => Get.toNamed(Routes.PAGE1),
                  child: Text("Masuk Page 1"),
                ),
              ),
            ],
          ),
        ],
      );
}
