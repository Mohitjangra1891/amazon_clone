import 'package:amazon_clone/view/seller/inventory_screen.dart';
import 'package:amazon_clone/view/seller/moniter_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import '../../../utils/colors.dart';

class SellerBottomNavBar extends StatefulWidget {
  const SellerBottomNavBar({super.key});

  @override
  State<SellerBottomNavBar> createState() => _SellerBottomNavBarState();
}

class _SellerBottomNavBarState extends State<SellerBottomNavBar> {
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  List<PersistentTabConfig> _navBarsItems() {
    return [
      PersistentTabConfig(
        screen: const Inventory_screen(),
        item: ItemConfig(
            icon: const Icon(Icons.inventory_2_outlined),
            title: "Inventory",
            activeForegroundColor: teal,
            inactiveForegroundColor: Colors.black),
      ),
      PersistentTabConfig(
        screen: const monitor_screen(),
        item: ItemConfig(
            icon: const Icon(Icons.bar_chart_outlined),
            title: "Monitor",
            activeForegroundColor: teal,
            inactiveForegroundColor: Colors.black),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        controller: controller,
        tabs: _navBarsItems(),
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        popAllScreensOnTapOfSelectedTab: true,
        popAllScreensOnTapAnyTabs: true,
        popActionScreens: PopActionScreensType.all,
        screenTransitionAnimation: const ScreenTransitionAnimation(
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarBuilder: (navBarConfig) => Style4BottomNavBar(
              navBarConfig: navBarConfig,
              navBarDecoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.white,
              ),
            ));
  }
}
