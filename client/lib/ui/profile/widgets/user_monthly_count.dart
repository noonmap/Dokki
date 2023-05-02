import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dokki/constants/colors.dart';
import 'package:dokki/data/model/user/user_monthly_count_model.dart';
import 'package:dokki/ui/common_widgets/paragraph.dart';
import 'package:flutter/material.dart';

class UserMonthlyCount extends StatelessWidget {
  const UserMonthlyCount({
    super.key,
    required this.data,
  });

  final List<UserMonthlyCountModel> data;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<UserMonthlyCountModel, String>> series = [
      charts.Series(
        id: 'MonthlyCount',
        data: data,
        domainFn: (UserMonthlyCountModel series, _) => series.month.toString(),
        measureFn: (UserMonthlyCountModel series, _) => series.count,
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(brandColor300),
      )
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Paragraph(
          text: '한 해 기록',
          size: 20,
          weightType: WeightType.semiBold,
        ),
        const SizedBox(height: 20),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Paragraph(
              text: '2023',
              size: 20,
              weightType: WeightType.semiBold,
            ),
          ],
        ),
        Flexible(
          fit: FlexFit.tight,
          child: charts.BarChart(
            series,
            animate: true,
          ),
        ),
      ],
    );
  }
}
