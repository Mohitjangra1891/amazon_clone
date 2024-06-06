import 'package:amazon_clone/view/users/home/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../costants/commonFunctions.dart';
import '../../../utils/colors.dart';
import '../../auth_screens/auth_Screen.dart';
import '../../seller/add_product_screen/add_product_screen.dart';

class menu_screen extends StatelessWidget {
  const menu_screen({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(width * 1, height * 0.1),
          child: home_AppBar(width: width, height: height)),
      body: SingleChildScrollView(
        child: Container(
            width: width,
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.03,
              vertical: height * 0.02,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: appBarGradientColor,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              children: [
                GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 0.7),
                    shrinkWrap: true,
                    physics: const PageScrollPhysics(),
                    itemCount: 18,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/images/menu_pics/$index.png'),
                            fit: BoxFit.fill,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          border: Border.all(
                            color: greyShade3,
                          ),
                        ),
                      );
                    }),
                commonFunctions.blankSpace(
                  height: height * 0.02,
                  width: 0,
                ),
                ListView.builder(
                    itemCount: 2,
                    shrinkWrap: true,
                    physics: const PageScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: height * 0.005),
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.005,
                          horizontal: width * 0.03,
                        ),
                        height: height * 0.06,
                        width: width,
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          border: Border.all(
                            color: teal,
                          ),
                        ),
                        child: Row(children: [
                          InkWell(
                            child: Text(
                              index == 0 ? 'Settings' : 'Customer Service',
                              style: textTheme.bodyMedium,
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddProductScreen()));
                            },
                          ),
                          const Spacer(),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: black,
                          )
                        ]),
                      );
                    })
              ],
            )),
      ),
    );
  }
}
