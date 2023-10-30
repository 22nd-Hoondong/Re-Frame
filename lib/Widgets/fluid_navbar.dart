import 'package:flutter/material.dart';

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
      shape: const CircularNotchedRectangle(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _navItems.map((item) {
          var index = _navItems.indexOf(item);
          return IconButton(
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