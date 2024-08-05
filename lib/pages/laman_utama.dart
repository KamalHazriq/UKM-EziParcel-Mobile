import 'package:eziparcel_mobile/util/square_button.dart';
import 'package:flutter/material.dart';

class LamanUtamaPage extends StatelessWidget {
  
  final void Function(int) onPageSelected;

  const LamanUtamaPage({Key? key, required this.onPageSelected}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1282),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image(
                image: AssetImage('images/logo4.png'),
                width: 200,
                height: 200,
              ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'Selamat',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Datang!',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFECEDDA),
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 50.0, bottom: 10.0),
                child: Center(
                  child: Text(
                    'Selamat Datang ke UKM EziParcel,',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 50.0),
                child: Center(
                  child: Text(
                    'Sila Tekan Fungsi di Bawah!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SquareButtons(
                icon: Icons.search,
                text: 'Bungkusan',
                onPressed: () {
                  onPageSelected(1); 
                },
              ),
              SquareButtons(
                icon: Icons.timer_sharp,
                text: 'Status Operasi',
                onPressed: () {
                  onPageSelected(2);
                },
              ),
              SquareButtons(
                icon: Icons.notifications,
                text: 'Pengumuman',
                onPressed: () {
                  onPageSelected(3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
