import 'package:eziparcel_mobile/pages/bungkusan.dart';
import 'package:eziparcel_mobile/pages/laman_utama.dart';
import 'package:eziparcel_mobile/pages/pengumuman.dart';
import 'package:eziparcel_mobile/pages/status_operasi.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Index for the selected tab
  int _selectedIndex = 0;

  late List<Widget> _children;

  @override
  void initState() {
    super.initState();
    _children = [
      LamanUtamaPage(onPageSelected: onPageSelected),
      const BungkusanPage(),
      const StatusOperasiPage(),
      const PengumumanPage(),
    ];
  }

  void onPageSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _children[_selectedIndex]),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1282),
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: GNav(
              backgroundColor: const Color(0xFF0D1282),
              iconSize: 30,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: const Color(0xFFFF3131),
              padding: const EdgeInsets.all(16),
              gap: 8,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Laman Utama',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Bungkusan',
                ),
                GButton(
                  icon: Icons.timer_sharp,
                  text: 'Status Operasi',
                ),
                GButton(
                  icon: Icons.notifications,
                  text: 'Pengumuman',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: onPageSelected,
            ),
          ),
        ),
      ),
    );
  }
}