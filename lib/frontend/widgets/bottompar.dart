import 'package:calaroiscount/auth/user_info_page.dart';
import 'package:calaroiscount/frontend/screens/account/accountpage.dart';
import 'package:calaroiscount/frontend/screens/searchpages/FoodSearchPage.dart';
import 'package:calaroiscount/frontend/screens/calaroiscount/calaoriscountpage.dart';
import 'package:calaroiscount/frontend/screens/homePage/homepage.dart';
import 'package:calaroiscount/frontend/widgets/const.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class CustomeNavigationBar extends StatefulWidget {
  const CustomeNavigationBar({super.key});

  @override
  State<CustomeNavigationBar> createState() => _CustomeNavigationBarState();
}

class _CustomeNavigationBarState extends State<CustomeNavigationBar> {
  int _selectedIndex = 0; // لبدء التطبيق من العنصر الأوسط
  List<Widget> pages = [
    FoodAppHome(),
    Homepage(),
    RecipePage(),
    AccountPage(),
  ]; // قائمة الصفحات

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex], // عرض الصفحة بناءً على الفهرس المحدد
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex, // تحديد الفهرس الافتراضي
        backgroundColor: Color(0xFFF5F5F5), // خلفية الشريط
        animationDuration: const Duration(milliseconds: 300),
        color: kapp,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // تحديث الفهرس عند النقر
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.insert_chart_outlined_sharp, color: Colors.white),
          Icon(Icons.search, color: Colors.white),
          Icon(Icons.account_circle, color: Colors.white),
        ],
      ),
    );
  }
}
