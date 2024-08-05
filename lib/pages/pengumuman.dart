import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String PENGUMUMAN_COLLECTION_REF = "pengumuman";

class PengumumanPage extends StatelessWidget {
  const PengumumanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        color: const Color(0xFFECEDDA),
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 50.0, bottom: 10.0),
              child: Center(
                child: Text(
                  'PENGUMUMAN',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PengumumanList(),
            ),
          ],
        ),
      ),
    );
  }
}

class PengumumanList extends StatelessWidget {
  const PengumumanList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(PENGUMUMAN_COLLECTION_REF)
          .orderBy('masa', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          debugPrint('Error loading announcements: ${snapshot.error}');
          return const Center(child: Text('Error loading announcements'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No announcements available'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var doc = snapshot.data!.docs[index];
            var data = doc.data() as Map<String, dynamic>;
            return AnnouncementCard(
              title: data['tajuk'] ?? 'No title',
              author: data['staf'] ?? 'Unknown',
              content: data['isi'] ?? 'No content',
              timestamp: (data['masa'] as Timestamp?)?.toDate() ?? DateTime.now(),
            );
          },
        );
      },
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String author;
  final String content;
  final DateTime timestamp;

  const AnnouncementCard({
    required this.title,
    required this.author,
    required this.content,
    required this.timestamp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedTimestamp = DateFormat('dd-MM-yyyy HH:mm').format(timestamp.toLocal());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                author,
                style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Dimuat naik pada: $formattedTimestamp',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

