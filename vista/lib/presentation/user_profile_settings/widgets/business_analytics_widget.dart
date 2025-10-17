import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessAnalyticsWidget extends StatelessWidget {
  final Map<String, dynamic> analyticsData;

  const BusinessAnalyticsWidget({
    Key? key,
    required this.analyticsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Business Analytics',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to detailed analytics
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  'Total Orders',
                  analyticsData['totalOrders']?.toString() ?? '0',
                  'shopping_cart',
                  AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildAnalyticsCard(
                  'Revenue',
                  '₹${analyticsData['revenue']?.toString() ?? '0'}',
                  'trending_up',
                  AppTheme.successLight,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildAnalyticsCard(
                  'Rating',
                  '${analyticsData['rating']?.toString() ?? '0.0'}/5.0',
                  'star',
                  AppTheme.warningLight,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildAnalyticsCard(
                  'Growth',
                  '+${analyticsData['growth']?.toString() ?? '0'}%',
                  'trending_up',
                  AppTheme.successLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
      String title, String value, String icon, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 24,
              ),
              Container(
                padding: EdgeInsets.all(1.w),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: CustomIconWidget(
                  iconName: 'trending_up',
                  color: color,
                  size: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            title,
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
