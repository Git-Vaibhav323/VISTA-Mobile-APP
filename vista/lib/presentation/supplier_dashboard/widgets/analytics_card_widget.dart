import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class AnalyticsCardWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> chartData;
  final String chartType;

  const AnalyticsCardWidget({
    Key? key,
    required this.title,
    required this.chartData,
    this.chartType = 'line',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            height: 20.h,
            child: chartType == 'line' ? _buildLineChart() : _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() < chartData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      (chartData[value.toInt()]['label'] as String?) ?? '',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                );
              },
              reservedSize: 42,
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        minX: 0,
        maxX: (chartData.length - 1).toDouble(),
        minY: 0,
        maxY: _getMaxValue().toDouble(),
        lineBarsData: [
          LineChartBarData(
            spots: chartData.asMap().entries.map((entry) {
              return FlSpot(
                entry.key.toDouble(),
                ((entry.value['value'] as num?) ?? 0).toDouble(),
              );
            }).toList(),
            isCurved: true,
            gradient: LinearGradient(
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
              ],
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  strokeWidth: 2,
                  strokeColor: AppTheme.lightTheme.colorScheme.surface,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxValue().toDouble(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: AppTheme.lightTheme.colorScheme.inverseSurface,
            tooltipHorizontalAlignment: FLHorizontalAlignment.center,
            tooltipMargin: -10,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${rod.toY.round()}',
                AppTheme.lightTheme.textTheme.bodySmall!.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onInverseSurface,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (value.toInt() < chartData.length) {
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    child: Text(
                      (chartData[value.toInt()]['label'] as String?) ?? '',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  );
                }
                return Container();
              },
              reservedSize: 38,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (double value, TitleMeta meta) {
                return Text(
                  value.toInt().toString(),
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: false,
        ),
        barGroups: chartData.asMap().entries.map((entry) {
          return BarChartGroupData(
            x: entry.key,
            barRods: [
              BarChartRodData(
                toY: ((entry.value['value'] as num?) ?? 0).toDouble(),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.lightTheme.colorScheme.primary,
                    AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.7),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                width: 16,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              strokeWidth: 1,
            );
          },
        ),
      ),
    );
  }

  int _getMaxValue() {
    if (chartData.isEmpty) return 10;
    final maxValue = chartData
        .map((data) => (data['value'] as num?) ?? 0)
        .reduce((a, b) => a > b ? a : b);
    return (maxValue * 1.2).ceil();
  }
}