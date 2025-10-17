import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/analytics_card_widget.dart';
import './widgets/order_request_card_widget.dart';
import './widgets/performance_card_widget.dart';
import './widgets/quick_stats_widget.dart';

class SupplierDashboard extends StatefulWidget {
  const SupplierDashboard({Key? key}) : super(key: key);

  @override
  State<SupplierDashboard> createState() => _SupplierDashboardState();
}

class _SupplierDashboardState extends State<SupplierDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  bool _isAnalyticsExpanded = false;
  bool _isRefreshing = false;

  // Mock data for performance cards
  final List<Map<String, dynamic>> performanceData = [
    {
      'title': 'Today\'s Revenue',
      'value': '₹45,230',
      'subtitle': '+12% from yesterday',
      'icon': CustomIconWidget(
        iconName: 'currency_rupee',
        color: AppTheme.successLight,
        size: 20,
      ),
    },
    {
      'title': 'Active Orders',
      'value': '23',
      'subtitle': '8 pending approval',
      'icon': CustomIconWidget(
        iconName: 'shopping_cart',
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 20,
      ),
    },
    {
      'title': 'New Inquiries',
      'value': '7',
      'subtitle': '3 urgent requests',
      'icon': CustomIconWidget(
        iconName: 'notifications',
        color: AppTheme.warningLight,
        size: 20,
      ),
    },
  ];

  // Mock data for order requests
  final List<Map<String, dynamic>> orderRequests = [
    {
      'id': 1,
      'vendorName': 'Rajesh Pav Bhaji Corner',
      'vendorImage':
          'https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400',
      'orderValue': '₹8,450',
      'itemsCount': 12,
      'orderTime': '2 hours ago',
      'priority': 'urgent',
    },
    {
      'id': 2,
      'vendorName': 'Mumbai Street Foods',
      'vendorImage':
          'https://images.pexels.com/photos/1040880/pexels-photo-1040880.jpeg?auto=compress&cs=tinysrgb&w=400',
      'orderValue': '₹12,300',
      'itemsCount': 18,
      'orderTime': '4 hours ago',
      'priority': 'normal',
    },
    {
      'id': 3,
      'vendorName': 'Sharma Ji Ka Dhaba',
      'vendorImage':
          'https://images.pexels.com/photos/1043474/pexels-photo-1043474.jpeg?auto=compress&cs=tinysrgb&w=400',
      'orderValue': '₹6,750',
      'itemsCount': 9,
      'orderTime': '6 hours ago',
      'priority': 'normal',
    },
    {
      'id': 4,
      'vendorName': 'Delhi Chaat Bhandar',
      'vendorImage':
          'https://images.pexels.com/photos/1040881/pexels-photo-1040881.jpeg?auto=compress&cs=tinysrgb&w=400',
      'orderValue': '₹15,200',
      'itemsCount': 25,
      'orderTime': '8 hours ago',
      'priority': 'normal',
    },
  ];

  // Mock data for analytics
  final List<Map<String, dynamic>> weeklyTrends = [
    {'label': 'Mon', 'value': 25},
    {'label': 'Tue', 'value': 32},
    {'label': 'Wed', 'value': 28},
    {'label': 'Thu', 'value': 45},
    {'label': 'Fri', 'value': 38},
    {'label': 'Sat', 'value': 52},
    {'label': 'Sun', 'value': 41},
  ];

  final List<Map<String, dynamic>> popularProducts = [
    {'label': 'Onions', 'value': 85},
    {'label': 'Tomatoes', 'value': 72},
    {'label': 'Potatoes', 'value': 68},
    {'label': 'Spices', 'value': 55},
    {'label': 'Oil', 'value': 48},
  ];

  // Mock data for quick stats
  final List<Map<String, dynamic>> quickStats = [
    {
      'title': 'Popular Products',
      'value': 'Onions, Tomatoes',
      'trend': '15%',
      'trendDirection': 'up',
    },
    {
      'title': 'Top Vendor',
      'value': 'Rajesh Pav Bhaji',
      'trend': '8%',
      'trendDirection': 'up',
    },
    {
      'title': 'Inventory Turnover',
      'value': '2.3x',
      'trend': '5%',
      'trendDirection': 'down',
    },
    {
      'title': 'Avg Order Value',
      'value': '₹9,850',
      'trend': '12%',
      'trendDirection': 'up',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      elevation: 2,
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VISTA Wholesale',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          Text(
            'Supplier Dashboard',
            style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              _isAnalyticsExpanded = !_isAnalyticsExpanded;
            });
          },
          icon: CustomIconWidget(
            iconName: _isAnalyticsExpanded ? 'analytics' : 'bar_chart',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
        ),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                // Handle notifications
              },
              icon: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
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

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: 2.h),
          ),
          // Performance Cards
          SliverToBoxAdapter(
            child: Container(
              height: 15.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                itemCount: performanceData.length,
                separatorBuilder: (context, index) => SizedBox(width: 3.w),
                itemBuilder: (context, index) {
                  final data = performanceData[index];
                  return PerformanceCardWidget(
                    title: data['title'],
                    value: data['value'],
                    subtitle: data['subtitle'],
                    icon: data['icon'],
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 3.h),
          ),
          // Recent Order Requests Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Order Requests',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/order-management');
                    },
                    child: Text(
                      'View All',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Order Requests List
          orderRequests.isEmpty
              ? SliverToBoxAdapter(
                  child: _buildEmptyState(),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final order = orderRequests[index];
                      return OrderRequestCardWidget(
                        orderData: order,
                        onAccept: () => _handleOrderAction('accept', order),
                        onDecline: () => _handleOrderAction('decline', order),
                        onViewDetails: () => _handleOrderAction('view', order),
                        onContactVendor: () =>
                            _handleOrderAction('contact', order),
                      );
                    },
                    childCount: orderRequests.length,
                  ),
                ),
          SliverToBoxAdapter(
            child: SizedBox(height: 3.h),
          ),
          // Quick Stats
          SliverToBoxAdapter(
            child: QuickStatsWidget(statsData: quickStats),
          ),
          // Analytics Section
          if (_isAnalyticsExpanded) ...[
            SliverToBoxAdapter(
              child: SizedBox(height: 2.h),
            ),
            SliverToBoxAdapter(
              child: AnalyticsCardWidget(
                title: 'Weekly Sales Trends',
                chartData: weeklyTrends,
                chartType: 'line',
              ),
            ),
            SliverToBoxAdapter(
              child: AnalyticsCardWidget(
                title: 'Popular Products',
                chartData: popularProducts,
                chartType: 'bar',
              ),
            ),
          ],
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'inbox',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 15.w,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Order Requests',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'New vendor orders will appear here. Set up your catalog to start receiving orders.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/product-catalog-management');
            },
            child: Text(
              'Setup Catalog',
              style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
      unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
      elevation: 8,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _currentIndex == 0
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'shopping_bag',
            color: _currentIndex == 1
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'inventory',
            color: _currentIndex == 2
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Catalog',
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
    );
  }

  Widget? _buildFloatingActionButton() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/product-catalog-management');
        },
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 24,
        ),
        label: Text(
          'Add Products',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onPrimary,
          ),
        ),
      );
    }
    return null;
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Dashboard data refreshed successfully',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _handleOrderAction(String action, Map<String, dynamic> order) {
    final vendorName = order['vendorName'] as String;
    String message = '';

    switch (action) {
      case 'accept':
        message = 'Order from $vendorName accepted successfully';
        break;
      case 'decline':
        message = 'Order from $vendorName declined';
        break;
      case 'view':
        Navigator.pushNamed(context, '/order-management');
        return;
      case 'contact':
        message = 'Opening chat with $vendorName';
        break;
    }

    if (message.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onInverseSurface,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/order-management');
        break;
      case 2:
        Navigator.pushNamed(context, '/product-catalog-management');
        break;
      case 3:
        // Navigate to messages (not implemented in this scope)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Messages feature coming soon',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onInverseSurface,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.inverseSurface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
        break;
      case 4:
        Navigator.pushNamed(context, '/user-profile-settings');
        break;
    }
  }
}
