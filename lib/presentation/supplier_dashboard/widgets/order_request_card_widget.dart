import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderRequestCardWidget extends StatelessWidget {
  final Map<String, dynamic> orderData;
  final VoidCallback? onAccept;
  final VoidCallback? onDecline;
  final VoidCallback? onViewDetails;
  final VoidCallback? onContactVendor;

  const OrderRequestCardWidget({
    Key? key,
    required this.orderData,
    this.onAccept,
    this.onDecline,
    this.onViewDetails,
    this.onContactVendor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vendorName = (orderData['vendorName'] as String?) ?? 'Unknown Vendor';
    final orderValue = (orderData['orderValue'] as String?) ?? '₹0';
    final itemsCount = (orderData['itemsCount'] as int?) ?? 0;
    final orderTime = (orderData['orderTime'] as String?) ?? 'Just now';
    final vendorImage = (orderData['vendorImage'] as String?) ?? '';
    final priority = (orderData['priority'] as String?) ?? 'normal';

    return Slidable(
      key: ValueKey(orderData['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onAccept?.call(),
            backgroundColor: AppTheme.successLight,
            foregroundColor: Colors.white,
            icon: Icons.check,
            label: 'Accept',
            borderRadius: BorderRadius.circular(12),
          ),
          SlidableAction(
            onPressed: (_) => onDecline?.call(),
            backgroundColor: AppTheme.errorLight,
            foregroundColor: Colors.white,
            icon: Icons.close,
            label: 'Decline',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: priority == 'urgent'
              ? Border.all(color: AppTheme.errorLight, width: 2)
              : null,
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
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.colorScheme.outline,
                  ),
                  child: vendorImage.isNotEmpty
                      ? ClipOval(
                          child: CustomImageWidget(
                            imageUrl: vendorImage,
                            width: 12.w,
                            height: 12.w,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'person',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 6.w,
                        ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vendorName,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (priority == 'urgent')
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 2.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color:
                                    AppTheme.errorLight.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'URGENT',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: AppTheme.errorLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Text(
                        orderTime,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Value',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        orderValue,
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Items',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        '$itemsCount items',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onViewDetails,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      side: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                      ),
                    ),
                    child: Text(
                      'View Details',
                      style: AppTheme.lightTheme.textTheme.labelLarge,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onContactVendor,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                    child: Text(
                      'Contact',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
