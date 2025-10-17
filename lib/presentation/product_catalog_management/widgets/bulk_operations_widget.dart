import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkOperationsWidget extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onUpdatePrices;
  final VoidCallback onUpdateStock;
  final VoidCallback onUpdateCategories;
  final VoidCallback onDeleteSelected;
  final VoidCallback onClearSelection;

  const BulkOperationsWidget({
    Key? key,
    required this.selectedCount,
    required this.onUpdatePrices,
    required this.onUpdateStock,
    required this.onUpdateCategories,
    required this.onDeleteSelected,
    required this.onClearSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Selection Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$selectedCount items selected',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: onClearSelection,
                child: Text(
                  'Clear',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryLight,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Bulk Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: 'attach_money',
                  label: 'Update Prices',
                  onTap: onUpdatePrices,
                  color: AppTheme.primaryLight,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildActionButton(
                  icon: 'inventory',
                  label: 'Update Stock',
                  onTap: onUpdateStock,
                  color: AppTheme.secondaryLight,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: 'category',
                  label: 'Categories',
                  onTap: onUpdateCategories,
                  color: AppTheme.warningLight,
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildActionButton(
                  icon: 'delete',
                  label: 'Delete',
                  onTap: onDeleteSelected,
                  color: AppTheme.errorLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: color,
              size: 24,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
