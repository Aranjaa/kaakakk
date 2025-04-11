class StatusReport {
  final String status;
  final DateTime period;
  final double totalSales;
  final int totalOrders;

  StatusReport({
    required this.status,
    required this.period,
    required this.totalSales,
    required this.totalOrders,
  });
}
