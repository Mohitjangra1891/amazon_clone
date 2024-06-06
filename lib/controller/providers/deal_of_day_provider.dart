import 'dart:developer';

import 'package:flutter/material.dart';

import '../../models/product_model.dart';
import '../services/user_product_services.dart';

class DealOfTheDayProvider extends ChangeNotifier {
  List<ProductModel> deals = [];
  bool dealsFetched = false;

  fetchTodaysDeal() async {
    log("fetchTodalDEal-------dealOfTheDayProvider");
    deals = [];
    deals = await UsersProductService.featchDealOfTheDay();
    dealsFetched = true;
    notifyListeners();
  }
}
