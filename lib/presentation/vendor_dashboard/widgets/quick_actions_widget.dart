import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback? onPlaceOrderTap;
  final VoidCallback? onCheckInventoryTap;
  final VoidCallback? onViewSuppliersTap;

  const QuickActionsWidget({
    Key? key,
    this.onPlaceOrderTap,
    this.onCheckInventoryTap,
    this.onViewSuppliersTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: 'Place New Order',
                  subtitle: 'Order from suppliers',
                  icon: 'add_shopping_cart',
                  color: AppTheme.lightTheme.primaryColor,
                  onTap: onPlaceOrderTap,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildActionCard(
                  context: context,
                  title: 'Check Inventory',
                  subtitle: 'View stock levels',
                  icon: 'inventory',
                  color: AppTheme.secondaryLight,
                  onTap: onCheckInventoryTap,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildActionCard(
            context: context,
            title: 'View Suppliers',
            subtitle: 'Browse and compare suppliers in your area',
            icon: 'store',
            color: AppTheme.accentLight,
            onTap: onViewSuppliersTap,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String icon,
    required Color color,
    VoidCallback? onTap,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: isFullWidth
            ? Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: icon,
                        color: color,
                        size: 5.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryLight,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          subtitle,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondaryLight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: AppTheme.textSecondaryLight,
                    size: 4.w,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: icon,
                        color: color,
                        size: 5.w,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    title,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }
}
