import 'dart:developer';
// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Page1Controller extends GetxController {
  List dataCart = [
    {
      "product_id": "1796",
      "title": "Mokka Torte",
      "cover": {
        "s":
            "https://dapurcokelat.com/assets/uploads/products/thumbs/100x100/polos_%281%29.jpg",
        "m":
            "https://dapurcokelat.com/assets/uploads/products/thumbs/400x400/polos_%281%29.jpg",
        "l":
            "https://dapurcokelat.com/assets/uploads/products/thumbs/800x800/polos_%281%29.jpg"
      },
      "sku": "",
      "price": "120000",
      "sale": "0",
      "disc": "0",
      "preview_id": "5033",
      "img":
          "https://dapurcokelat.com/assets/uploads/products/thumbs/400x400/IMG_0017_(500px).jpg",
      "variant_1": "2740",
      "variant_2": "2741",
      "variant_3": 0,
      "variant_1_type": "Flavor",
      "variant_1_value": "Nougat",
      "variant_2_type": "Size",
      "variant_2_value": "10x20",
      "variant_3_type": "",
      "variant_3_value": "",
      "qty": "5",
      "note": "",
      "content":
          "<p><span>German style layer cake with light mocca butter cream and delicious topping on it.</span><span><br /></span></p>"
    },
    {
      "product_id": "1796",
      "title": "Mokka Torte",
      "cover": {
        "s":
            "https://dapurcokelat.com/assets/uploads/products/thumbs/100x100/polos_%281%29.jpg",
        "m":
            "https://dapurcokelat.com/assets/uploads/products/thumbs/400x400/polos_%281%29.jpg",
        "l":
            "https://dapurcokelat.com/assets/uploads/products/thumbs/800x800/polos_%281%29.jpg"
      },
      "sku": "",
      "price": "12000",
      "sale": "0",
      "disc": "0",
      "preview_id": "5033",
      "img":
          "https://dapurcokelat.com/assets/uploads/products/thumbs/400x400/IMG_0017_(500px).jpg",
      "variant_1": "2740",
      "variant_2": "2741",
      "variant_3": 0,
      "variant_1_type": "Flavor",
      "variant_1_value": "Nougat",
      "variant_2_type": "Size",
      "variant_2_value": "10x20",
      "variant_3_type": "",
      "variant_3_value": "",
      "qty": "5",
      "note": "",
      "content":
          "<p><span>German style layer cake with light mocca butter cream and delicious topping on it.</span><span><br /></span></p>"
    }
  ];

  final promoDiPilih = ''.obs;

  final promoDiPilihL = <String, int>{}.obs;

  List<Widget> test() {
    List items = [
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
    ];

    var children = <Widget>[];
    children.add(const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text(
          'Promo',
          style: TextStyle(fontSize: 18),
        ),
      ),
    ));

    var hitung = items.length;

    for (var i = 0; i < hitung; i++) {
      // ignore: unnecessary_new
      children.add(new Container(
          color: Color.fromARGB(0, 255, 255, 255),
          child: ListTile(
            title: Text("Promo ${items[i]['nama']}"),
            subtitle: Text("${items[i]['ket']}"),
            leading: const Icon(
              Icons.sell_outlined,
            ),
            minLeadingWidth: 10,
            trailing: const Icon(Icons.more_vert),
            onTap: () {
              Get.back();
              print(hitung);
              // promoDiPilih.value = '';
              promoDiPilih.value = items[i]['nama'].toString();
              // update();
              print(promoDiPilih);
            },
          )));
    }

    return children;
  }
}
