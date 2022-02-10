import 'package:clothing_app/View/community_profile.dart';
import 'package:clothing_app/View/community_ranking.dart';
import 'package:clothing_app/View/notification.dart';
import 'package:clothing_app/View/ALL_postpage.dart';
import 'package:clothing_app/View/upload.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class community extends StatefulWidget {
  @override
  _communityState createState() => _communityState();
}

class _communityState extends State<community> {
  int _selectedIndex = 0;
  static final List<Widget> _communityView = [
    ALL_postpage(),
    notification(),
    upload(),
    community_ranking(),
    community_profile(),
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
        body: Container(
          child: _communityView.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.only(
            //       topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            //   // boxShadow: [
            //   //   BoxShadow(
            //   //       color: Colors.black38, spreadRadius: 0, blurRadius: 10),
            //   // ],
            // ),
            child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color.fromRGBO(234, 219, 128, 1.0),
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
                    label: f.title,
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
    icon: "assets/favorite.svg",
    activeIcon: "assets/favorite_2.svg",
    title: "search",
  ),
  NavBarModel(
    icon: "assets/add.svg",
    activeIcon: "assets/add.svg",
    title: "Add",
  ),
  NavBarModel(
    icon: "assets/bookmark.svg",
    activeIcon: "assets/bookmark.svg",
    title: "bookmark",
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
