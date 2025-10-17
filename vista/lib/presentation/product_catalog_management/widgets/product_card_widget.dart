import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdateStock;
  final VoidCallback? onPriceUpdate;
  final VoidCallback? onStockAlert;
  final VoidCallback? onPromote;

  const ProductCardWidget({
    Key? key,
    required this.product,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
    this.onEdit,
    this.onDuplicate,
    this.onDelete,
    this.onUpdateStock,
    this.onPriceUpdate,
    this.onStockAlert,
    this.onPromote,
  }) : super(key: key);

  Color _getStockStatusColor() {
    final stockLevel = product['stockLevel'] as int? ?? 0;
    if (stockLevel <= 0) return AppTheme.errorLight;
    if (stockLevel <= 10) return AppTheme.warningLight;
    return AppTheme.successLight;
  }

  String _getStockStatusText() {
    final stockLevel = product['stockLevel'] as int? ?? 0;
    if (stockLevel <= 0) return 'Out of Stock';
    if (stockLevel <= 10) return 'Low Stock';
    return 'In Stock';
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(product['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onPriceUpdate?.call(),
            backgroundColor: AppTheme.primaryLight,
            foregroundColor: AppTheme.surfaceLight,
            icon: Icons.attach_money,
            label: 'Price',
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: (_) => onStockAlert?.call(),
            backgroundColor: AppTheme.warningLight,
            foregroundColor: AppTheme.surfaceLight,
            icon: Icons.notifications,
            label: 'Alert',
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: (_) => onPromote?.call(),
            backgroundColor: AppTheme.accentLight,
            foregroundColor: AppTheme.surfaceLight,
            icon: Icons.trending_up,
            label: 'Promote',
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryLight.withValues(alpha: 0.1)
                : AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.primaryLight : AppTheme.borderLight,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.shadowLight,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CustomImageWidget(
                      imageUrl: product['imageUrl'] as String? ?? '',
                      width: double.infinity,
                      height: 20.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'check',
                          color: AppTheme.surfaceLight,
                          size: 16,
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getStockStatusColor(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getStockStatusText(),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.surfaceLight,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Product Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product['name'] as String? ?? 'Unknown Product',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),

                      // Price
                      Text(
                        '₹${(product['price'] as double? ?? 0.0).toStringAsFixed(2)}',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 0.5.h),

                      // Stock Level
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'inventory',
                            color: AppTheme.textSecondaryLight,
                            size: 16,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            'Stock: ${product['stockLevel'] ?? 0}',
                            style: AppTheme.lightTheme.textTheme.bodySmall
                                ?.copyWith(
                              color: AppTheme.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Quick Edit Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: onEdit,
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: 'edit',
                              color: AppTheme.primaryLight,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
