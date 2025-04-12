import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/model/StatusReport.dart';

Widget buildStatusBarChart(List<StatusReport> data) {
  // Өдрөөр бүлэглэх
  final grouped = <String, double>{};
  for (var report in data) {
    final key = "${report.period.month}/${report.period.day}";
    grouped[key] = (grouped[key] ?? 0) + report.totalSales;
  }

  final barGroups =
      grouped.entries.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final e = entry.value;
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: e.value,
              color: Colors.blue,
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }).toList();

  return SizedBox(
    height: 300,
    child: BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) {
                if (value < grouped.length) {
                  return Text(
                    grouped.keys.elementAt(value.toInt()),
                    style: TextStyle(fontSize: 10),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}
