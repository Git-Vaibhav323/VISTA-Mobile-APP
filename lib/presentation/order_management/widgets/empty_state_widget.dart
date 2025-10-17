import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final String userRole;
  final String currentFilter;
  final VoidCallback? onActionTap;

  const EmptyStateWidget({
    Key? key,
    required this.userRole,
    required this.currentFilter,
    this.onActionTap,
  }) : super(key: key);

  String _getEmptyTitle() {
    if (currentFilter == 'All') {
      return userRole == 'vendor' ? 'No Orders Yet' : 'No Orders Received';
    }
    return 'No ${currentFilter} Orders';
  }

  String _getEmptyMessage() {
    if (currentFilter == 'All') {
      return userRole == 'vendor'
          ? 'Start exploring suppliers and place your first order to grow your business.'
          : 'Orders from vendors will appear here. Promote your business to get more orders.';
    }
    return 'No orders found with ${currentFilter.toLowerCase()} status. Try checking other filters.';
  }

  String _getActionText() {
    if (currentFilter == 'All') {
      return userRole == 'vendor' ? 'Browse Suppliers' : 'Promote Business';
    }
    return 'View All Orders';
  }

  String _getIllustrationIcon() {
    if (currentFilter == 'All') {
      return userRole == 'vendor' ? 'shopping_cart' : 'store';
    }
    switch (currentFilter.toLowerCase()) {
      case 'pending':
        return 'hourglass_empty';
      case 'confirmed':
        return 'check_circle_outline';
      case 'delivered':
        return 'local_shipping';
      case 'cancelled':
        return 'cancel';
      default:
        return 'inbox';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getIllustrationIcon(),
                  size: 15.w,
                  color: AppTheme.primaryLight.withValues(alpha: 0.6),
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              _getEmptyTitle(),
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Message
            Text(
              _getEmptyMessage(),
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action Button
            if (onActionTap != null)
              ElevatedButton.icon(
                onPressed: onActionTap,
                icon: CustomIconWidget(
                  iconName: userRole == 'vendor' ? 'search' : 'campaign',
                  size: 20,
                  color: Colors.white,
                ),
                label: Text(_getActionText()),
                style: ElevatedButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),

            SizedBox(height: 2.h),

            // Secondary suggestions
            if (currentFilter != 'All') ...[
              TextButton(
                onPressed: () {
                  // This would reset filters - handled by parent
                },
                child: Text(
                  'Clear filters and view all orders',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryLight,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'lightbulb_outline',
                    size: 16,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 2.w),
                  Flexible(
                    child: Text(
                      userRole == 'vendor'
                          ? 'Tip: Use filters to find suppliers by location and price'
                          : 'Tip: Complete your profile to attract more vendors',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
