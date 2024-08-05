import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

const String STATUS_OPERASI_COLLECTION_REF = "statusoperasi";

class StatusOperasiPage extends StatelessWidget {
  const StatusOperasiPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection(STATUS_OPERASI_COLLECTION_REF)
                .doc('SO1')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading status operasi'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('No status operasi data available'));
              }

              var data = snapshot.data!.data() as Map<String, dynamic>;
              bool status = data['status'] ?? false;
              String tarikh = data['tarikh'] ?? 'Unknown';
              String masaBuka = data['masabuka'] ?? 'Unknown';
              String masaTutup = data['masatutup'] ?? 'Unknown';
              Timestamp? updatedAtTimestamp = data['updated_at'];
              String updatedAt = updatedAtTimestamp != null
                  ? DateFormat('MMMM dd, hh:mm:ss a').format(updatedAtTimestamp.toDate())
                  : 'Unknown';

              // Parse operating hours
              DateTime now = DateTime.now();
              DateTime bukaTime = _parseTime(masaBuka);
              DateTime tutupTime = _parseTime(masaTutup);

              // Determine if the shop is currently open or closed
              bool isOpen = now.isAfter(bukaTime) && now.isBefore(tutupTime);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50.0, bottom: 30.0),
                    child: Center(
                      child: Text(
                        'STATUS OPERASI',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        child: Opacity(
                          opacity: isOpen ? 1 : 0.3,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'BUKA',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 140,
                        child: Opacity(
                          opacity: isOpen ? 0.3 : 1,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'TUTUP',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(60.0),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              'TARIKH :',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 35),
                            child: Text(
                              tarikh,
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              'MASA OPERASI :',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 35),
                            child: Text(
                              '$masaBuka - $masaTutup',
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              'DIKEMASKINI PADA :',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 35),
                            child: Text(
                              updatedAt,
                              style: const TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  DateTime _parseTime(String time) {
    final now = DateTime.now();
    final timeParts = time.split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    return DateTime(now.year, now.month, now.day, hours, minutes);
  }
}
