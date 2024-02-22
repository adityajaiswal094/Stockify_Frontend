import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CustomLineChart extends StatelessWidget {
  final List<dynamic> stockData;

  const CustomLineChart({super.key, required this.stockData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: stockData
                  .map<FlSpot>(
                    (ele) => FlSpot(
                      (stockData.indexOf(ele)).toDouble(),
                      double.parse(ele['close']),
                    ),
                  )
                  .toList(),
              isCurved: true,
              dotData: const FlDotData(
                show: false,
              ),
              color: /* Theme.of(context).colorScheme.onPrimary, */
                  Colors.amber,
            ),
          ],
          borderData: FlBorderData(
            border: const Border(
              bottom: BorderSide(),
              left: BorderSide(),
            ),
          ),
          titlesData: const FlTitlesData(
            bottomTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Theme.of(context).colorScheme.onPrimary,
              tooltipRoundedRadius: 5.0,
              showOnTopOfTheChartBoxArea: true,
              fitInsideHorizontally: true,
              tooltipMargin: 0,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map(
                  (LineBarSpot touchedSpot) {
                    return LineTooltipItem(
                      stockData[touchedSpot.spotIndex]['date']
                          .substring(0, 10),
                      Theme.of(context).textTheme.labelSmall!,
                      children: [
                        TextSpan(
                          text:
                              ", ${stockData[touchedSpot.spotIndex]['close']}",
                        )
                      ],
                    );
                  },
                ).toList();
              },
            ),
          ),
        ),
        duration: const Duration(milliseconds: 150),
        curve: Curves.linear,
      ),
    );
  }
}
