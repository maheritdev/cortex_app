import 'package:cortex/feature/home/presentation/view/home_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../core/const/colors.dart';
import '../../core/utils/shared_preferences_helper.dart';
import '../profile/presentation/view/profile_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  // Define your pages/screens here
  final List<Widget> _pages = [
    HomeScreen(), // Your home screen
    ProfileScreen(), // You'll need to create this
    // Add more screens as needed
  ];
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

  }

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  _initializeApp() async {
    await SharedPreferencesHelper.init();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_getAppBarTitle(), style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: COLORs.TopBGColor,
      ),
      body: _pages[_currentIndex], // This displays the current page
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        elevation: 0,
        backgroundColor: COLORs.TopBGColor,
        foregroundColor: Colors.white,
        tooltip: "Add",
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Feature coming soon!"),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ));
         // _getUserData();
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: COLORs.BGColor.withAlpha(50),
        shape: CircularNotchedRectangle(),
        notchMargin: 5,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Home',
                    onPressed: () => _onItemTapped(0),
                    icon: Icon(
                      Icons.home_filled,
                      color: _currentIndex == 0 ? COLORs.TopBGColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Profile',
                    onPressed: () => _onItemTapped(1),
                    icon: Icon(
                      Icons.person,
                      color: _currentIndex == 1 ? COLORs.TopBGColor : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Profile';
      default:
        return 'Home';
    }
  }
}