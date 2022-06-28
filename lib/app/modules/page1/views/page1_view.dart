// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_search/dropdown_search.dart';

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
        // ignore: prefer_const_constructors
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        children: [
          DropdownSearch<Map<String, dynamic>>(
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
            // ignore: prefer_const_constructors
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
              controller.promoDiPilih = a!;
              print(controller.promoDiPilih);
              print(controller.dataCart);
            },
          ),
        ],
      ),
    );
  }
}
