import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DashboardMetricsWidget extends StatelessWidget {
  final int todayOrders;
  final int lowStockAlerts;
  final int pendingDeliveries;
  final VoidCallback? onTodayOrdersTap;
  final VoidCallback? onLowStockTap;
  final VoidCallback? onPendingDeliveriesTap;

  const DashboardMetricsWidget({
    Key? key,
    required this.todayOrders,
    required this.lowStockAlerts,
    required this.pendingDeliveries,
    this.onTodayOrdersTap,
    this.onLowStockTap,
    this.onPendingDeliveriesTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: _buildMetricCard(
              context: context,
              title: 'Today\'s Orders',
              value: todayOrders.toString(),
              icon: 'shopping_bag',
              color: AppTheme.lightTheme.primaryColor,
              onTap: onTodayOrdersTap,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildMetricCard(
              context: context,
              title: 'Low Stock',
              value: lowStockAlerts.toString(),
              icon: 'warning',
              color: lowStockAlerts > 0
                  ? AppTheme.errorLight
                  : AppTheme.successLight,
              onTap: onLowStockTap,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildMetricCard(
              context: context,
              title: 'Pending',
              value: pendingDeliveries.toString(),
              icon: 'local_shipping',
              color: AppTheme.warningLight,
              onTap: onPendingDeliveriesTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required BuildContext context,
    required String title,
    required String value,
    required String icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: () {
        // Show detailed analytics on long press
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Detailed analytics for $title'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
