import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/business_analytics_widget.dart';
import './widgets/business_info_card_widget.dart';
import './widgets/document_management_widget.dart';
import './widgets/payment_methods_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({Key? key}) : super(key: key);

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  int _currentIndex = 4; // Profile tab active
  bool _notificationsEnabled = true;
  bool _biometricEnabled = false;
  String _selectedLanguage = 'English';
  bool _isRefreshing = false;

  // Mock user data
  final Map<String, dynamic> userData = {
    "id": 1,
    "name": "Rajesh Kumar",
    "role": "Vendor",
    "phone": "+91 98765 43210",
    "email": "rajesh.kumar@gmail.com",
    "avatar":
        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
    "isVerified": true,
    "businessName": "Kumar Street Foods",
    "gstNumber": "27AABCU9603R1ZX",
    "businessAddress": "Shop No. 15, MG Road, Mumbai, Maharashtra 400001",
    "operatingHours": "6:00 AM - 11:00 PM",
    "businessType": "Street Food Vendor",
    "establishedYear": "2018",
  };

  // Mock documents data
  final List<Map<String, dynamic>> documentsData = [
    {
      "id": 1,
      "name": "GST Certificate",
      "type": "Business License",
      "status": "Verified",
      "uploadDate": "2024-08-15",
      "onMenuSelected": null,
    },
    {
      "id": 2,
      "name": "Food License",
      "type": "FSSAI License",
      "status": "Pending",
      "uploadDate": "2024-08-20",
      "onMenuSelected": null,
    },
    {
      "id": 3,
      "name": "Shop License",
      "type": "Municipal License",
      "status": "Rejected",
      "uploadDate": "2024-08-10",
      "onMenuSelected": null,
    },
  ];

  // Mock payment methods data
  final List<Map<String, dynamic>> paymentMethodsData = [
    {
      "id": 1,
      "name": "PhonePe",
      "type": "UPI",
      "details": "rajesh@paytm",
      "isDefault": true,
      "onMenuSelected": null,
    },
    {
      "id": 2,
      "name": "HDFC Bank",
      "type": "Bank",
      "details": "****1234",
      "isDefault": false,
      "onMenuSelected": null,
    },
    {
      "id": 3,
      "name": "Paytm Wallet",
      "type": "Wallet",
      "details": "Balance: ₹2,450",
      "isDefault": false,
      "onMenuSelected": null,
    },
  ];

  // Mock analytics data
  final Map<String, dynamic> analyticsData = {
    "totalOrders": 1247,
    "revenue": 89500,
    "rating": 4.6,
    "growth": 23,
  };

  @override
  void initState() {
    super.initState();
    _initializeDocumentMenuCallbacks();
    _initializePaymentMenuCallbacks();
  }

  void _initializeDocumentMenuCallbacks() {
    for (int i = 0; i < documentsData.length; i++) {
      documentsData[i]['onMenuSelected'] = (String action) {
        _handleDocumentMenuAction(action, documentsData[i]);
      };
    }
  }

  void _initializePaymentMenuCallbacks() {
    for (int i = 0; i < paymentMethodsData.length; i++) {
      paymentMethodsData[i]['onMenuSelected'] = (String action) {
        _handlePaymentMenuAction(action, paymentMethodsData[i]);
      };
    }
  }

  void _handleDocumentMenuAction(String action, Map<String, dynamic> document) {
    switch (action) {
      case 'view':
        _showToast('Viewing ${document['name']}');
        break;
      case 'download':
        _showToast('Downloading ${document['name']}');
        break;
      case 'delete':
        _showDeleteDocumentDialog(document);
        break;
    }
  }

  void _handlePaymentMenuAction(String action, Map<String, dynamic> method) {
    switch (action) {
      case 'set_default':
        setState(() {
          for (var payment in paymentMethodsData) {
            payment['isDefault'] = payment['id'] == method['id'];
          }
        });
        _showToast('${method['name']} set as default');
        break;
      case 'edit':
        _showToast('Editing ${method['name']}');
        break;
      case 'remove':
        _showDeletePaymentDialog(method);
        break;
    }
  }

  void _showDeleteDocumentDialog(Map<String, dynamic> document) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Document'),
        content: Text('Are you sure you want to delete ${document['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                documentsData.removeWhere((doc) => doc['id'] == document['id']);
              });
              Navigator.pop(context);
              _showToast('Document deleted successfully');
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeletePaymentDialog(Map<String, dynamic> method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Payment Method'),
        content: Text('Are you sure you want to remove ${method['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                paymentMethodsData
                    .removeWhere((payment) => payment['id'] == method['id']);
              });
              Navigator.pop(context);
              _showToast('Payment method removed successfully');
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    _showToast('Profile updated successfully');
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.lightTheme.colorScheme.primary,
      textColor: AppTheme.lightTheme.colorScheme.surface,
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content:
            const Text('Are you sure you want to logout from your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/role-selection-onboarding',
                (route) => false,
              );
            },
            child: Text(
              'Logout',
              style: TextStyle(color: AppTheme.errorLight),
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'English',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                _showToast('Language changed to English');
              },
            ),
            RadioListTile<String>(
              title: const Text('हिंदी (Hindi)'),
              value: 'Hindi',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                Navigator.pop(context);
                _showToast('भाषा हिंदी में बदल दी गई');
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> _getBusinessInfo() {
    return [
      {'label': 'Phone:', 'value': userData['phone'] as String},
      {'label': 'Email:', 'value': userData['email'] as String},
      {'label': 'GST No:', 'value': userData['gstNumber'] as String},
      {'label': 'Address:', 'value': userData['businessAddress'] as String},
      {'label': 'Hours:', 'value': userData['operatingHours'] as String},
    ];
  }

  List<Map<String, dynamic>> _getAccountSettings() {
    return [
      {
        'icon': 'lock',
        'title': 'Change Password',
        'subtitle': 'Update your account password',
        'iconColor': AppTheme.lightTheme.colorScheme.primary,
        'onTap': () => _showToast('Opening password change screen'),
      },
      {
        'icon': 'phone',
        'title': 'Phone Number',
        'subtitle': userData['phone'],
        'iconColor': AppTheme.lightTheme.colorScheme.primary,
        'onTap': () => _showToast('Opening phone update screen'),
      },
      {
        'icon': 'email',
        'title': 'Email Address',
        'subtitle': userData['email'],
        'iconColor': AppTheme.lightTheme.colorScheme.primary,
        'onTap': () => _showToast('Opening email update screen'),
      },
    ];
  }

  List<Map<String, dynamic>> _getBusinessSettings() {
    return [
      {
        'icon': 'business',
        'title': 'Business Profile',
        'subtitle': 'Update business information',
        'iconColor': AppTheme.lightTheme.colorScheme.secondary,
        'onTap': () => _showToast('Opening business profile screen'),
      },
      {
        'icon': 'location_on',
        'title': 'Location Settings',
        'subtitle': 'Manage delivery areas',
        'iconColor': AppTheme.lightTheme.colorScheme.secondary,
        'onTap': () => _showToast('Opening location settings'),
      },
      {
        'icon': 'category',
        'title': 'Categories',
        'subtitle': 'Manage product categories',
        'iconColor': AppTheme.lightTheme.colorScheme.secondary,
        'onTap': () => _showToast('Opening categories management'),
      },
    ];
  }

  List<Map<String, dynamic>> _getAppPreferences() {
    return [
      {
        'icon': 'language',
        'title': 'Language',
        'trailingText': _selectedLanguage,
        'iconColor': AppTheme.lightTheme.colorScheme.tertiary,
        'onTap': _showLanguageDialog,
      },
      {
        'icon': 'notifications',
        'title': 'Notifications',
        'subtitle': 'Manage notification preferences',
        'hasSwitch': true,
        'switchValue': _notificationsEnabled,
        'iconColor': AppTheme.lightTheme.colorScheme.tertiary,
        'onSwitchChanged': (value) {
          setState(() {
            _notificationsEnabled = value;
          });
          _showToast(
              value ? 'Notifications enabled' : 'Notifications disabled');
        },
      },
      {
        'icon': 'fingerprint',
        'title': 'Biometric Authentication',
        'subtitle': 'Use fingerprint or face ID',
        'hasSwitch': true,
        'switchValue': _biometricEnabled,
        'iconColor': AppTheme.lightTheme.colorScheme.tertiary,
        'onSwitchChanged': (value) {
          setState(() {
            _biometricEnabled = value;
          });
          _showToast(value
              ? 'Biometric authentication enabled'
              : 'Biometric authentication disabled');
        },
      },
    ];
  }

  List<Map<String, dynamic>> _getSupportSettings() {
    return [
      {
        'icon': 'help',
        'title': 'Help & Support',
        'subtitle': 'Get help and contact support',
        'iconColor': AppTheme.warningLight,
        'onTap': () => _showToast('Opening help center'),
      },
      {
        'icon': 'feedback',
        'title': 'Send Feedback',
        'subtitle': 'Share your experience with us',
        'iconColor': AppTheme.warningLight,
        'onTap': () => _showToast('Opening feedback form'),
      },
      {
        'icon': 'info',
        'title': 'About VISTA',
        'subtitle': 'App version and information',
        'iconColor': AppTheme.warningLight,
        'onTap': () => _showToast('Opening about screen'),
      },
    ];
  }

  List<Map<String, dynamic>> _getSecuritySettings() {
    return [
      {
        'icon': 'security',
        'title': 'Security Settings',
        'subtitle': 'Manage account security',
        'iconColor': AppTheme.errorLight,
        'onTap': () => _showToast('Opening security settings'),
      },
      {
        'icon': 'history',
        'title': 'Session Management',
        'subtitle': 'View active sessions',
        'iconColor': AppTheme.errorLight,
        'onTap': () => _showToast('Opening session management'),
      },
      {
        'icon': 'delete_forever',
        'title': 'Delete Account',
        'subtitle': 'Permanently delete your account',
        'iconColor': AppTheme.errorLight,
        'onTap': () => _showToast('Opening account deletion'),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightTheme.colorScheme.onSurface,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),

                // Profile Header
                ProfileHeaderWidget(
                  userName: userData['name'] as String,
                  userRole: userData['role'] as String,
                  avatarUrl: userData['avatar'] as String,
                  isVerified: userData['isVerified'] as bool,
                  onEditPressed: () =>
                      _showToast('Opening profile edit screen'),
                  onAvatarPressed: () =>
                      _showToast('Opening camera for profile picture'),
                ),

                SizedBox(height: 2.h),

                // Business Information
                BusinessInfoCardWidget(
                  title: 'Business Information',
                  businessInfo: _getBusinessInfo(),
                  onEditPressed: () =>
                      _showToast('Opening business info edit screen'),
                ),

                SizedBox(height: 2.h),

                // Business Analytics
                BusinessAnalyticsWidget(
                  analyticsData: analyticsData,
                ),

                SizedBox(height: 2.h),

                // Document Management
                DocumentManagementWidget(
                  documents: documentsData,
                  onAddDocument: () => _showToast('Opening document upload'),
                ),

                SizedBox(height: 2.h),

                // Payment Methods
                PaymentMethodsWidget(
                  paymentMethods: paymentMethodsData,
                  onAddPaymentMethod: () =>
                      _showToast('Opening payment method setup'),
                ),

                SizedBox(height: 2.h),

                // Account Settings
                SettingsSectionWidget(
                  title: 'Account Settings',
                  settingsItems: _getAccountSettings(),
                ),

                SizedBox(height: 1.h),

                // Business Settings
                SettingsSectionWidget(
                  title: 'Business Settings',
                  settingsItems: _getBusinessSettings(),
                ),

                SizedBox(height: 1.h),

                // App Preferences
                SettingsSectionWidget(
                  title: 'App Preferences',
                  settingsItems: _getAppPreferences(),
                ),

                SizedBox(height: 1.h),

                // Support
                SettingsSectionWidget(
                  title: 'Support',
                  settingsItems: _getSupportSettings(),
                ),

                SizedBox(height: 1.h),

                // Security
                SettingsSectionWidget(
                  title: 'Security',
                  settingsItems: _getSecuritySettings(),
                ),

                SizedBox(height: 2.h),

                // Logout Button
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  child: ElevatedButton(
                    onPressed: _showLogoutDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorLight,
                      foregroundColor: AppTheme.lightTheme.colorScheme.surface,
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'logout',
                          color: AppTheme.lightTheme.colorScheme.surface,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Logout',
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 4.h),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                  context,
                  userData['role'] == 'Vendor'
                      ? '/vendor-dashboard'
                      : '/supplier-dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/order-management');
              break;
            case 2:
              Navigator.pushNamed(context, '/product-catalog-management');
              break;
            case 3:
              _showToast('Opening messages');
              break;
            case 4:
              // Already on profile screen
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              color: _currentIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'shopping_cart',
              color: _currentIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: userData['role'] == 'Vendor' ? 'inventory' : 'store',
              color: _currentIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: userData['role'] == 'Vendor' ? 'Inventory' : 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'message',
              color: _currentIndex == 3
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentIndex == 4
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
