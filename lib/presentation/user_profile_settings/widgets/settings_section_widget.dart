import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SettingsSectionWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> settingsItems;

  const SettingsSectionWidget({
    Key? key,
    required this.title,
    required this.settingsItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 1.h),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(4.w, 3.h, 4.w, 1.h),
            child: Text(
              title,
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ...settingsItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isLast = index == settingsItems.length - 1;

            return Column(
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 0.5.h),
                  leading: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: (item['iconColor'] as Color? ??
                              AppTheme.lightTheme.colorScheme.primary)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: item['icon'] as String,
                      color: item['iconColor'] as Color? ??
                          AppTheme.lightTheme.colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    item['title'] as String,
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: item['subtitle'] != null
                      ? Text(
                          item['subtitle'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  trailing: item['hasSwitch'] == true
                      ? Switch(
                          value: item['switchValue'] as bool? ?? false,
                          onChanged: item['onSwitchChanged'] as Function(bool)?,
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item['trailingText'] != null) ...[
                              Text(
                                item['trailingText'] as String,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(width: 2.w),
                            ],
                            CustomIconWidget(
                              iconName: 'chevron_right',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 20,
                            ),
                          ],
                        ),
                  onTap: item['onTap'] as VoidCallback?,
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 1,
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    indent: 4.w,
                    endIndent: 4.w,
                  ),
              ],
            );
          }).toList(),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }
}
