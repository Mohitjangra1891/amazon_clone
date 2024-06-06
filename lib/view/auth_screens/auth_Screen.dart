import 'package:amazon_clone/controller/providers/authScreen_Provider.dart';
import 'package:amazon_clone/controller/services/auth_services/auth_service.dart';
import 'package:amazon_clone/costants/commonFunctions.dart';
import 'package:amazon_clone/costants/images.dart';
import 'package:amazon_clone/utils/colors.dart';
import 'package:amazon_clone/view/auth_screens/otp_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class auth_Screen extends StatefulWidget {
  const auth_Screen({super.key});

  @override
  State<auth_Screen> createState() => _auth_ScreenState();
}

class _auth_ScreenState extends State<auth_Screen> {
  // bool inlogin = false;
  String countryCode = "+91";
  TextEditingController signIn_textfield_controller = TextEditingController();
  TextEditingController signUp_textfield_controller = TextEditingController();
  TextEditingController name_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final texttheme = Theme.of(context).textTheme;
    final auth_provider = Provider.of<authScreen_provider>(context);
    return Scaffold(
        appBar: appbar_with_logo(height),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.03, vertical: height * 0.02),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Welcome',
                  style: texttheme.displaySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                commonFunctions.blankSpace(height: height * 0.02),
                auth_provider.inlogin
                    ? signIn_widget(width, height, auth_provider, texttheme)
                    : signUp_widget(width, height, auth_provider, texttheme),

