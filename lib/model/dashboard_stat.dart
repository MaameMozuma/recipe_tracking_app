class DashboardStat {
  final int monthlyTotal;
  final int weeklyTotal;
  final List<double> monthlyData;
  final List<double> weeklyData;

  DashboardStat({
    required this.monthlyTotal,
    required this.weeklyTotal,
    required this.monthlyData,
    required this.weeklyData,
  });

  factory DashboardStat.fromJson(Map<String, dynamic> json) {
    final List<dynamic> monthlyRawData = json['monthly']['data'];
    final List<double> monthlyData = monthlyRawData.map((item) {
      return (item['count'] as num).toDouble();
    }).toList();

    final List<dynamic> weeklyRawData = json['weekly']['data'];
    final List<double> weeklyData = weeklyRawData.map((item) {
      return (item['count'] as num).toDouble();
    }).toList();

    return DashboardStat(
      monthlyTotal: json['monthly']['total'] as int,
      weeklyTotal: json['weekly']['total'] as int,
      monthlyData: monthlyData,
      weeklyData: weeklyData,
    );
  }
}
