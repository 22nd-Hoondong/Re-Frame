import 'package:flutter/material.dart';
import 'package:re_frame/main.dart';

class FluidNavBar extends StatefulWidget {
  final PageController pageController;
  final Color defaultColor;
  const FluidNavBar({
    super.key,
    required this.pageController,
    required this.defaultColor,
  });

  @override
  FluidNavBarState createState() => FluidNavBarState();
}

class FluidNavBarState extends State<FluidNavBar> {
  int _selectedIndex = 0;

  final List<NavItem> _navItems = [
    NavItem(Icons.image, "Image"),
    NavItem(Icons.calendar_today, "Calendar"),
    NavItem(Icons.chat, ""),
    NavItem(Icons.group, "Group"),
    NavItem(Icons.settings, "Settings"),
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      widget.pageController.jumpToPage(_selectedIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 70,
      color: defaultBackgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _navItems.map((item) {
          var index = _navItems.indexOf(item);
          if (index == 2) {
            return const IconButton(
              onPressed: null,
              icon: Icon(null)
            );
          }
          return IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () => _onNavItemTapped(index),
            icon: Icon(
              item.icon,
              color: _selectedIndex == index ? widget.defaultColor : Colors.grey,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class NavItem {
  IconData icon;
  String title;

  NavItem(this.icon, this.title);
}