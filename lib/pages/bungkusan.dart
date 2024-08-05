import 'package:eziparcel_mobile/pages/butiran_bungkusan.dart';
import 'package:eziparcel_mobile/util/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BungkusanPage extends StatefulWidget {
  const BungkusanPage({Key? key}) : super(key: key);

  @override
  _BungkusanPageState createState() => _BungkusanPageState();
}

class _BungkusanPageState extends State<BungkusanPage> {
  bool _bungkusanFound = false;
  String _searchQuery = '';

  void _searchBungkusan(String query) {
    setState(() {
      _searchQuery = query.toUpperCase();;
    });
  }

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
              )
          ],
        ),
      ),
      backgroundColor: const Color(0xFFECEDDA), 
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 70.0),
                const Center(
                  child: Text(
                    'CARIAN BUNGKUSAN',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 130.0), 
                const Center(
                  child: Text(
                    'NO PENGESANAN :',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0), 
                Center(
                  child: CSearchBar(
                    onSubmitted: _searchBungkusan,
                  ),
                ),

                const SizedBox(height: 20.0),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('bungkusan')
                      .where('no_pengesanan', isEqualTo: _searchQuery)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error searching bungkusan'));
                    }
                    if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                      final document = snapshot.data!.docs.first;
                      return Column(
                        children: [
                          const Text(
                            'BUNGKUSAN DIJUMPAI!',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 32, 136, 35),
                            ),
                          ),
                          const SizedBox(height: 20.0),
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
                                      builder: (context) => ButiranBungkusan(document: document),
                                    ),
                                  );
                                },
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  width: 120,
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
                                      'BUTIRAN',
                                      style: TextStyle(
                                        fontSize: 20,
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
                      );
                    } else {
                      return _searchQuery.isNotEmpty
                        ? const Center(
                          child: Text(
                            'Bungkusan Tidak Dijumpai\nCuba Sebentar Lagi',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        )
                        : const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
