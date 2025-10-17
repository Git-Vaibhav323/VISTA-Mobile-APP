import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DocumentUploadWidget extends StatefulWidget {
  final String selectedRole;
  final Function(Map<String, bool>) onDocumentsChanged;

  const DocumentUploadWidget({
    Key? key,
    required this.selectedRole,
    required this.onDocumentsChanged,
  }) : super(key: key);

  @override
  State<DocumentUploadWidget> createState() => _DocumentUploadWidgetState();
}

class _DocumentUploadWidgetState extends State<DocumentUploadWidget> {
  Map<String, bool> uploadedDocuments = {
    'gst': false,
    'business_license': false,
    'identity': false,
    'bank_details': false,
  };

  List<Map<String, dynamic>> get requiredDocuments {
    if (widget.selectedRole == 'vendor') {
      return [
        {
          'key': 'business_license',
          'title': 'Business License',
          'titleHindi': 'व्यापार लाइसेंस',
          'description':
              'Municipal trade license or shop establishment certificate',
          'icon': 'description',
          'mandatory': true,
        },
        {
          'key': 'gst',
          'title': 'GST Certificate',
          'titleHindi': 'जीएसटी प्रमाणपत्र',
          'description': 'GST registration certificate (if applicable)',
          'icon': 'receipt',
          'mandatory': false,
        },
        {
          'key': 'identity',
          'title': 'Identity Proof',
          'titleHindi': 'पहचान प्रमाण',
          'description': 'Aadhaar Card, PAN Card, or Driving License',
          'icon': 'badge',
          'mandatory': true,
        },
      ];
    } else {
      return [
        {
          'key': 'gst',
          'title': 'GST Certificate',
          'titleHindi': 'जीएसटी प्रमाणपत्र',
          'description': 'Valid GST registration certificate',
          'icon': 'receipt',
          'mandatory': true,
        },
        {
          'key': 'business_license',
          'title': 'Business License',
          'titleHindi': 'व्यापार लाइसेंस',
          'description': 'Trade license or company incorporation certificate',
          'icon': 'description',
          'mandatory': true,
        },
        {
          'key': 'bank_details',
          'title': 'Bank Details',
          'titleHindi': 'बैंक विवरण',
          'description': 'Bank account statement or cancelled cheque',
          'icon': 'account_balance',
          'mandatory': true,
        },
        {
          'key': 'identity',
          'title': 'Identity Proof',
          'titleHindi': 'पहचान प्रमाण',
          'description': 'Aadhaar Card, PAN Card, or Driving License',
          'icon': 'badge',
          'mandatory': true,
        },
      ];
    }
  }

  void _uploadDocument(String documentKey) async {
    HapticFeedback.lightImpact();

    // Simulate document upload process
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                AppTheme.lightTheme.colorScheme.primary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Uploading document...',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop();

      setState(() {
        uploadedDocuments[documentKey] = true;
      });

      widget.onDocumentsChanged(uploadedDocuments);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Document uploaded successfully!'),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showCameraOptions(String documentKey) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'Upload Document',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOptionButton(
                  icon: 'camera_alt',
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _uploadDocument(documentKey);
                  },
                ),
                _buildOptionButton(
                  icon: 'photo_library',
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _uploadDocument(documentKey);
                  },
                ),
                _buildOptionButton(
                  icon: 'folder',
                  label: 'Files',
                  onTap: () {
                    Navigator.pop(context);
                    _uploadDocument(documentKey);
                  },
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.lightTheme.colorScheme.outline,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 8.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.lightTheme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Secure Document Upload',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.tertiary,
                        ),
                      ),
                      Text(
                        'Your documents are encrypted and stored securely',
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
          ),
          SizedBox(height: 3.h),
          ...requiredDocuments.map((doc) => _buildDocumentCard(doc)).toList(),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(Map<String, dynamic> doc) {
    final isUploaded = uploadedDocuments[doc['key']] ?? false;
    final isMandatory = doc['mandatory'] ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUploaded
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline,
          width: isUploaded ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
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
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: isUploaded
                      ? AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1)
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: doc['icon'],
                  color: isUploaded
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
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
                        Text(
                          doc['title'],
                          style: AppTheme.lightTheme.textTheme.titleSmall
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isUploaded
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        if (isMandatory) ...[
                          SizedBox(width: 1.w),
                          Text(
                            '*',
                            style: TextStyle(
                              color: AppTheme.lightTheme.colorScheme.error,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      doc['titleHindi'],
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isUploaded)
                Container(
                  padding: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 4.w,
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            doc['description'],
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: double.infinity,
            height: 5.h,
            child: OutlinedButton.icon(
              onPressed:
                  isUploaded ? null : () => _showCameraOptions(doc['key']),
              icon: CustomIconWidget(
                iconName: isUploaded ? 'check_circle' : 'upload',
                color: isUploaded
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 4.w,
              ),
              label: Text(
                isUploaded ? 'Uploaded' : 'Upload Document',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: isUploaded
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                side: BorderSide(
                  color: isUploaded
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
