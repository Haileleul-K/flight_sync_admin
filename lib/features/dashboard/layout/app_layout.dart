import 'package:flight_sync_admin/core/base/app_session.dart';
import 'package:flight_sync_admin/core/constants/responses.dart';
import 'package:flight_sync_admin/features/auth/login_bloc/login_bloc.dart';
import 'package:flight_sync_admin/features/auth/login_bloc/login_state.dart';
import 'package:flight_sync_admin/features/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../dashboard.dart';
import '../../air_craft/aircraft_management_page.dart';
import '../../duty_position/duty_position_page.dart';
import '../../fac_level/fac_management_page.dart';
import '../../mission/mission_type_page.dart';
import '../../rank/rank_management_page.dart';
import '../../rl_level/rl_level_page.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard Overview',
      index: 0,
    ),
    NavigationItem(
      icon: Icons.flight_outlined,
      selectedIcon: Icons.flight,
      label: 'Aircraft Management',
      index: 1,
    ),
    NavigationItem(
      icon: Icons.assignment_outlined,
      selectedIcon: Icons.assignment,
      label: 'FAC Level Management',
      index: 2,
    ),
    NavigationItem(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Duty Position Management',
      index: 3,
    ),
    NavigationItem(
      icon: Icons.category_outlined,
      selectedIcon: Icons.category,
      label: 'Mission Type Management',
      index: 4,
    ),
    NavigationItem(
      icon: Icons.military_tech_outlined,
      selectedIcon: Icons.military_tech,
      label: 'Rank Management',
      index: 5,
    ),
    NavigationItem(
      icon: Icons.trending_up_outlined,
      selectedIcon: Icons.trending_up,
      label: 'RL Level Management',
      index: 6,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebView = screenWidth > 800;
    final isLargeScreen = screenWidth > 1200;

    return Scaffold(
      key: _scaffoldKey,
      appBar: isWebView ? null : _buildMobileAppBar(),
      drawer: isWebView ? null : _buildDrawer(),
      body: SafeArea(
        child: Row(
          children: [
            if (isWebView)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isLargeScreen ? 200 : 60,
                child: _buildSideMenu(!isLargeScreen),
              ),
            Expanded(
              child: Column(
                children: [
                  if (isWebView) _buildHeader(isLargeScreen: isLargeScreen),
                  Expanded(
                    child: _buildPageContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildMobileAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.grey),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: Row(
        children: [
          Image.asset(
            'assets/images/flight.png',
            height: 28,
          ),
          const SizedBox(width: 12),
          const Text(
            'SkyLog Pro',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.power_settings_new, color: Colors.grey),
          onPressed: () {
            showDialog(
                context: context, builder: (context) => logout_action(context));
          },
        ),
      ],
    );
  }

  AlertDialog logout_action(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        textAlign: TextAlign.center,
              'Are you sure you want to logout?',
              style: TextStyle(
                
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
      content: Container(
        width: MediaQuery.of(context).size.width > 600 ? 400 : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            const SizedBox(height: 8),
            Text(
              'You will need to login again to access your account.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
      actions: [
       ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
            style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black12,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          
          ),
          child:const Text(
            'Cancel',style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            
            ),),
        ),

        SizedBox(height: 10,),
        ElevatedButton(
          onPressed: () {
            AppSession.clearAccessToken();
            Get.offAll(() => LoginPage());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
          child: const Text(
            'Logout',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    );
  }

  Widget _buildHeader({required bool isLargeScreen}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            _navigationItems[_selectedIndex].label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue,
            child: Text('A'),
          ),
          SizedBox(
            width: 15,
          ),
          IconButton(
              icon: const Icon(Icons.power_settings_new),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => logout_action(context));
              }),
        ],
      ),
    );
  }

  Widget _buildSideMenu(bool isCollapsed) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isCollapsed ? 12 : 16,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: isCollapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/flight.png',
                    height: 28,
                  ),
                  if (!isCollapsed) ...[
                    const SizedBox(width: 12),
                    const Text(
                      'SkyLog Pro',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: _navigationItems.map((item) {
                    return _buildMenuItem(
                      icon: item.icon,
                      selectedIcon: item.selectedIcon,
                      title: item.label,
                      isSelected: _selectedIndex == item.index,
                      isCollapsed: isCollapsed,
                      onTap: () => _onItemSelected(item.index),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (!isCollapsed) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '© 2025 SkyLog Pro Inc.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      child: _buildSideMenu(false),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required bool isSelected,
    required bool isCollapsed,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Tooltip(
        message: isCollapsed ? title : '',
        child: ListTile(
          dense: true,
          horizontalTitleGap: 12,
          contentPadding: EdgeInsets.symmetric(
            horizontal: isCollapsed ? 8 : 12,
            vertical: 0,
          ),
          leading: Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? Colors.blue : Colors.grey[600],
            size: 20,
          ),
          title: isCollapsed
              ? null
              : Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.grey[800],
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardPage();
      case 1:
        return const AircraftManagementPage();
      case 2:
        return const FACManagementPage();
      case 3:
        return const DutyPositionPage();
      case 4:
        return const MissionTypePage();
      case 5:
        return const RankManagementPage();
      case 6:
        return const RLLevelPage();
      default:
        return const DashboardPage();
    }
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Close drawer on mobile view
    if (MediaQuery.of(context).size.width <= 800) {
      Navigator.pop(context);
    }
  }
}

class NavigationItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int index;

  NavigationItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.index,
  });
}
