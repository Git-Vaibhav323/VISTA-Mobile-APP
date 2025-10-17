import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onFilterTap;
  final VoidCallback onDateRangeTap;
  final String? selectedDateRange;

  const SearchFilterBarWidget({
    Key? key,
    required this.searchController,
    required this.onFilterTap,
    required this.onDateRangeTap,
    this.selectedDateRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search orders, suppliers, or order ID...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                      .withValues(alpha: 0.6),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    size: 20,
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () => searchController.clear(),
                        child: Padding(
                          padding: EdgeInsets.all(2.w),
                          child: CustomIconWidget(
                            iconName: 'clear',
                            size: 18,
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: onFilterTap,
                      child: Container(
                        margin: EdgeInsets.only(right: 3.w),
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: 'tune',
                          size: 18,
                          color: AppTheme.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),
            ),
          ),

          SizedBox(height: 1.h),

          // Date Range Filter
          GestureDetector(
            onTap: onDateRangeTap,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: selectedDateRange != null
                    ? AppTheme.primaryLight.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedDateRange != null
                      ? AppTheme.primaryLight.withValues(alpha: 0.3)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'date_range',
                    size: 20,
                    color: selectedDateRange != null
                        ? AppTheme.primaryLight
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      selectedDateRange ?? 'Select date range',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: selectedDateRange != null
                            ? AppTheme.primaryLight
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        fontWeight: selectedDateRange != null
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (selectedDateRange != null)
                    GestureDetector(
                      onTap: () {
                        // Clear date range - this would be handled by parent
                      },
                      child: CustomIconWidget(
                        iconName: 'clear',
                        size: 18,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
