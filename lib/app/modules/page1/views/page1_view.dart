// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, unused_import, unnecessary_import

import 'dart:developer';
// import 'dart:js';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';

import '../controllers/page1_controller.dart';
import '../../../data/models/cart_model.dart';

class Page1View extends GetView<Page1Controller> {
  const Page1View({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page1'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        children: [
          DropdownSearch<Map<String, dynamic>>(
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              {
                "nama": "Promo 1",
                "ket": "Keterangan Promo",
              },
              {
                "nama": "Promo 2",
                "ket": "Keterangan Promo",
              },
              {
                "nama": "Promo 3",
                "ket": "Keterangan Promo",
              },
            ],
            popupProps: PopupProps.menu(
              // showSearchBox: true,
              itemBuilder: (b, c, a) => ListTile(
                title: Text("${c['nama']}"),
                subtitle: Text("${c['ket']}"),
              ),
            ),
            dropdownDecoratorProps: const DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                fillColor: Color.fromARGB(227, 77, 36, 3),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromARGB(255, 58, 0, 0)),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                // ignore: unnecessary_const
                prefixIcon: const Icon(
                  Icons.sell_rounded,
                  color: Color.fromARGB(227, 77, 36, 3),
                ),
                // prefixIcon: Icon(Icons.sell_outlined),
                contentPadding: EdgeInsets.all(20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50))),
              ),
            ),
            dropdownBuilder: (context, itemSelect) =>
                Text("${itemSelect?['nama'] ?? 'Pilih Promo'}"),
            onChanged: (a) {
              controller.promoDiPilih.value = a!['nama'];
              print(controller.promoDiPilih);
              print(controller.dataCart);
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            style: ButtonStyle(
              // alignment: Alignment.centerLeft,
              backgroundColor: MaterialStateProperty.all(Colors.white70),
              foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.brown.shade800),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.brown.shade800),
                ),
              ),
            ),
            onPressed: () {
              Get.bottomSheet(
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                backgroundColor: Colors.white,
                // ignore: unnecessary_new
                new Container(
                  height: 300,
                  // color: Colors.yellow,
                  child: ListView(
                    children: controller.test(),
                  ),
                ),
              );
            },
            // icon: Icon(Icons.arrow_drop_down),
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.sell_outlined,
                    size: 24.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 15,
                    ),
                    alignment: Alignment.centerLeft,
                    child: Obx(
                      () => controller.promoDiPilih.isEmpty
                          ? Text(
                              'Pilih Promo',
                            )
                          : Text(
                              controller.promoDiPilih.value,
                            ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
