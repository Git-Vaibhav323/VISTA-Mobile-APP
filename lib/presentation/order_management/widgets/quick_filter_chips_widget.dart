import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickFilterChipsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> filters;
  final List<String> selectedFilters;
  final Function(String) onFilterToggle;

  const QuickFilterChipsWidget({
    Key? key,
    required this.filters,
    required this.selectedFilters,
    required this.onFilterToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final String filterKey = filter['key'] as String;
          final String filterLabel = filter['label'] as String;
          final String filterIcon = filter['icon'] as String;
          final bool isSelected = selectedFilters.contains(filterKey);

          return GestureDetector(
            onTap: () => onFilterToggle(filterKey),
            child: Container(
              margin: EdgeInsets.only(right: 3.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryLight.withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryLight
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: filterIcon,
                    size: 16,
                    color: isSelected
                        ? AppTheme.primaryLight
                        : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    filterLabel,
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (isSelected) ...[
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: 'check_circle',
                      size: 14,
                      color: AppTheme.primaryLight,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
