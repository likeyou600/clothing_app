import 'package:clothing_app/View/upload.dart';
import 'package:clothing_app/View/postpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'comment.dart';

class community extends StatefulWidget {
  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {
  int _selectedIndex = 0;

  static final List<Widget> _communityView = [
    const postpage(),
    const upload(),
  ]; //要切到的頁面

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: Center(
          child: _communityView.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30), topLeft: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                items: _navBarItem
                    .map(
                      (f) => BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          f.icon,
                          width: 24.0,
                        ),
                        activeIcon: SvgPicture.asset(
                          f.activeIcon,
                          width: 24.0,
                        ),
                        title: Text(f.title),
                      ),
                    )
                    .toList(),
              ),
            )));
  }
}

List<NavBarModel> _navBarItem = [
  NavBarModel(
    icon: "assets/home.svg",
    activeIcon: "assets/home_2.svg",
    title: "Home",
  ),
  NavBarModel(
    icon: "assets/add.svg",
    activeIcon: "assets/add.svg",
    title: "Add",
  ),
  NavBarModel(
    icon: "assets/favorite.svg",
    activeIcon: "assets/favorite_2.svg",
    title: "Notifications",
  ),
  NavBarModel(
    icon: "assets/account.svg",
    activeIcon: "assets/account_2.svg",
    title: "Account",
  ),
];

class NavBarModel {
  final String icon;
  final String activeIcon;
  final String title;
  NavBarModel(
      {required this.icon, required this.activeIcon, required this.title});
}