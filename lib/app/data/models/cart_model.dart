class Cart {
  String? productId;
  String? title;
  Cover? cover;
  String? sku;
  String? price;
  String? sale;
  String? disc;
  String? previewId;
  String? img;
  String? variant1;
  String? variant2;
  int? variant3;
  String? variant1Type;
  String? variant1Value;
  String? variant2Type;
  String? variant2Value;
  String? variant3Type;
  String? variant3Value;
  String? qty;
  String? note;
  String? content;

  Cart(
      {this.productId,
      this.title,
      this.cover,
      this.sku,
      this.price,
      this.sale,
      this.disc,
      this.previewId,
      this.img,
      this.variant1,
      this.variant2,
      this.variant3,
      this.variant1Type,
      this.variant1Value,
      this.variant2Type,
      this.variant2Value,
      this.variant3Type,
      this.variant3Value,
      this.qty,
      this.note,
      this.content});

  Cart.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    title = json['title'];
    cover = json['cover'] != null ? Cover?.fromJson(json['cover']) : null;
    sku = json['sku'];
    price = json['price'];
    sale = json['sale'];
    disc = json['disc'];
    previewId = json['preview_id'];
    img = json['img'];
    variant1 = json['variant_1'];
    variant2 = json['variant_2'];
    variant3 = json['variant_3'];
    variant1Type = json['variant_1_type'];
    variant1Value = json['variant_1_value'];
    variant2Type = json['variant_2_type'];
    variant2Value = json['variant_2_value'];
    variant3Type = json['variant_3_type'];
    variant3Value = json['variant_3_value'];
    qty = json['qty'];
    note = json['note'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['title'] = title;
    if (cover != null) {
      data['cover'] = cover?.toJson();
    }
    data['sku'] = sku;
    data['price'] = price;
    data['sale'] = sale;
    data['disc'] = disc;
    data['preview_id'] = previewId;
    data['img'] = img;
    data['variant_1'] = variant1;
    data['variant_2'] = variant2;
    data['variant_3'] = variant3;
    data['variant_1_type'] = variant1Type;
    data['variant_1_value'] = variant1Value;
    data['variant_2_type'] = variant2Type;
    data['variant_2_value'] = variant2Value;
    data['variant_3_type'] = variant3Type;
    data['variant_3_value'] = variant3Value;
    data['qty'] = qty;
    data['note'] = note;
    data['content'] = content;
    return data;
  }
}

class Cover {
  String? s;
  String? m;
  String? l;

  Cover({this.s, this.m, this.l});

  Cover.fromJson(Map<String, dynamic> json) {
    s = json['s'];
    m = json['m'];
    l = json['l'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['s'] = s;
    data['m'] = m;
    data['l'] = l;
    return data;
  }

  static List<Cart> fromJsonList(List? data) {
    if (data == null || data.length == 0) return [];
    return data.map((e) => Cart.fromJson(e)).toList();
  }
}
