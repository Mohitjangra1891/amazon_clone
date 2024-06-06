import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class authScreen_provider extends ChangeNotifier {
  bool inlogin = true;
  bool isloading = false;
  bool isloading_OTP = false;
  String current_countryCode = "+91";

  String mobileNumber = "";
  String verificationID = "";

  void set_mobileNumber(String num) {
    // mobileNumber = "+91$num";
    mobileNumber = '+91 ${num.substring(0, 5)} ${num.substring(5)}';
    print("mobile is $mobileNumber");
    notifyListeners();
  }

  void ser_verificationID(String verID) {
    verificationID = verID;
    notifyListeners();
  }

  void change_country_code(String countrycode) {
    current_countryCode = countrycode;
    notifyListeners();
  }

  void change_islogin(bool value) {
    inlogin = value;
    notifyListeners();
  }

  void change_is_loading(bool value) {
    isloading = value;
    notifyListeners();
  }

  void change_is_loadingOTP(bool value) {
    isloading_OTP = value;
    notifyListeners();
  }
}
