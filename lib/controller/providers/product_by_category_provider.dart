import 'dart:developer';

import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../services/user_product_services.dart';

class ProductsBasedOnCategoryProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  bool productsFetched = false;

  fetchProducts({required String category}) async {
    log("fetchProducts-----ProductsBasedOnCategoryProvider");
    products = [];
    products = await UsersProductService.fetchProductBasedOnCategory(
        category: category);
    productsFetched = true;
    notifyListeners();
  }
}
