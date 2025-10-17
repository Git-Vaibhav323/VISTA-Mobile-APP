import 'package:flutter/material.dart';

import '../core/app_export.dart';

// custom_error_widget.dart

class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails? errorDetails;
  final String? errorMessage;

  const CustomErrorWidget({
    Key? key,
    this.errorDetails,
    this.errorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Something went wrong",
                style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We encountered an unexpected error while processing your request.',
                textAlign: TextAlign.center,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  bool canBeBack = Navigator.canPop(context);
                  if (canBeBack) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.pushNamed(context, AppRoutes.initial);
                  }
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 18,
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                ),
                label: Text(
                  'Back',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
