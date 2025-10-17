import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/business_info_form_widget.dart';
import './widgets/document_upload_widget.dart';
import './widgets/location_selection_widget.dart';
import './widgets/onboarding_step_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/role_card_widget.dart';

class RoleSelectionOnboarding extends StatefulWidget {
  const RoleSelectionOnboarding({Key? key}) : super(key: key);

  @override
  State<RoleSelectionOnboarding> createState() =>
      _RoleSelectionOnboardingState();
}

class _RoleSelectionOnboardingState extends State<RoleSelectionOnboarding>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int currentStep = 0;
  String? selectedRole;
  Map<String, String> businessInfo = {};
  Map<String, String> locationInfo = {};
  Map<String, bool> documentsInfo = {};

  final List<String> stepLabels = [
    'Role',
    'Business',
    'Location',
    'Documents',
  ];

  final List<Map<String, dynamic>> roleData = [
    {
      'key': 'vendor',
      'title': 'Street Food Vendor',
      'description':
          'I sell street food and need suppliers for ingredients and materials',
      'benefits': [
        'Find reliable suppliers nearby',
        'Manage inventory efficiently',
        'Track orders and deliveries',
        'Get competitive prices',
      ],
      'icon': 'restaurant',
    },
    {
      'key': 'supplier',
      'title': 'Food Supplier',
      'description':
          'I supply ingredients and materials to street food vendors',
      'benefits': [
        'Connect with local vendors',
        'Manage product catalog',
        'Track sales and analytics',
        'Expand business reach',
      ],
      'icon': 'local_shipping',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < stepLabels.length - 1) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipStep() {
    if (currentStep == 2 || currentStep == 3) {
      // Location or Documents
      _nextStep();
    }
  }

  void _completeOnboarding() {
    HapticFeedback.lightImpact();

    // Navigate to appropriate dashboard based on role
    if (selectedRole == 'vendor') {
      Navigator.pushReplacementNamed(context, '/vendor-dashboard');
    } else if (selectedRole == 'supplier') {
      Navigator.pushReplacementNamed(context, '/supplier-dashboard');
    }
  }

  bool _isStepValid() {
    switch (currentStep) {
      case 0: // Role selection
        return selectedRole != null;
      case 1: // Business info
        return businessInfo['businessName']?.isNotEmpty == true &&
            businessInfo['ownerName']?.isNotEmpty == true &&
            businessInfo['email']?.isNotEmpty == true &&
            _isValidEmail(businessInfo['email'] ?? '');
      case 2: // Location
        return locationInfo['city']?.isNotEmpty == true;
      case 3: // Documents
        if (selectedRole == 'vendor') {
          return documentsInfo['business_license'] == true &&
              documentsInfo['identity'] == true;
        } else {
          return documentsInfo['gst'] == true &&
              documentsInfo['business_license'] == true &&
              documentsInfo['bank_details'] == true &&
              documentsInfo['identity'] == true;
        }
      default:
        return false;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: currentStep > 0
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              )
            : null,
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            'VISTA',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary,
              letterSpacing: 1.2,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          if (currentStep > 0)
            TextButton(
              onPressed: () => _completeOnboarding(),
              child: Text(
                'Skip',
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (currentStep > 0)
              ProgressIndicatorWidget(
                currentStep: currentStep,
                totalSteps: stepLabels.length,
                stepLabels: stepLabels,
              ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildRoleSelectionStep(),
                  _buildBusinessInfoStep(),
                  _buildLocationStep(),
                  _buildDocumentStep(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSelectionStep() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Text(
                    'Welcome to VISTA',
                    style:
                        AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Choose your role to get started with India\'s premier street food marketplace',
                    style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  ...roleData
                      .map((role) => RoleCardWidget(
                            title: role['title'],
                            description: role['description'],
                            benefits: (role['benefits'] as List).cast<String>(),
                            iconName: role['icon'],
                            isSelected: selectedRole == role['key'],
                            onTap: () {
                              setState(() {
                                selectedRole = role['key'];
                              });
                            },
                          ))
                      .toList(),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              height: 6.h,
              child: ElevatedButton(
                onPressed: _isStepValid() ? _nextStep : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isStepValid()
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline.withOpacity(0.3),
                  foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
                  elevation: _isStepValid() ? 2 : 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessInfoStep() {
    return OnboardingStepWidget(
      title: 'Business Information',
      subtitle:
          'Tell us about your ${selectedRole == 'vendor' ? 'food business' : 'supply business'}',
      content: BusinessInfoFormWidget(
        selectedRole: selectedRole ?? 'vendor',
        onFormChanged: (info) {
          setState(() {
            businessInfo = info;
          });
        },
      ),
      onNext: _nextStep,
      onSkip: _skipStep,
      isNextEnabled: _isStepValid(),
      showSkip: false,
    );
  }

  Widget _buildLocationStep() {
    return OnboardingStepWidget(
      title: 'Location Setup',
      subtitle:
          'Help us find the best ${selectedRole == 'vendor' ? 'suppliers' : 'vendors'} near you',
      content: LocationSelectionWidget(
        onLocationChanged: (location) {
          setState(() {
            locationInfo = location;
          });
        },
      ),
      onNext: _nextStep,
      onSkip: _skipStep,
      isNextEnabled: _isStepValid(),
      showSkip: true,
    );
  }

  Widget _buildDocumentStep() {
    return OnboardingStepWidget(
      title: 'Document Verification',
      subtitle: 'Upload required documents to verify your business',
      content: DocumentUploadWidget(
        selectedRole: selectedRole ?? 'vendor',
        onDocumentsChanged: (documents) {
          setState(() {
            documentsInfo = documents;
          });
        },
      ),
      onNext: _completeOnboarding,
      onSkip: _completeOnboarding,
      nextButtonText: 'Complete Setup',
      isNextEnabled: _isStepValid(),
      showSkip: true,
    );
  }
}
