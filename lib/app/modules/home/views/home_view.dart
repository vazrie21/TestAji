import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../../../data/models/city_model.dart';
import '../../../data/models/province_model.dart';
import '../../../data/models/ongkir_model.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pilih Alamat Asal'),
          centerTitle: true,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
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
                  border: OutlineInputBorder(),
                ),
              ),
              asyncItems: (String filter) async {
                var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/province",
                  queryParameters: {"key": "c0a8cb5241c7f423c5c2d3999a6a214f"},
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
                  border: OutlineInputBorder(),
                ),
              ),
              asyncItems: (String filter) async {
                var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/city?province=${controller.provAsal}",
                  queryParameters: {"key": "c0a8cb5241c7f423c5c2d3999a6a214f"},
                );
                return City.fromJsonList(
                    response.data["rajaongkir"]["results"]);
              },
              onChanged: (val) =>
                  controller.cityAsal.value = val?.cityId ?? "0",
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
                  border: OutlineInputBorder(),
                ),
              ),
              asyncItems: (String filter) async {
                var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/province",
                  queryParameters: {"key": "c0a8cb5241c7f423c5c2d3999a6a214f"},
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
                  border: OutlineInputBorder(),
                ),
              ),
              asyncItems: (String filter) async {
                var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/city?province=${controller.provTujuan}",
                  queryParameters: {"key": "c0a8cb5241c7f423c5c2d3999a6a214f"},
                );
                return City.fromJsonList(
                    response.data["rajaongkir"]["results"]);
              },
              onChanged: (val) =>
                  controller.cityTujuan.value = val?.cityId ?? "0",
            ),
            SizedBox(height: 20),
            DropdownSearch<Map<String, dynamic>>(
              items: [
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
                  labelText: "Pilih Kurir",
                  contentPadding: EdgeInsets.all(20),
                  border: OutlineInputBorder(),
                ),
              ),
              dropdownBuilder: (context, itemSelect) =>
                  Text("${itemSelect?['name'] ?? 'Pilih Kurir'}"),
              onChanged: (e) => controller.pilihKurir.value = e?['code'] ?? "",
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
            Obx(() => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.cekOngkir();
                  }
                },
                child: Text(controller.isLoading.isFalse
                    ? "Cek Ongkir"
                    : "Loading..."))),
          ],
        ));
  }
}
