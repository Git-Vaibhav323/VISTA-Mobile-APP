import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class BusinessInfoFormWidget extends StatefulWidget {
  final Function(Map<String, String>) onFormChanged;
  final String selectedRole;

  const BusinessInfoFormWidget({
    Key? key,
    required this.onFormChanged,
    required this.selectedRole,
  }) : super(key: key);

  @override
  State<BusinessInfoFormWidget> createState() => _BusinessInfoFormWidgetState();
}

class _BusinessInfoFormWidgetState extends State<BusinessInfoFormWidget> {
  final _businessNameController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _businessNameController.addListener(_onFormChanged);
    _ownerNameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    widget.onFormChanged({
      'businessName': _businessNameController.text,
      'ownerName': _ownerNameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
    });
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFormField(
              controller: _businessNameController,
              label: widget.selectedRole == 'vendor'
                  ? 'Business Name'
                  : 'Company Name',
              hint: widget.selectedRole == 'vendor'
                  ? 'e.g., Sharma\'s Street Food'
                  : 'e.g., Fresh Foods Suppliers',
              icon: 'business',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your business name';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            _buildFormField(
              controller: _ownerNameController,
              label: 'Owner Name',
              hint: 'e.g., Rajesh Sharma',
              icon: 'person',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter owner name';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            _buildFormField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'e.g., rajesh@example.com',
              icon: 'email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email address';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: 2.h),
            _buildFormField(
              controller: _phoneController,
              label: 'Phone Number (Optional)',
              hint: '+91 98765 43210',
              icon: 'phone',
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length != 10) {
                  return 'Please enter valid 10-digit phone number';
                }
                return null;
              },
            ),
            SizedBox(height: 3.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'We will send a verification email to confirm your account.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required String icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: Icon(
                _getIconData(icon),
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: AppTheme.lightTheme.colorScheme.error,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'business':
        return Icons.business;
      case 'person':
        return Icons.person;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      default:
        return Icons.info;
    }
  }
}
