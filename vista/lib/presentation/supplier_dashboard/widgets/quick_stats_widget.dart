import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> statsData;

  const QuickStatsWidget({
    Key? key,
    required this.statsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
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
            'Quick Stats',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...statsData.map((stat) => _buildStatItem(stat)).toList(),
        ],
      ),
    );
  }

  Widget _buildStatItem(Map<String, dynamic> stat) {
    final title = (stat['title'] as String?) ?? '';
    final value = (stat['value'] as String?) ?? '';
    final trend = (stat['trend'] as String?) ?? '';
    final trendDirection = (stat['trendDirection'] as String?) ?? 'neutral';

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: _getTrendColor(trendDirection).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: _getTrendIcon(trendDirection),
                  color: _getTrendColor(trendDirection),
                  size: 3.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  trend,
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getTrendColor(trendDirection),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getTrendColor(String direction) {
    switch (direction.toLowerCase()) {
      case 'up':
        return AppTheme.successLight;
      case 'down':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getTrendIcon(String direction) {
    switch (direction.toLowerCase()) {
      case 'up':
        return 'trending_up';
      case 'down':
        return 'trending_down';
      default:
        return 'trending_flat';
    }
  }
}
