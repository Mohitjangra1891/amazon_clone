import 'package:amazon_clone/utils/colors.dart';
import 'package:amazon_clone/view/users/cart/cart.dart';
import 'package:amazon_clone/view/users/home/homepage.dart';
import 'package:amazon_clone/view/users/profile/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'menu/menu.dart';

class bottom_NavBar extends StatelessWidget {
  const bottom_NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    PersistentTabController _controller =
        PersistentTabController(initialIndex: 0);

    List<PersistentTabConfig> _tabs = [
      PersistentTabConfig(
        screen: const homePage(),
        item: ItemConfig(
            icon: const Icon(Icons.home_outlined),
            title: "Home",
            activeForegroundColor: teal,
            inactiveForegroundColor: Colors.black),
      ),
      PersistentTabConfig(
        screen: const profile_screen(),
        item: ItemConfig(
            icon: const Icon(Icons.person_2_outlined),
            title: "You",
            activeForegroundColor: teal,
            inactiveForegroundColor: Colors.black),
      ),
      PersistentTabConfig(
        screen: const cart_screen(),
        item: ItemConfig(
            icon: const Icon(Icons.shopping_cart_checkout_outlined),
            title: "Cart",
            activeForegroundColor: teal,
            inactiveForegroundColor: Colors.black),
      ),
      PersistentTabConfig(
        screen: const menu_screen(),
        item: ItemConfig(
            icon: const Icon(Icons.menu),
            title: "Menu",
            activeForegroundColor: teal,
            inactiveForegroundColor: Colors.black),
      ),
    ];
    return PersistentTabView(
        controller: _controller,
        tabs: _tabs,
        popAllScreensOnTapAnyTabs: true,
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.once,
        navBarBuilder: (navBarConfig) => Style4BottomNavBar(
              navBarConfig: navBarConfig,
              // navBarDecoration: const NavBarDecoration(
              //     border: Border(
              //         top: BorderSide(
              //             width: 1,
              //             color: Colors.black,
              //             style: BorderStyle.solid))),
            ));
  }
}
