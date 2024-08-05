import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:eziparcel_mobile/pages/tambah_janji_temu.dart';

class ButiranBungkusan extends StatelessWidget {
  final DocumentSnapshot document;

  const ButiranBungkusan({Key? key, required this.document}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String no_pengesanan = document['no_pengesanan'] ?? 'N/A';
    final String namaBungkusan = document['nama_bungkusan'] ?? 'N/A';
    final String bungkusanID = document['bungkusanID'] ?? 'N/A';
    final String staf = document['staf'] ?? 'N/A';
    final Timestamp? masaRekodTimestamp = document['masa_rekod'];
    final DateTime? masaRekod = masaRekodTimestamp?.toDate();
    final String formattedMasaRekod = masaRekod != null ? DateFormat('HHmm').format(masaRekod) : 'N/A';
    final String formattedTarikhRekod = masaRekod != null ? DateFormat('dd/MM/yyyy').format(masaRekod) : 'N/A';
    final String statusBungkusan = document['status_bungkusan'] ?? 'N/A';

    // Get the image URL from Firestore
    final String imageUrl = document['gambar_bungkusan'] ?? '';

    // Determine background color based on status
    Color statusBackgroundColor = Colors.transparent;
    if (statusBungkusan == 'Sedia Diambil') {
      statusBackgroundColor = Colors.yellowAccent.withOpacity(0.8); // Yellow background for "Sedia Diambil"
    } else if (statusBungkusan == 'Sudah Diambil') {
      statusBackgroundColor = Color.fromRGBO(61, 255, 3, 0.8); // Green background for "Sudah Diambil"
    }
      else if (statusBungkusan == 'Sila Ambil') {
        statusBackgroundColor = Color.fromRGBO(255,69,69,0.8); // Red background for "Sila Ambil"
      }

    return Scaffold(
      backgroundColor: const Color(0xFFECEDDA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1282),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            Image(
              image: AssetImage('images/logo4.png'),
              width: 200,
              height: 200,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFFECEDDA),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Center(
                  child: Text(
                    'BUTIRAN BUNGKUSAN',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
                thickness: 2,
                indent: 0,
                endIndent: 0,
              ),
              const SizedBox(height: 20),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'NO PENGESANAN :',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      no_pengesanan,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'NAMA :',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      namaBungkusan,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    // Displaying the image fetched from Firebase Storage
                    if (imageUrl.isNotEmpty)
                      FutureBuilder<String>(
                        future: _getImageUrl(imageUrl),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error loading image'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No image available'));
                          }
                          return Image.network(
                            snapshot.data!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    const SizedBox(height: 20),
                    _buildKeyValueRow('ID BUNGKUSAN :', bungkusanID),
                    _buildKeyValueRow('STAF :', staf),
                    _buildKeyValueRow('MASA DIREKOD :', formattedMasaRekod),
                    _buildKeyValueRow('TARIKH DIREKOD :', formattedTarikhRekod),
                    _buildKeyValueRow('STATUS BUNGKUSAN :', statusBungkusan, backgroundColor: statusBackgroundColor),
                    const SizedBox(height: 0),
                    if (statusBungkusan == 'Sila Ambil' )
                      FutureBuilder<String>(
                        future: _fetchMasaJanjiTemu(bungkusanID),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(child: Text('Error fetching janji temu'));
                          }
                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Center(child: Text('No janji temu available'));
                          }
                          return _buildKeyValueRow('JANJI TEMU :', snapshot.data!);
                        },
                      ),
                    const SizedBox(height: 10),
                    if (statusBungkusan == 'Sedia Diambil')
                      Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 1,
                          color: const Color(0xFFF0DE36),
                          shadowColor: Colors.black,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TambahJanjiTemu(
                                    bungkusanID: bungkusanID,
                                    namaBungkusan: namaBungkusan,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 200,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'TAMBAH JANJI TEMU',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeyValueRow(String key, String value, {Color backgroundColor = Colors.transparent}) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Future<String> _getImageUrl(String imagePath) async {
    try {
      // Get a reference to the Firebase Storage location
      final ref = firebase_storage.FirebaseStorage.instance.refFromURL(imagePath);

      // Get the download URL for the image
      final url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      // Return an error message or handle the exception as needed
      print('Error fetching image URL: $e');
      return '';
    }
  }

  Future<String> _fetchMasaJanjiTemu(String bungkusanID) async {
    try {
      // Query Firestore to get the corresponding janji temu document
      final QuerySnapshot janjiTemuSnapshot = await FirebaseFirestore.instance
          .collection('janjitemu')
          .where('bungkusanID', isEqualTo: bungkusanID)
          .get();

      // Check if any documents were found
      if (janjiTemuSnapshot.docs.isNotEmpty) {
        // Assuming there is only one document per bungkusanID
        final masaJT = janjiTemuSnapshot.docs.first['masa_jt'] ?? 'N/A';
        return masaJT.toString();
      } else {
        return 'N/A';
      }
    } catch (e) {
      // Return an error message or handle the exception as needed
      print('Error fetching janji temu: $e');
      return 'N/A';
    }
  }
}