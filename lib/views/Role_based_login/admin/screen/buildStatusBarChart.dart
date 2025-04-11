import 'package:charts_flutter/flutter.dart' as charts;
import '../../../../core/model/StatusReport.dart';
import 'package:flutter/material.dart';

Widget buildStatusBarChart(List<StatusReport> data) {
  final grouped = <String, List<StatusReport>>{};
  for (var report in data) {
    grouped.putIfAbsent(report.status, () => []).add(report);
  }

  final List<charts.Series<StatusReport, String>> seriesList =
      grouped.entries.map((entry) {
        return charts.Series<StatusReport, String>(
          id: entry.key,
          domainFn: (StatusReport r, _) => "${r.period.month}/${r.period.day}",
          measureFn: (StatusReport r, _) => r.totalSales,
          data: entry.value,
          labelAccessorFn:
              (StatusReport r, _) => r.totalSales.toStringAsFixed(0),
        );
      }).toList();

  return SizedBox(
    height: 300,
    child: charts.BarChart(
      seriesList,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [charts.SeriesLegend()],
    ),
  );
}
