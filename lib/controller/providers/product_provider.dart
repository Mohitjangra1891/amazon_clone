import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../services/product_services/product_service.dart';

class SellerProductProvider extends ChangeNotifier {
  List<File> productImages = [];
  List<String> productImagesURL = [];
  List<ProductModel> products = [];
  bool sellerProductsFetched = false;

  fetchProductImagesFromGallery({required BuildContext context}) async {
    log("fetchProductImagesFromGallery--SellerProductProvider");

    productImages = await ProductServices.getImages(context: context);
    notifyListeners();
  }

  updateProductImagesURL({required List<String> imageURLs}) async {
    productImagesURL = imageURLs;
    notifyListeners();
  }

  fecthSellerProducts() async {
    log("fetchSellerProducts-----SellerProductProvider");
    products = await ProductServices.getSellersProducts();
    sellerProductsFetched = true;
    notifyListeners();
  }

  emptyProductImagesList() {
    log("empty product images-----SellerProductProvider");

    productImages = [];
    notifyListeners();
  }
}
