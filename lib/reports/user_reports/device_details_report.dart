import 'package:first_time/reports/it_tasks/it_reports_received.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReportDetailsPage extends StatelessWidget {
  final String reportId;
  final int reportNumber;

  const ReportDetailsPage(
      {Key? key, required this.reportId, this.reportNumber = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          '  تفاصيل بلاغ رقم $reportNumber',
          textAlign: TextAlign.center,
          style: const TextStyle(
              fontFamily: 'Cario',
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 105, 142, 255),
                Color(0xFF00CCFF),
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
      ), //AppBar

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFD8F3FD),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('User_Reports')
              .doc(reportId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.data() == null) {
              return const Center(child: Text('لا يوجد تفاصيل للبلاغ'));
            }
            var reportData = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(15.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      reportData['imageUrl'] ?? 'assets/images/pc.png',
                      fit: BoxFit.fill,
                      height: 300,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'بلاغ رقم:\n $reportNumber',
                      style: const TextStyle(
                          fontFamily: 'Cario',
                          fontSize: 20,
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'التاريخ:',
                      style: TextStyle(
                          fontFamily: 'Cario',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan),
                    ),
                    Text(
                      ' ${DateFormat('dd/MM/yyyy').format(DateTime.parse(reportData['date'].toDate().toString()))}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cario',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'رقم الجهاز:',
                      style: TextStyle(
                          fontFamily: 'Cario',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan),
                    ),
                    Text(
                      ' ${reportData['device'] ?? 'No Device Number'}',
                      style: const TextStyle(
                        fontFamily: 'Cario',
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'الموقع:',
                      style: TextStyle(
                          fontFamily: 'Cario',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan),
                    ),
                    Text(
                      ' ${reportData['location'] ?? 'No Location'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Cario',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SafeArea(
                      child: Text(
                        'وصف المشكلة:',
                        style: TextStyle(
                            fontFamily: 'Cario',
                            fontSize: 20,
                            color: Colors.cyan,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      reportData['problem'] ?? 'No Description',
                      style: const TextStyle(
                        fontSize: 18,
                        // color: Colors.black,
                        fontFamily: 'Cario',
                      ),
                    ),
                    const SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ReportsReceived(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF0F92EF), // New color for the button
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'أستلام الطلب',
                        style: TextStyle(
                            fontFamily: 'Cario',
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
