import 'package:flutter/material.dart';
import '../presentation/vendor_dashboard/vendor_dashboard.dart';
import '../presentation/order_management/order_management.dart';
import '../presentation/role_selection_onboarding/role_selection_onboarding.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/supplier_dashboard/supplier_dashboard.dart';
import '../presentation/product_catalog_management/product_catalog_management.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String vendorDashboard = '/vendor-dashboard';
  static const String orderManagement = '/order-management';
  static const String roleSelectionOnboarding = '/role-selection-onboarding';
  static const String userProfileSettings = '/user-profile-settings';
  static const String supplierDashboard = '/supplier-dashboard';
  static const String productCatalogManagement = '/product-catalog-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const RoleSelectionOnboarding(),
    vendorDashboard: (context) => const VendorDashboard(),
    orderManagement: (context) => const OrderManagement(),
    roleSelectionOnboarding: (context) => const RoleSelectionOnboarding(),
    userProfileSettings: (context) => const UserProfileSettings(),
    supplierDashboard: (context) => const SupplierDashboard(),
    productCatalogManagement: (context) => const ProductCatalogManagement(),
    // TODO: Add your other routes here
  };
}
