import 'package:flutter/material.dart';

class Prodak {
  @required
  String judul;
  @required
  String imageUrl;
  @required
  int harga;
  @required
  String dekskripsi;

  Prodak(this.imageUrl, this.judul, this.harga, this.dekskripsi);
}
