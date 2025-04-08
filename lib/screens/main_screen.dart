import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'wallet_screen.dart';
import 'leaves_management_screen.dart';
import 'expense_screen.dart';
import 'attendance_screen.dart';
import 'diesel_section_screen.dart';
import 'notifications_screen.dart';
import 'boarding_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const WalletScreen(),
    const ExpenseScreen(),
    const AttendanceScreen(),
    const NotificationsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Define colors to match the app's black and gold theme
    final orangeColor = Colors.orange;
    
    return Scaffold(
      body: _screens[_selectedIndex],
      extendBody: true,
      bottomNavigationBar: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Left side items
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.grid_view_rounded, 'HOME', 0),
                  _buildNavItem(Icons.account_balance_wallet_rounded, 'WALLET', 1),
                ],
              ),
            ),
            
            // Center button
            _buildCenterButton(context, orangeColor),
            
            // Right side items
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.receipt_long_rounded, 'EXPENSES', 2),
                  _buildNotificationNavItem('ALERTS', 4),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildNavItem(IconData icon, String label, int index) {
    final orangeColor = Colors.orange;
    final isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: isSelected ? orangeColor : Colors.white.withOpacity(0.5),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? orangeColor : Colors.white.withOpacity(0.5),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildNotificationNavItem(String label, int index) {
    final orangeColor = Colors.orange;
    final isSelected = _selectedIndex == index;
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(
                Icons.notifications_rounded,
                size: 24,
                color: isSelected ? orangeColor : Colors.white.withOpacity(0.5),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: const Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? orangeColor : Colors.white.withOpacity(0.5),
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCenterButton(BuildContext context, Color orangeColor) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: orangeColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.apps_rounded,
          color: Colors.black,
          size: 24,
        ),
        onPressed: () => _showQuickAccessMenu(context),
      ),
    );
  }
  
  void _showQuickAccessMenu(BuildContext context) {
    final goldAccent = Colors.amber.shade200;
    final darkGold = Colors.amber.shade800;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    color: goldAccent,
                    margin: const EdgeInsets.only(right: 8),
                  ),
                  const Text(
                    'QUICK ACCESS',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickAccessItem(
                    context,
                    'Diesel',
                    Icons.local_gas_station_rounded,
                    darkGold,
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DieselSectionScreen()),
                      );
                    },
                  ),
                  _buildQuickAccessItem(
                    context,
                    'Leaves',
                    Icons.event_busy_rounded,
                    darkGold,
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LeavesManagementScreen()),
                      );
                    },
                  ),
                  _buildQuickAccessItem(
                    context,
                    'Boarding',
                    Icons.home_rounded,
                    darkGold,
                    () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BoardingScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildQuickAccessItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 28,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
} 