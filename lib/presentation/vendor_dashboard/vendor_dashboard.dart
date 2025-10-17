import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dashboard_metrics_widget.dart';
import './widgets/low_stock_alerts_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_orders_widget.dart';

class VendorDashboard extends StatefulWidget {
  const VendorDashboard({Key? key}) : super(key: key);

  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isRefreshing = false;
  bool _isHindi = false;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _recentOrders = [
    {
      "id": 1,
      "supplierName": "Sharma Spices & Masala",
      "orderNumber": "ORD001234",
      "itemsCount": 8,
      "totalAmount": "2,450",
      "status": "delivered",
      "deliveryTime": "Today, 2:30 PM",
    },
    {
      "id": 2,
      "supplierName": "Fresh Vegetables Hub",
      "orderNumber": "ORD001235",
      "itemsCount": 12,
      "totalAmount": "1,850",
      "status": "processing",
      "deliveryTime": "Tomorrow, 10:00 AM",
    },
    {
      "id": 3,
      "supplierName": "Mumbai Oil & Ghee Co.",
      "orderNumber": "ORD001236",
      "itemsCount": 5,
      "totalAmount": "3,200",
      "status": "pending",
      "deliveryTime": "Aug 30, 11:00 AM",
    },
  ];

  final List<Map<String, dynamic>> _lowStockItems = [
    {
      "id": 1,
      "itemName": "Onions",
      "currentStock": 2,
      "suggestedQuantity": 25,
      "unit": "kg",
    },
    {
      "id": 2,
      "itemName": "Tomatoes",
      "currentStock": 1,
      "suggestedQuantity": 20,
      "unit": "kg",
    },
    {
      "id": 3,
      "itemName": "Cooking Oil",
      "currentStock": 0,
      "suggestedQuantity": 10,
      "unit": "liters",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.primaryColor,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardMetricsWidget(
                      todayOrders: 5,
                      lowStockAlerts: _lowStockItems.length,
                      pendingDeliveries: 2,
                      onTodayOrdersTap: () => _navigateToOrders(),
                      onLowStockTap: () => _navigateToInventory(),
                      onPendingDeliveriesTap: () => _navigateToOrders(),
                    ),
                    QuickActionsWidget(
                      onPlaceOrderTap: () => _navigateToOrderManagement(),
                      onCheckInventoryTap: () => _navigateToInventory(),
                      onViewSuppliersTap: () => _navigateToSuppliers(),
                    ),
                    LowStockAlertsWidget(
                      lowStockItems: _lowStockItems,
                      onReorderItem: _handleReorderItem,
                      onViewInventory: () => _navigateToInventory(),
                    ),
                    RecentOrdersWidget(
                      orders: _recentOrders,
                      onTrackOrder: _handleTrackOrder,
                      onReorder: _handleReorder,
                      onContactSupplier: _handleContactSupplier,
                      onViewAllOrders: () => _navigateToOrders(),
                    ),
                    SizedBox(height: 10.h), // Bottom padding for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      snap: true,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 2,
      shadowColor: AppTheme.shadowLight,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isHindi ? 'नमस्ते, राजेश जी' : 'Hello, Rajesh',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          Text(
            _isHindi ? 'मुंबई, अंधेरी पूर्व' : 'Mumbai, Andheri East',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textSecondaryLight,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: _toggleLanguage,
          icon: CustomIconWidget(
            iconName: 'language',
            color: AppTheme.textSecondaryLight,
            size: 6.w,
          ),
          tooltip: _isHindi ? 'English' : 'हिंदी',
        ),
        Stack(
          children: [
            IconButton(
              onPressed: _handleNotificationTap,
              icon: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.textSecondaryLight,
                size: 6.w,
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.errorLight,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        SizedBox(width: 2.w),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.primaryColor,
      unselectedItemColor: AppTheme.textSecondaryLight,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _selectedIndex == 0
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 6.w,
          ),
          label: _isHindi ? 'होम' : 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'shopping_bag',
            color: _selectedIndex == 1
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 6.w,
          ),
          label: _isHindi ? 'ऑर्डर' : 'Orders',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'inventory',
            color: _selectedIndex == 2
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 6.w,
          ),
          label: _isHindi ? 'स्टॉक' : 'Inventory',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'message',
            color: _selectedIndex == 3
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 6.w,
          ),
          label: _isHindi ? 'संदेश' : 'Messages',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _selectedIndex == 4
                ? AppTheme.lightTheme.primaryColor
                : AppTheme.textSecondaryLight,
            size: 6.w,
          ),
          label: _isHindi ? 'प्रोफाइल' : 'Profile',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _handleQuickOrder,
      backgroundColor: AppTheme.lightTheme.primaryColor,
      foregroundColor: Colors.white,
      icon: CustomIconWidget(
        iconName: 'add_shopping_cart',
        color: Colors.white,
        size: 5.w,
      ),
      label: Text(
        _isHindi ? 'त्वरित ऑर्डर' : 'Quick Order',
        style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isHindi ? 'डेटा अपडेट हो गया' : 'Dashboard updated'),
        backgroundColor: AppTheme.successLight,
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        _navigateToOrders();
        break;
      case 2:
        _navigateToInventory();
        break;
      case 3:
        _navigateToMessages();
        break;
      case 4:
        _navigateToProfile();
        break;
    }
  }

  void _toggleLanguage() {
    setState(() {
      _isHindi = !_isHindi;
    });
  }

  void _handleNotificationTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isHindi ? 'नोटिफिकेशन' : 'Notifications',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'local_shipping',
                color: AppTheme.lightTheme.primaryColor,
                size: 6.w,
              ),
              title: Text(_isHindi
                  ? 'आपका ऑर्डर डिलीवर हो गया'
                  : 'Your order has been delivered'),
              subtitle: Text('2 minutes ago'),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'warning',
                color: AppTheme.errorLight,
                size: 6.w,
              ),
              title: Text(_isHindi
                  ? 'प्याज का स्टॉक कम है'
                  : 'Low stock alert: Onions'),
              subtitle: Text('1 hour ago'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleQuickOrder() {
    _navigateToOrderManagement();
  }

  void _handleTrackOrder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isHindi
              ? 'ऑर्डर #${order['orderNumber']} को ट्रैक कर रहे हैं'
              : 'Tracking order #${order['orderNumber']}',
        ),
      ),
    );
  }

  void _handleReorder(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isHindi
              ? 'फिर से ऑर्डर कर रहे हैं'
              : 'Reordering from ${order['supplierName']}',
        ),
      ),
    );
  }

  void _handleContactSupplier(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isHindi
              ? '${order['supplierName']} से संपर्क कर रहे हैं'
              : 'Contacting ${order['supplierName']}',
        ),
      ),
    );
  }

  void _handleReorderItem(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isHindi
              ? '${item['itemName']} को फिर से ऑर्डर कर रहे हैं'
              : 'Reordering ${item['itemName']}',
        ),
      ),
    );
  }

  void _navigateToOrders() {
    Navigator.pushNamed(context, '/order-management');
  }

  void _navigateToInventory() {
    // Navigate to inventory screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isHindi ? 'इन्वेंटरी पेज खुल रहा है' : 'Opening inventory'),
      ),
    );
  }

  void _navigateToMessages() {
    // Navigate to messages screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isHindi ? 'मैसेज पेज खुल रहा है' : 'Opening messages'),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/user-profile-settings');
  }

  void _navigateToOrderManagement() {
    Navigator.pushNamed(context, '/order-management');
  }

  void _navigateToSuppliers() {
    // Navigate to suppliers screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text(_isHindi ? 'सप्लायर पेज खुल रहा है' : 'Opening suppliers'),
      ),
    );
  }
}
