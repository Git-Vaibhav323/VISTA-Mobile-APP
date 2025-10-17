import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentManagementWidget extends StatelessWidget {
  final List<Map<String, dynamic>> documents;
  final VoidCallback onAddDocument;

  const DocumentManagementWidget({
    Key? key,
    required this.documents,
    required this.onAddDocument,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return AppTheme.successLight;
      case 'pending':
        return AppTheme.warningLight;
      case 'rejected':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return 'check_circle';
      case 'pending':
        return 'schedule';
      case 'rejected':
        return 'cancel';
      default:
        return 'help';
    }
  }

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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Document Management',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: onAddDocument,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'add',
                          color: AppTheme.lightTheme.colorScheme.surface,
                          size: 16,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Add',
                          style: AppTheme.lightTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (documents.isEmpty)
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: 'description',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 12.w,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'No documents uploaded yet',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Upload your business documents for verification',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            ...documents.asMap().entries.map((entry) {
              final index = entry.key;
              final document = entry.value;
              final isLast = index == documents.length - 1;

              return Column(
                children: [
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    leading: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: 'description',
                        color: AppTheme.lightTheme.colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    title: Text(
                      document['name'] as String,
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 0.5.h),
                        Text(
                          document['type'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName:
                                  _getStatusIcon(document['status'] as String),
                              color:
                                  _getStatusColor(document['status'] as String),
                              size: 16,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              document['status'] as String,
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: _getStatusColor(
                                    document['status'] as String),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (document['onMenuSelected'] != null) {
                          (document['onMenuSelected'] as Function(
                              String))(value);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Text('View'),
                        ),
                        const PopupMenuItem(
                          value: 'download',
                          child: Text('Download'),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text('Delete'),
                        ),
                      ],
                      child: CustomIconWidget(
                        iconName: 'more_vert',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
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
