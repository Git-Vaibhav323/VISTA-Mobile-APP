import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/empty_state_widget.dart';
import './widgets/order_card_widget.dart';
import './widgets/quick_filter_chips_widget.dart';
import './widgets/search_filter_bar_widget.dart';
import './widgets/status_filter_tabs_widget.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({Key? key}) : super(key: key);

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Mock user role - in real app this would come from authentication
  String _userRole = 'vendor'; // 'vendor' or 'supplier'

  // Filter states
  int _selectedTabIndex = 0;
  List<String> _selectedQuickFilters = [];
  String? _selectedDateRange;
  bool _isMultiSelectMode = false;
  List<String> _selectedOrderIds = [];

  // Tab labels
  final List<String> _statusTabs = [
    'All',
    'Pending',
    'Confirmed',
    'Delivered',
    'Cancelled'
  ];

  // Quick filter options
  final List<Map<String, dynamic>> _quickFilters = [
    {'key': 'today', 'label': 'Today', 'icon': 'today'},
    {'key': 'this_week', 'label': 'This Week', 'icon': 'date_range'},
    {'key': 'high_amount', 'label': 'High Amount', 'icon': 'trending_up'},
    {'key': 'urgent', 'label': 'Urgent', 'icon': 'priority_high'},
    {'key': 'nearby', 'label': 'Nearby', 'icon': 'location_on'},
  ];

  // Mock orders data
  final List<Map<String, dynamic>> _mockOrders = [
    {
      'orderId': 'ORD001',
      'businessName': 'Sharma Spices & Masala',
      'status': 'pending',
      'totalAmount': 2450.00,
      'itemCount': 12,
      'estimatedTime': '2-3 hours',
      'orderDate': DateTime.now().subtract(const Duration(hours: 2)),
      'items': [
        'Garam Masala 1kg',
        'Red Chili Powder 500g',
        'Turmeric Powder 250g'
      ],
      'deliveryAddress': 'Shop 15, Main Market, Connaught Place, New Delhi',
      'paymentStatus': 'pending',
    },
    {
      'orderId': 'ORD002',
      'businessName': 'Delhi Fresh Vegetables',
      'status': 'confirmed',
      'totalAmount': 1850.75,
      'itemCount': 8,
      'estimatedTime': '1-2 hours',
      'orderDate': DateTime.now().subtract(const Duration(hours: 5)),
      'items': ['Onions 10kg', 'Tomatoes 5kg', 'Potatoes 8kg'],
      'deliveryAddress': 'Stall 23, Karol Bagh Market, New Delhi',
      'paymentStatus': 'paid',
    },
    {
      'orderId': 'ORD003',
      'businessName': 'Mumbai Street Food Supplies',
      'status': 'delivered',
      'totalAmount': 3200.50,
      'itemCount': 15,
      'estimatedTime': 'Delivered',
      'orderDate': DateTime.now().subtract(const Duration(days: 1)),
      'items': ['Pav Bread 50 pieces', 'Bhaji Mix 2kg', 'Chutneys 500ml each'],
      'deliveryAddress': 'Cart 7, Juhu Beach, Mumbai',
      'paymentStatus': 'paid',
    },
    {
      'orderId': 'ORD004',
      'businessName': 'Kolkata Sweets & Snacks',
      'status': 'cancelled',
      'totalAmount': 1200.00,
      'itemCount': 6,
      'estimatedTime': 'Cancelled',
      'orderDate': DateTime.now().subtract(const Duration(days: 2)),
      'items': ['Rasgulla Mix 1kg', 'Sugar 2kg', 'Milk Powder 500g'],
      'deliveryAddress': 'Shop 45, Park Street, Kolkata',
      'paymentStatus': 'refunded',
    },
    {
      'orderId': 'ORD005',
      'businessName': 'Chennai Dosa Batter Co.',
      'status': 'confirmed',
      'totalAmount': 950.25,
      'itemCount': 4,
      'estimatedTime': '3-4 hours',
      'orderDate': DateTime.now().subtract(const Duration(hours: 8)),
      'items': ['Dosa Batter 5L', 'Coconut Chutney 1L', 'Sambar Mix 500g'],
      'deliveryAddress': 'Stall 12, T. Nagar Market, Chennai',
      'paymentStatus': 'pending',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _tabController.addListener(_onTabChanged);

    // Simulate role detection - in real app this would come from auth
    _detectUserRole();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _detectUserRole() {
    // Mock role detection - in real app this would come from authentication service
    setState(() {
      _userRole = 'vendor'; // Change to 'supplier' to test supplier view
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedTabIndex = _tabController.index;
        _isMultiSelectMode = false;
        _selectedOrderIds.clear();
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredOrders() {
    List<Map<String, dynamic>> filteredOrders = List.from(_mockOrders);

    // Filter by status tab
    if (_selectedTabIndex > 0) {
      final selectedStatus = _statusTabs[_selectedTabIndex].toLowerCase();
      filteredOrders = filteredOrders
          .where((order) =>
              (order['status'] as String).toLowerCase() == selectedStatus)
          .toList();
    }

    // Filter by search query
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filteredOrders = filteredOrders
          .where((order) =>
              (order['businessName'] as String).toLowerCase().contains(query) ||
              (order['orderId'] as String).toLowerCase().contains(query) ||
              (order['items'] as List).any(
                  (item) => (item as String).toLowerCase().contains(query)))
          .toList();
    }

    // Apply quick filters
    for (String filter in _selectedQuickFilters) {
      switch (filter) {
        case 'today':
          filteredOrders = filteredOrders.where((order) {
            final orderDate = order['orderDate'] as DateTime;
            final now = DateTime.now();
            return orderDate.year == now.year &&
                orderDate.month == now.month &&
                orderDate.day == now.day;
          }).toList();
          break;
        case 'this_week':
          filteredOrders = filteredOrders.where((order) {
            final orderDate = order['orderDate'] as DateTime;
            final now = DateTime.now();
            final weekStart = now.subtract(Duration(days: now.weekday - 1));
            return orderDate.isAfter(weekStart);
          }).toList();
          break;
        case 'high_amount':
          filteredOrders = filteredOrders
              .where((order) => (order['totalAmount'] as double) > 2000.0)
              .toList();
          break;
        case 'urgent':
          filteredOrders = filteredOrders
              .where((order) =>
                  (order['status'] as String).toLowerCase() == 'pending')
              .toList();
          break;
      }
    }

    // Sort by date (newest first)
    filteredOrders.sort((a, b) =>
        (b['orderDate'] as DateTime).compareTo(a['orderDate'] as DateTime));

    return filteredOrders;
  }

  void _onQuickFilterToggle(String filterKey) {
    setState(() {
      if (_selectedQuickFilters.contains(filterKey)) {
        _selectedQuickFilters.remove(filterKey);
      } else {
        _selectedQuickFilters.add(filterKey);
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Orders',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedQuickFilters.clear();
                        _selectedDateRange = null;
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Clear All'),
                  ),
                ],
              ),
            ),

            Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2)),

            // Filter content would go here
            Expanded(
              child: Center(
                child: Text(
                  'Advanced filters coming soon...',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange != null
          ? DateTimeRange(
              start: DateTime.now().subtract(const Duration(days: 7)),
              end: DateTime.now(),
            )
          : null,
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange =
            '${picked.start.day}/${picked.start.month} - ${picked.end.day}/${picked.end.month}';
      });
    }
  }

  void _onOrderTap(Map<String, dynamic> order) {
    if (_isMultiSelectMode) {
      _toggleOrderSelection(order['orderId'] as String);
    } else {
      // Navigate to order details
      _showOrderDetails(order);
    }
  }

  void _onOrderLongPress(Map<String, dynamic> order) {
    setState(() {
      _isMultiSelectMode = true;
      _selectedOrderIds.add(order['orderId'] as String);
    });
  }

  void _toggleOrderSelection(String orderId) {
    setState(() {
      if (_selectedOrderIds.contains(orderId)) {
        _selectedOrderIds.remove(orderId);
        if (_selectedOrderIds.isEmpty) {
          _isMultiSelectMode = false;
        }
      } else {
        _selectedOrderIds.add(orderId);
      }
    });
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Order Details',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      size: 24,
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            Divider(
                height: 1,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2)),

            // Order details content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order info
                    Text(
                      'Order #${order['orderId']}',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      order['businessName'] as String,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryLight,
                      ),
                    ),
                    SizedBox(height: 3.h),

                    // Items list
                    Text(
                      'Items (${order['itemCount']})',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...(order['items'] as List)
                        .map((item) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 0.5.h),
                              child: Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'circle',
                                    size: 6,
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Text(
                                      item as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),

                    SizedBox(height: 3.h),

                    // Total amount
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '₹${(order['totalAmount'] as double).toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.titleLarge
                                ?.copyWith(
                              color: AppTheme.primaryLight,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // In real app, this would refresh data from API
    });
  }

  void _onFloatingActionButtonPressed() {
    if (_userRole == 'vendor') {
      // Navigate to new order flow
      Navigator.pushNamed(context, '/product-catalog-management');
    } else {
      // Show bulk actions for suppliers
      _showBulkActionsBottomSheet();
    }
  }

  void _showBulkActionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              margin: EdgeInsets.only(bottom: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Text(
              'Bulk Actions',
              style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'check_circle',
                size: 24,
                color: AppTheme.successLight,
              ),
              title: Text('Accept Multiple Orders'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'update',
                size: 24,
                color: AppTheme.primaryLight,
              ),
              title: Text('Bulk Status Update'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'receipt',
                size: 24,
                color: AppTheme.primaryLight,
              ),
              title: Text('Generate Invoices'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _getFilteredOrders();

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Order Management'),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: 0,
        actions: [
          if (_isMultiSelectMode) ...[
            TextButton(
              onPressed: () {
                setState(() {
                  _isMultiSelectMode = false;
                  _selectedOrderIds.clear();
                });
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _selectedOrderIds.isNotEmpty
                  ? () {
                      // Handle bulk actions
                      _showBulkActionsBottomSheet();
                    }
                  : null,
              child: Text('Actions (${_selectedOrderIds.length})'),
            ),
          ] else ...[
            IconButton(
              onPressed: () {
                // Navigate to notifications
              },
              icon: Stack(
                children: [
                  CustomIconWidget(
                    iconName: 'notifications',
                    size: 24,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
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
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/user-profile-settings');
              },
              icon: CustomIconWidget(
                iconName: 'person',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and Filter Bar
            SearchFilterBarWidget(
              searchController: _searchController,
              onFilterTap: _showFilterBottomSheet,
              onDateRangeTap: _showDateRangePicker,
              selectedDateRange: _selectedDateRange,
            ),

            // Status Filter Tabs
            StatusFilterTabsWidget(
              tabs: _statusTabs,
              selectedIndex: _selectedTabIndex,
              onTabSelected: (index) {
                _tabController.animateTo(index);
              },
            ),

            // Quick Filter Chips
            QuickFilterChipsWidget(
              filters: _quickFilters,
              selectedFilters: _selectedQuickFilters,
              onFilterToggle: _onQuickFilterToggle,
            ),

            // Orders List
            Expanded(
              child: filteredOrders.isEmpty
                  ? EmptyStateWidget(
                      userRole: _userRole,
                      currentFilter: _statusTabs[_selectedTabIndex],
                      onActionTap: () {
                        if (_userRole == 'vendor') {
                          Navigator.pushNamed(
                              context, '/product-catalog-management');
                        } else {
                          Navigator.pushNamed(
                              context, '/user-profile-settings');
                        }
                      },
                    )
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      color: AppTheme.primaryLight,
                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 10.h),
                        itemCount: filteredOrders.length,
                        itemBuilder: (context, index) {
                          final order = filteredOrders[index];
                          final orderId = order['orderId'] as String;
                          final isSelected =
                              _selectedOrderIds.contains(orderId);

                          return Slidable(
                            key: Key(orderId),
                            startActionPane: _userRole == 'vendor'
                                ? ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          // Track order
                                        },
                                        backgroundColor: AppTheme.primaryLight,
                                        foregroundColor: Colors.white,
                                        icon: Icons.track_changes,
                                        label: 'Track',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          // Reorder
                                        },
                                        backgroundColor: AppTheme.successLight,
                                        foregroundColor: Colors.white,
                                        icon: Icons.refresh,
                                        label: 'Reorder',
                                      ),
                                    ],
                                  )
                                : ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      if ((order['status'] as String)
                                              .toLowerCase() ==
                                          'pending') ...[
                                        SlidableAction(
                                          onPressed: (context) {
                                            // Accept order
                                          },
                                          backgroundColor:
                                              AppTheme.successLight,
                                          foregroundColor: Colors.white,
                                          icon: Icons.check,
                                          label: 'Accept',
                                        ),
                                        SlidableAction(
                                          onPressed: (context) {
                                            // Decline order
                                          },
                                          backgroundColor: AppTheme.errorLight,
                                          foregroundColor: Colors.white,
                                          icon: Icons.close,
                                          label: 'Decline',
                                        ),
                                      ] else ...[
                                        SlidableAction(
                                          onPressed: (context) {
                                            // Update status
                                          },
                                          backgroundColor:
                                              AppTheme.primaryLight,
                                          foregroundColor: Colors.white,
                                          icon: Icons.update,
                                          label: 'Update',
                                        ),
                                      ],
                                    ],
                                  ),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // Contact
                                  },
                                  backgroundColor: AppTheme.primaryLight,
                                  foregroundColor: Colors.white,
                                  icon: Icons.chat,
                                  label: 'Chat',
                                ),
                                if (_userRole == 'supplier')
                                  SlidableAction(
                                    onPressed: (context) {
                                      // Generate invoice
                                    },
                                    backgroundColor: AppTheme.secondaryLight,
                                    foregroundColor: Colors.white,
                                    icon: Icons.receipt,
                                    label: 'Invoice',
                                  ),
                              ],
                            ),
                            child: GestureDetector(
                              onLongPress: () => _onOrderLongPress(order),
                              child: Container(
                                decoration: isSelected
                                    ? BoxDecoration(
                                        color: AppTheme.primaryLight
                                            .withValues(alpha: 0.1),
                                        border: Border.all(
                                          color: AppTheme.primaryLight,
                                          width: 2,
                                        ),
                                      )
                                    : null,
                                child: OrderCardWidget(
                                  order: order,
                                  userRole: _userRole,
                                  onTap: () => _onOrderTap(order),
                                  onTrack: _userRole == 'vendor'
                                      ? () {
                                          // Handle track action
                                        }
                                      : null,
                                  onReorder: _userRole == 'vendor'
                                      ? () {
                                          // Handle reorder action
                                        }
                                      : null,
                                  onContact: () {
                                    // Handle contact action
                                  },
                                  onAccept: _userRole == 'supplier' &&
                                          (order['status'] as String)
                                                  .toLowerCase() ==
                                              'pending'
                                      ? () {
                                          // Handle accept action
                                        }
                                      : null,
                                  onDecline: _userRole == 'supplier' &&
                                          (order['status'] as String)
                                                  .toLowerCase() ==
                                              'pending'
                                      ? () {
                                          // Handle decline action
                                        }
                                      : null,
                                  onUpdateStatus: _userRole == 'supplier' &&
                                          (order['status'] as String)
                                                  .toLowerCase() !=
                                              'pending'
                                      ? () {
                                          // Handle update status action
                                        }
                                      : null,
                                  onGenerateInvoice: _userRole == 'supplier'
                                      ? () {
                                          // Handle generate invoice action
                                        }
                                      : null,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onFloatingActionButtonPressed,
        icon: CustomIconWidget(
          iconName: _userRole == 'vendor' ? 'add_shopping_cart' : 'inventory',
          size: 24,
          color: Colors.white,
        ),
        label: Text(_userRole == 'vendor' ? 'New Order' : 'Bulk Actions'),
        backgroundColor: AppTheme.primaryLight,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1, // Orders tab is active
        selectedItemColor: AppTheme.primaryLight,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'home',
              size: 24,
              color: AppTheme.primaryLight,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'shopping_bag',
              size: 24,
              color: AppTheme.primaryLight,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: _userRole == 'vendor' ? 'inventory' : 'store',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            activeIcon: CustomIconWidget(
              iconName: _userRole == 'vendor' ? 'inventory' : 'store',
              size: 24,
              color: AppTheme.primaryLight,
            ),
            label: _userRole == 'vendor' ? 'Inventory' : 'Catalog',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'chat',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'chat',
              size: 24,
              color: AppTheme.primaryLight,
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              size: 24,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'person',
              size: 24,
              color: AppTheme.primaryLight,
            ),
            label: 'Profile',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(
                  context,
                  _userRole == 'vendor'
                      ? '/vendor-dashboard'
                      : '/supplier-dashboard');
              break;
            case 1:
              // Already on orders page
              break;
            case 2:
              Navigator.pushNamed(context, '/product-catalog-management');
              break;
            case 3:
              // Navigate to messages
              break;
            case 4:
              Navigator.pushNamed(context, '/user-profile-settings');
              break;
          }
        },
      ),
    );
  }
}
