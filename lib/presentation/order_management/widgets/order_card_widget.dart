import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final String userRole;
  final VoidCallback? onTap;
  final VoidCallback? onTrack;
  final VoidCallback? onReorder;
  final VoidCallback? onContact;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onUpdateStatus;
  final VoidCallback? onGenerateInvoice;

  const OrderCardWidget({
    Key? key,
    required this.order,
    required this.userRole,
    this.onTap,
    this.onTrack,
    this.onReorder,
    this.onContact,
    this.onAccept,
    this.onDecline,
    this.onUpdateStatus,
    this.onGenerateInvoice,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.warningLight;
      case 'confirmed':
        return AppTheme.primaryLight;
      case 'delivered':
        return AppTheme.successLight;
      case 'cancelled':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String status = order['status'] as String? ?? 'pending';
    final String orderId = order['orderId'] as String? ?? '';
    final String businessName = order['businessName'] as String? ?? '';
    final double totalAmount =
        (order['totalAmount'] as num?)?.toDouble() ?? 0.0;
    final int itemCount = order['itemCount'] as int? ?? 0;
    final String estimatedTime = order['estimatedTime'] as String? ?? '';
    final DateTime orderDate =
        order['orderDate'] as DateTime? ?? DateTime.now();

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          businessName,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          'Order #$orderId',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(status).withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.w600,
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 2.h),

              // Order Details Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'shopping_bag',
                              size: 16,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '$itemCount items',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'access_time',
                              size: 16,
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              estimatedTime.isNotEmpty ? estimatedTime : 'TBD',
                              style: AppTheme.lightTheme.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${totalAmount.toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${orderDate.day}/${orderDate.month}/${orderDate.year}',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Progress Indicator for confirmed orders
              if (status.toLowerCase() == 'confirmed') ...[
                SizedBox(height: 2.h),
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'local_shipping',
                        size: 20,
                        color: AppTheme.primaryLight,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order in Progress',
                              style: AppTheme.lightTheme.textTheme.labelMedium
                                  ?.copyWith(
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            LinearProgressIndicator(
                              value: 0.6,
                              backgroundColor:
                                  AppTheme.primaryLight.withValues(alpha: 0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryLight),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              SizedBox(height: 2.h),

              // Action Buttons
              Row(
                children: [
                  if (userRole == 'vendor') ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onTrack,
                        icon: CustomIconWidget(
                          iconName: 'track_changes',
                          size: 16,
                          color: AppTheme.primaryLight,
                        ),
                        label: Text('Track'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReorder,
                        icon: CustomIconWidget(
                          iconName: 'refresh',
                          size: 16,
                          color: AppTheme.primaryLight,
                        ),
                        label: Text('Reorder'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onContact,
                        icon: CustomIconWidget(
                          iconName: 'chat',
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text('Contact'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                        ),
                      ),
                    ),
                  ] else if (userRole == 'supplier') ...[
                    if (status.toLowerCase() == 'pending') ...[
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onAccept,
                          icon: CustomIconWidget(
                            iconName: 'check',
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text('Accept'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.successLight,
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onDecline,
                          icon: CustomIconWidget(
                            iconName: 'close',
                            size: 16,
                            color: AppTheme.errorLight,
                          ),
                          label: Text('Decline'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.errorLight,
                            side: BorderSide(color: AppTheme.errorLight),
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onUpdateStatus,
                          icon: CustomIconWidget(
                            iconName: 'update',
                            size: 16,
                            color: AppTheme.primaryLight,
                          ),
                          label: Text('Update'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onGenerateInvoice,
                          icon: CustomIconWidget(
                            iconName: 'receipt',
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text('Invoice'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
