import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddProduct;

  const EmptyStateWidget({
    Key? key,
    required this.onAddProduct,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty State Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'inventory_2',
                  color: AppTheme.primaryLight,
                  size: 64,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'No Products Yet',
              style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'Start building your product catalog by adding your first product. You can take photos, scan barcodes, or enter details manually.',
              style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                color: AppTheme.textSecondaryLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Add Product Button
            SizedBox(
              width: 60.w,
              child: ElevatedButton.icon(
                onPressed: onAddProduct,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: AppTheme.surfaceLight,
                  size: 20,
                ),
                label: Text('Add Your First Product'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),

            SizedBox(height: 3.h),

            // Quick Tips
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.backgroundLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.borderLight),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Tips:',
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  _buildTipItem('📷', 'Use camera to capture product photos'),
                  _buildTipItem('📱', 'Scan barcodes for quick product entry'),
                  _buildTipItem('📊', 'Set stock levels and price alerts'),
                  _buildTipItem('🏷️', 'Organize products by categories'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String emoji, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          Text(
            emoji,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
