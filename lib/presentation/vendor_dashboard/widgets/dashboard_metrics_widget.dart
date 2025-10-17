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
        constraints: BoxConstraints(
          minHeight: 12.h, // Reduced minimum height
          maxWidth: 30.w,  // Maximum width constraint
        ),
        padding: EdgeInsets.all(8), // Proper padding as requested
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
          mainAxisSize: MainAxisSize.min, // Dynamic height based on content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon container
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: icon,
                  color: color,
                  size: 4.w,
                ),
              ),
            ),
            
            // Spacing
            SizedBox(height: 8),
            
            // Value text with flexible sizing
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            
            // Spacing
            SizedBox(height: 4),
            
            // Title text with flexible sizing
            Flexible(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondaryLight,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
