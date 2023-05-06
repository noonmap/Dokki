import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:flutter/material.dart';

class UserYearChart extends StatefulWidget {
  const UserYearChart({
    super.key,
    required this.up,
    required this.userId,
    required this.year,
  });

  final UserProvider up;
  final int userId, year;

  @override
  State<UserYearChart> createState() => _UserYearChartState();
}

class _UserYearChartState extends State<UserYearChart> {
  late int _year;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UserYearChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.year != widget.year) {
      _year = widget.year;
      widget.up.getUserMonthlyCount(userId: widget.userId, year: _year);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<dynamic, String>> series = [
      charts.Series(
        id: 'yearChart',
        data: widget.up.userMonthlyCount,
        domainFn: (dynamic series, _) => series.month.toString(),
        measureFn: (dynamic series, _) => series.count,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(brandColor300),
      )
    ];

    return Flexible(
      fit: FlexFit.tight,
      child: charts.BarChart(
        series,
        animate: true,
      ),
    );
  }
}
