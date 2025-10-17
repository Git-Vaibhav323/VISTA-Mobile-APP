import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LowStockAlertsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> lowStockItems;
  final Function(Map<String, dynamic>)? onReorderItem;
  final VoidCallback? onViewInventory;

  const LowStockAlertsWidget({
    Key? key,
    required this.lowStockItems,
    this.onReorderItem,
    this.onViewInventory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lowStockItems.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'warning',
                    color: AppTheme.errorLight,
                    size: 5.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Low Stock Alerts',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.errorLight,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: onViewInventory,
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
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.errorLight.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.errorLight.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      lowStockItems.length > 3 ? 3 : lowStockItems.length,
                  separatorBuilder: (context, index) => Divider(
                    color: AppTheme.borderLight,
                    height: 2.h,
                  ),
                  itemBuilder: (context, index) {
                    final item = lowStockItems[index];
                    return _buildLowStockItem(context, item);
                  },
                ),
                if (lowStockItems.length > 3) ...[
                  Divider(color: AppTheme.borderLight, height: 2.h),
                  Text(
                    '+${lowStockItems.length - 3} more items need restocking',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockItem(BuildContext context, Map<String, dynamic> item) {
    final int currentStock = item['currentStock'] as int? ?? 0;
    final int suggestedQuantity = item['suggestedQuantity'] as int? ?? 0;
    final String unit = item['unit'] as String? ?? 'pcs';

    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: AppTheme.errorLight.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: 'inventory_2',
            color: AppTheme.errorLight,
            size: 6.w,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['itemName'] as String? ?? 'Unknown Item',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimaryLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  Text(
                    'Stock: $currentStock $unit',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.errorLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    '• Suggested: $suggestedQuantity $unit',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        ElevatedButton(
          onPressed: () => onReorderItem?.call(item),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.primaryColor,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Reorder',
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
