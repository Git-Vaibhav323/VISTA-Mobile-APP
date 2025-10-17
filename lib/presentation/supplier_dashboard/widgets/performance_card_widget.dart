import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PerformanceCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color? valueColor;
  final CustomIconWidget? icon;

  const PerformanceCardWidget({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.valueColor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: 25.w,
        maxWidth: 30.w,
        minHeight: 10.h,
        maxHeight: 18.h, // Prevent excessive height
      ),
      child: Container(
        width: 28.w,
        padding: EdgeInsets.all(6), // Slightly reduced padding
        decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
        mainAxisSize: MainAxisSize.min, // Dynamic height based on content
        children: [
          // Title row with icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 3,
                child: Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2, // Allow wrapping for longer titles
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (icon != null) 
                Flexible(
                  flex: 1,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 4.w,
                      maxHeight: 4.w,
                    ),
                    child: icon!,
                  ),
                ),
            ],
          ),
          
          // Spacing between elements
          SizedBox(height: 8),
          
          // Value text - main content
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.sp,
                  color: valueColor ?? AppTheme.lightTheme.colorScheme.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          
          // Spacing between elements
          SizedBox(height: 4),
          
          // Subtitle text
          Flexible(
            child: Text(
              subtitle,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                fontSize: 8.sp,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 2, // Allow wrapping for longer subtitles
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      ),
    );
  }
}
