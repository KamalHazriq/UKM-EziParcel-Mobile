import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eziparcel_mobile/home.dart';
import 'package:intl/intl.dart'; // Add intl package for date formatting
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class TambahJanjiTemu extends StatefulWidget {
  final String bungkusanID;
  final String namaBungkusan;

  const TambahJanjiTemu(
      {Key? key, required this.bungkusanID, required this.namaBungkusan})
      : super(key: key);

  @override
  _TambahJanjiTemuState createState() => _TambahJanjiTemuState();
}

class _TambahJanjiTemuState extends State<TambahJanjiTemu> {
  String _selectedTime = ''; // Selected time variable
  final TextEditingController _wakilController = TextEditingController();
  List<Map<String, dynamic>> _timeSlots =
      []; // List to store available time slots

  @override
  void initState() {
    super.initState();
    // Fetch available time slots when the widget initializes
    _fetchAvailableTimeSlots();
  }

  Future<void> _fetchAvailableTimeSlots() async {
    try {
      // Query Firestore to get slots data
      final QuerySnapshot slotsSnapshot =
          await FirebaseFirestore.instance.collection('slot_jt').get();

      setState(() {
        _timeSlots = slotsSnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'time': _parseFirestoreTime(data['waktu']),
            'slots': data['slots']
                .where((slot) => slot['status'] == 'kosong')
                .length,
          };
        }).toList();

        // Sort the time slots by time in ascending order
        _timeSlots.sort((a, b) => a['time'].compareTo(b['time']));

        // Filter out past time slots
        _timeSlots.removeWhere((slot) => slot['time'].isBefore(DateTime.now()));

        // Set initial selected time to the first available time slot if available
        if (_timeSlots.isNotEmpty) {
          _selectedTime = _formatTime(
              _timeSlots.firstWhere((slot) => slot['slots'] > 0)['time']);
        }
      });
    } catch (e) {
      print('Error fetching available time slots: $e');
      // Handle error fetching data from Firestore
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Failed to fetch available time slots. Please try again later.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  DateTime _parseFirestoreTime(String timeString) {
    // Implement your custom date parsing logic here
    // Example: Parse time in 'HH:mm' format
    final timeParts = timeString.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Construct DateTime object with dummy date (today's date)
    return DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, hour, minute);
  }

  String _formatTime(DateTime time) {
    // Format DateTime object to 'HH:mm' string
    final DateFormat formatter = DateFormat('HH:mm');
    return formatter.format(time);
  }

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                  child: Center(
                    child: Text(
                      'TAMBAH JANJI TEMU',
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
                        'ID BUNGKUSAN :',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.bungkusanID,
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
                      const SizedBox(height: 20),
                      Text(
                        widget.namaBungkusan,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'MASA :',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      DropdownButton<String>(
                        value: _selectedTime,
                        hint: const Text('Pilih Masa'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTime = newValue!;
                          });
                        },
                        items: _timeSlots.map((slot) {
                          final time = _formatTime(slot['time']);
                          final slotsLeft = slot['slots'];
                          return DropdownMenuItem<String>(
                            value: time, // Ensure each value is unique
                            enabled: slotsLeft > 0,
                            child: Text(
                              '$time   $slotsLeft slot${slotsLeft > 1 ? 's' : ''}',
                              style: TextStyle(
                                color:
                                    slotsLeft == 0 ? Colors.red : Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'WAKIL :',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _wakilController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Masukkan Nama Wakil',
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 1,
                          color: const Color(0xFFF0DE36),
                          shadowColor: Colors.black,
                          child: InkWell(
                            onTap: () {
                              // Handle save action
                              _saveAppointment();
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
                                  'SIMPAN',
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveAppointment() async {
    try {
      // Validate if both dropdown and wakil are selected
      if (_selectedTime.isEmpty || _wakilController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.transparent,
            duration: Duration(seconds: 3), // Set duration to 3 seconds
            content: AwesomeSnackbarContent(
              title: 'Oops!',
              message: 'Sila pilih masa janji temu dan masukkan nama wakil',
              contentType: ContentType.failure,
            ),
          ),
        );
        return;
      }

      // Prepare data for Firestore document
      String selectedTime = _selectedTime;
      String wakil = _wakilController.text;

      // Query Firestore to find a slot with 'kosong' status
      final QuerySnapshot slotSnapshot = await FirebaseFirestore.instance
          .collection('slot_jt')
          .where('waktu', isEqualTo: selectedTime)
          .limit(1)
          .get();

      // Check if a slot is found
      if (slotSnapshot.docs.isNotEmpty) {
        final docRef = slotSnapshot.docs.first.reference;
        final data = slotSnapshot.docs.first.data() as Map<String, dynamic>;

        // Find the first 'kosong' slot and update its status
        List<dynamic> slots =
            List.from(data['slots']); // Use List.from for type safety

        bool slotUpdated = false;

        for (var i = 0; i < slots.length; i++) {
          if (slots[i]['status'] == 'kosong') {
            slots[i]['status'] = 'diambil';
            slotUpdated = true;
            break; // Stop after updating the first available slot
          }
        }

        if (slotUpdated) {
          await docRef.update({'slots': slots});

          // Buat janji temu
          await FirebaseFirestore.instance.collection('janjitemu').add({
            'bungkusanID': widget.bungkusanID,
            'nama_bungkusan': widget.namaBungkusan,
            'masa_jt': selectedTime,
            'wakil_jt': wakil,
            'created_at': Timestamp.now(),
          });

          // kemaskini status terbaru
          final QuerySnapshot bungkusanSnapshot = await FirebaseFirestore
              .instance
              .collection('bungkusan')
              .where('bungkusanID', isEqualTo: widget.bungkusanID)
              .get();

          if (bungkusanSnapshot.docs.isNotEmpty) {
            final bungkusanRef = bungkusanSnapshot.docs.first.reference;

            await bungkusanRef.update({
              'status_bungkusan': 'Sila Ambil',
            });
          } else {
            print('No document found with bungkusanID: ${widget.bungkusanID}');
          }

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 3), // Set duration to 3 seconds
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Janji Temu Berjaya Dibuat',
                message:
                      'Sila sebutkan ID Bungkusan anda (${widget.bungkusanID}) semasa mengambil bungkusan.',
                contentType: ContentType.success,
              ),
            ),
          );

          // Navigate to home page
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );

          // Clear the wakil controller after saving
          _wakilController.clear();
          _fetchAvailableTimeSlots(); // Refresh available slots
        } else {
          print('No available slots found for selected time.');
        }
      }
    } catch (e) {
      print('Error saving appointment: $e');
      // Handle error saving data to Firestore
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          backgroundColor: Colors.transparent,
          // Set duration to 3 seconds
          content: AwesomeSnackbarContent(
            title: 'Error',
            message:
                'Tidak berjaya membuat Janji Temu. Sila cuba Sebentar Lagi',
            contentType: ContentType.failure,
          ),
        ),
      );
    }
  }
}
