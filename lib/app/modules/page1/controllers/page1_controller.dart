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

  Map<String, dynamic> promoDiPilih = {};

  void test() {
    print(dataCart);
  }
}
