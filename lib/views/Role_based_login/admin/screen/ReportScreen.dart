import 'package:flutter/material.dart';
import './buildStatusBarChart.dart';
import '../../../../core/model/StatusReport.dart';
import '../../../../services/api_service.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  late Future<List<StatusReport>> _statusData;

  @override
  void initState() {
    super.initState();
    final apiService = ApiService(); // ✅ объект үүсгэж байна
    _statusData = apiService.fetchWeeklyStatusReport(); // ✅ зөв дуудлага
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Борлуулалтын тайлан'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<StatusReport>>(
          future: _statusData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Алдаа гарлаа: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Тайлангийн өгөгдөл олдсонгүй.'));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Статусын дагуух борлуулалт (7 хоногоор):',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  buildStatusBarChart(snapshot.data!), // <-- таны график функц
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
