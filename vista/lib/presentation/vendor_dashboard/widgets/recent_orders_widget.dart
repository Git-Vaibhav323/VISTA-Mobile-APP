import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentOrdersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> orders;
  final Function(Map<String, dynamic>)? onTrackOrder;
  final Function(Map<String, dynamic>)? onReorder;
  final Function(Map<String, dynamic>)? onContactSupplier;
  final VoidCallback? onViewAllOrders;

  const RecentOrdersWidget({
    Key? key,
    required this.orders,
    this.onTrackOrder,
    this.onReorder,
    this.onContactSupplier,
    this.onViewAllOrders,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Orders',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
              if (orders.isNotEmpty)
                TextButton(
                  onPressed: onViewAllOrders,
                  child: Text(
                    'View All',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          orders.isEmpty
              ? _buildEmptyState(context)
              : ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: orders.length > 3 ? 3 : orders.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(context, order);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'shopping_cart_outlined',
            color: AppTheme.textSecondaryLight,
            size: 12.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Recent Orders',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.textPrimaryLight,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Start by placing your first order from suppliers',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          ElevatedButton(
            onPressed: () {
              // Navigate to place order
            },
            child: Text('Place Order'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final String status = order['status'] as String? ?? 'pending';
    final Color statusColor = _getStatusColor(status);

    return Slidable(
      key: ValueKey(order['id']),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onTrackOrder?.call(order),
            backgroundColor: AppTheme.lightTheme.primaryColor,
            foregroundColor: Colors.white,
            icon: Icons.track_changes,
            label: 'Track',
          ),
          SlidableAction(
            onPressed: (context) => onReorder?.call(order),
            backgroundColor: AppTheme.successLight,
            foregroundColor: Colors.white,
            icon: Icons.refresh,
            label: 'Reorder',
          ),
          SlidableAction(
            onPressed: (context) => onContactSupplier?.call(order),
            backgroundColor: AppTheme.accentLight,
            foregroundColor: Colors.white,
            icon: Icons.message,
            label: 'Contact',
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.shadowLight,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    order['supplierName'] as String? ?? 'Unknown Supplier',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'shopping_bag',
                  color: AppTheme.textSecondaryLight,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  '${order['itemsCount'] ?? 0} items',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                SizedBox(width: 4.w),
                CustomIconWidget(
                  iconName: 'schedule',
                  color: AppTheme.textSecondaryLight,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    order['deliveryTime'] as String? ?? 'TBD',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order['orderNumber'] ?? 'N/A'}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondaryLight,
                  ),
                ),
                Text(
                  '₹${order['totalAmount'] ?? '0'}',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppTheme.successLight;
      case 'pending':
        return AppTheme.warningLight;
      case 'cancelled':
        return AppTheme.errorLight;
      case 'processing':
        return AppTheme.lightTheme.primaryColor;
      default:
        return AppTheme.textSecondaryLight;
    }
  }
}