                ///bottom
                commonFunctions.blankSpace(height: height * 0.05),
                bottom_info_widget(width, height, texttheme),
              ],
            ),
          ),
        ));
  }

  Container signUp_widget(double width, double height,
      authScreen_provider auth_provider, TextTheme texttheme) {
    return Container(
      width: width,
      decoration: BoxDecoration(border: Border.all(color: greyShade3)),
      child: Column(
        children: [
          Container(
            // height: height * 0.06,
            width: width,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.01),
            child: Column(
              children: [
                Row(
                  children: [
                    ///checkbox--------
                    InkWell(
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.05,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: grey),
                            shape: BoxShape.circle,
                            color: Colors.white),
                        child: Icon(
                          Icons.circle,
                          size: height * 0.013,
                          color: secondaryColor,
                        ),
                      ),
                      onTap: () {
                        // auth_provider.change_islogin(true);
                      },
                    ),
                    commonFunctions.blankSpace(width: width * 0.02),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'Create Account. ',
                        style: texttheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: 'New to Amazon? ', style: texttheme.bodyMedium!)
                    ]))
                  ],
                ),
                commonFunctions.blankSpace(height: height * 0.02),
                SizedBox(
                    height: height * 0.06,
                    width: width,
                    child: TextFormField(
                      controller: name_controller,
                      style: texttheme.bodySmall,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: grey)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: grey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(color: grey)),
                          hintText: "First and last name"),
                    )),
                commonFunctions.blankSpace(height: height * 0.02),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: height * 0.06,
                        width: width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: greyShade2,
                            border: Border.all(color: grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: CountryCodePicker(
                          initialSelection: auth_provider.current_countryCode,
                          showFlag: false,
                          showFlagDialog: true,
                          onChanged: (value) {
                            auth_provider.change_country_code(
                                value.toCountryStringOnly());
                            // countryCode =
                            //     value.toCountryStringOnly();

                            print(auth_provider.current_countryCode);
                          },
                          textStyle: texttheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        )),
                    commonFunctions.blankSpace(width: width * 0.01),
                    SizedBox(
                        height: height * 0.06,
                        width: width * 0.66,
                        child: TextFormField(
                          controller: signUp_textfield_controller,
                          keyboardType: TextInputType.number,
                          style: texttheme.bodySmall,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: grey)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: grey)),
                              hintText: "Mobile number"),
                        ))
                  ],
                ),
                commonFunctions.blankSpace(height: height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    context.read<authScreen_provider>().set_mobileNumber(
                        signUp_textfield_controller.text.trim().toString());

                    auth_service.recieveOTP(
                        context: context,
                        mobile_no: auth_provider.mobileNumber);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: amber,
                    minimumSize: Size(width * 0.90, height * 0.07),
                  ),
                  child: Text(
                    'Verify mobile number',
                    style: texttheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w200),
                  ),
                ),
                commonFunctions.blankSpace(height: height * 0.03),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text:
                          'By creating an account or logging in, you agree to Amazon\'s ',
                      style: texttheme.labelMedium!,
                    ),
                    TextSpan(
                        text: 'Condition of Use',
                        style: texttheme.labelMedium!
                            .copyWith(color: Colors.blue)),
                    TextSpan(text: ' and ', style: texttheme.labelMedium!),
                    TextSpan(
                        text: 'Privacy Policy',
                        style: texttheme.labelMedium!
                            .copyWith(color: Colors.blue)),
                  ])),
                ),
                commonFunctions.blankSpace(height: height * 0.02),
              ],
            ),
          ),

          ///region sign In
          Container(
            height: height * 0.06,
            width: width,
            decoration: BoxDecoration(
                border: Border(top: BorderSide(color: greyShade3)),
                color: greyShade1),
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.01),
            child: Row(
              children: [
                ///checkbox--------
                InkWell(
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: grey),
                        shape: BoxShape.circle,
                        color: Colors.white),
                    child: Icon(
                      Icons.circle,
                      size: height * 0.013,
                      color:
                          !auth_provider.inlogin ? transparent : secondaryColor,
                    ),
                  ),
                  onTap: () {
                    auth_provider.change_islogin(true);
                  },
                ),
                commonFunctions.blankSpace(width: width * 0.02),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'Sign In. ',
                    style: texttheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: 'Already a customer? ',
                      style: texttheme.bodyMedium!)
                ]))
              ],
            ),
          ),

          ///endregion
        ],
      ),
    );
  }

  Container signIn_widget(double width, double height,
      authScreen_provider auth_provider, TextTheme texttheme) {
    return Container(
      width: width,
      decoration: BoxDecoration(border: Border.all(color: greyShade3)),
      child: Column(
        children: [
          Container(
            height: height * 0.06,
            width: width,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: greyShade3)),
                color: greyShade1),
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.01),
            child: Row(
              children: [
                ///checkbox--------
                InkWell(
                  child: Container(
                    height: height * 0.05,
                    width: width * 0.05,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: grey),
                        shape: BoxShape.circle,
                        color: Colors.white),
                    child: Icon(
                      Icons.circle,
                      size: height * 0.013,
                      color:
                          auth_provider.inlogin ? transparent : secondaryColor,
                    ),
                  ),
                  onTap: () {
                    auth_provider.change_islogin(false);
                  },
                ),
                commonFunctions.blankSpace(width: width * 0.02),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'Create Account. ',
                    style: texttheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text: 'New to Amazon? ', style: texttheme.bodyMedium!)
                ]))
              ],
            ),
          ),

          Container(
            // height: height * 0.06,
            width: width,
            padding: EdgeInsets.symmetric(
                horizontal: width * 0.02, vertical: height * 0.01),
            child: Column(
              children: [
                Row(
                  children: [
                    ///checkbox--------
                    InkWell(
                      child: Container(
                        height: height * 0.05,
                        width: width * 0.05,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(color: grey),
                            shape: BoxShape.circle,
                            color: Colors.white),
                        child: Icon(
                          Icons.circle,
                          size: height * 0.013,
                          color: !auth_provider.inlogin
                              ? transparent
                              : secondaryColor,
                        ),
                      ),
                      onTap: () {
                        auth_provider.change_islogin(true);
                      },
                    ),
                    commonFunctions.blankSpace(width: width * 0.02),
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                        text: 'Sign IN. ',
                        style: texttheme.bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                          text: 'Already a customer ? ',
                          style: texttheme.bodyMedium!)
                    ]))
                  ],
                ),
                commonFunctions.blankSpace(height: height * 0.02),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: height * 0.06,
                        width: width * 0.2,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: greyShade2,
                            border: Border.all(color: grey),
                            borderRadius: BorderRadius.circular(5)),
                        child: CountryCodePicker(
                          initialSelection: auth_provider.current_countryCode,
                          showFlag: false,
                          showFlagDialog: true,
                          onChanged: (value) {
                            auth_provider.change_country_code(
                                value.toCountryStringOnly());
                            // countryCode =
                            //     value.toCountryStringOnly();

                            print(auth_provider.current_countryCode);
                          },
                          textStyle: texttheme.bodySmall!
                              .copyWith(fontWeight: FontWeight.w500),
                        )),
                    commonFunctions.blankSpace(width: width * 0.01),
                    SizedBox(
                        height: height * 0.06,
                        width: width * 0.66,
                        child: TextFormField(
                          controller: signIn_textfield_controller,
                          keyboardType: TextInputType.number,
                          style: texttheme.bodySmall,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: grey)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: grey)),
                              disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: grey)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(color: grey)),
                              hintText: "Mobile number"),
                        ))
                  ],
                ),
                commonFunctions.blankSpace(height: height * 0.02),
                ElevatedButton(
                  onPressed: () {
                    auth_provider.change_is_loading(true);
                    auth_provider.set_mobileNumber(
                        signIn_textfield_controller.text.toString().trim());

                    auth_service.recieveOTP(
                        context: context,
                        mobile_no: auth_provider.mobileNumber);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    backgroundColor: amber,
                    minimumSize: Size(width * 0.90, height * 0.07),
                  ),
                  child: auth_provider.isloading
                      ? const CircularProgressIndicator(
                          color: Colors.black,
                        )
                      : Text(
                          'continue',
                          style: texttheme.displaySmall!
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                ),
                commonFunctions.blankSpace(height: height * 0.03),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: 'By continuing you agree to Amazon\'s ',
                      style: texttheme.labelMedium!,
                    ),
                    TextSpan(
                        text: 'Condition of Use',
                        style: texttheme.labelMedium!
                            .copyWith(color: Colors.blue)),
                    TextSpan(text: ' and ', style: texttheme.labelMedium!),
                    TextSpan(
                        text: 'Privacy Policy',
                        style: texttheme.labelMedium!
                            .copyWith(color: Colors.blue)),
                  ])),
                ),
                commonFunctions.blankSpace(height: height * 0.02),
              ],
            ),
          ),

          ///
        ],
      ),
    );
  }

  Column bottom_info_widget(double width, double height, TextTheme texttheme) {
    return Column(
      children: [
        Container(
          height: 2,
          width: width,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [white, greyShade3, white])),
        ),
        commonFunctions.blankSpace(height: height * 0.02),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Conditions of Use",
              style: texttheme.bodyMedium!.copyWith(color: blue),
            ),
            Text(
              "Privacy Policy",
              style: texttheme.bodyMedium!.copyWith(color: blue),
            ),
            Text(
              "Help",
              style: texttheme.bodyMedium!.copyWith(color: blue),
            )
          ],
        ),
        commonFunctions.blankSpace(height: height * 0.01),
        Align(
          alignment: Alignment.center,
          child: Text(
            '@ 1996-2024, Amazon.com, Inc, or its affiliates',
            style: texttheme.labelMedium!.copyWith(color: grey),
          ),
        ),
      ],
    );
  }
}
