import 'package:amazon_clone/controller/services/user_data_crud_service/user_data_crud_serivice.dart';
import 'package:flutter/material.dart';

import '../../models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  List<AddressModel> allAdressModel = [];
  AddressModel currentSelectedAddress = AddressModel();
  bool fetchedCurrentSelectedAddress = false;
  bool fetchedAllAddress = false;
  bool addressPresent = false;

  getAllAddress() async {
    allAdressModel = await userData_CRUD.getAllAddress();
    fetchedAllAddress = true;
    notifyListeners();
  }

  getCurrentSelectedAddress() async {
    currentSelectedAddress = await userData_CRUD.getCurrentSelectedAddress();
    addressPresent = await userData_CRUD.checkUsersAddress();
    fetchedCurrentSelectedAddress = true;

    notifyListeners();
  }
}
