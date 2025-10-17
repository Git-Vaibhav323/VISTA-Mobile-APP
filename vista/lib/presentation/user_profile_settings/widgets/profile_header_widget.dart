import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String userName;
  final String userRole;
  final String avatarUrl;
  final bool isVerified;
  final VoidCallback onEditPressed;
  final VoidCallback onAvatarPressed;

  const ProfileHeaderWidget({
    Key? key,
    required this.userName,
    required this.userRole,
    required this.avatarUrl,
    required this.isVerified,
    required this.onEditPressed,
    required this.onAvatarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profile',
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
              GestureDetector(
                onTap: onEditPressed,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: 'edit',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              GestureDetector(
                onTap: onAvatarPressed,
                child: Stack(
                  children: [
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: avatarUrl.isNotEmpty
                            ? CustomImageWidget(
                                imageUrl: avatarUrl,
                                width: 20.w,
                                height: 20.w,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: AppTheme.lightTheme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                child: CustomIconWidget(
                                  iconName: 'person',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 8.w,
                                ),
                              ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            width: 2,
                          ),
                        ),
                        child: CustomIconWidget(
                          iconName: 'camera_alt',
                          color: AppTheme.lightTheme.colorScheme.surface,
                          size: 3.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            userName,
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.successLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'verified',
                                  color: AppTheme.successLight,
                                  size: 3.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'Verified',
                                  style: AppTheme
                                      .lightTheme.textTheme.labelSmall
                                      ?.copyWith(
                                    color: AppTheme.successLight,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: userRole == 'Vendor'
                            ? AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.1)
                            : AppTheme.lightTheme.colorScheme.secondary
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        userRole,
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: userRole == 'Vendor'
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
