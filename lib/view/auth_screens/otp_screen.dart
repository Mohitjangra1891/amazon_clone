import 'package:amazon_clone/controller/providers/authScreen_Provider.dart';
import 'package:amazon_clone/controller/services/auth_services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../costants/commonFunctions.dart';
import '../../utils/colors.dart';

class otp_screen extends StatelessWidget {
  String mobile_number;
  otp_screen({super.key, required this.mobile_number});

  @override
  Widget build(BuildContext context) {
    final auth_provider = Provider.of<authScreen_provider>(context);
    TextEditingController otp_controller = TextEditingController();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final texttheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: appbar_with_logo(height),
      body: Container(
        width: width,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.03, vertical: height * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Authentication Required',
              style:
                  texttheme.displaySmall!.copyWith(fontWeight: FontWeight.w600),
            ),
            commonFunctions.blankSpace(height: height * 0.01),
            Text(
              '${mobile_number}',
              style:
                  texttheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
            ),
            commonFunctions.blankSpace(height: height * 0.01),
            Text(
              'We have sent a One Time Password (OTP) to the above mobile number above. Please enter it to complete verification',
              style: texttheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
            ),
            commonFunctions.blankSpace(height: height * 0.02),
            SizedBox(
                height: height * 0.07,
                width: width,
                child: TextFormField(
                  controller: otp_controller,
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
                      hintText: "Enter OTP"),
                )),
            commonFunctions.blankSpace(height: height * 0.02),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const otp_screen()));
                auth_service.verifyOTp(
                    context: context,
                    otp: otp_controller.text.toString().trim());
              },
              style: ElevatedButton.styleFrom(
                elevation: 6.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backgroundColor: amber,
                minimumSize: Size(width, height * 0.07),
              ),
              child: Text(
                'Continue',
                style:
                    texttheme.bodyLarge!.copyWith(fontWeight: FontWeight.w200),
              ),
            ),
            commonFunctions.blankSpace(height: height * 0.02),
            Align(
              alignment: Alignment.center,
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Resend OTP',
                    style: texttheme.bodyMedium!.copyWith(color: Colors.blue),
                  )),
            ),
            commonFunctions.blankSpace(height: height * 0.02),
            bottom_info_widget(width, height, texttheme),
          ],
        ),
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
