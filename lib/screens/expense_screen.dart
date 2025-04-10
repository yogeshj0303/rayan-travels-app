import 'package:driver_application/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define theme colors to match app's design with more professional palette
    final primaryGold = Color(0xFFD88226); // Gold color
    final secondaryGold = Color(0xFFD88226); // Lighter gold color
    final darkText = Color(0xFF0B192E); // Dark text color

    // Calculate the bottom padding needed to account for the bottom navigation bar
    final bottomPadding = MediaQuery.of(context).padding.bottom +
        65; // 65 is the height of the bottom nav bar

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B192E),
        elevation: 0,
        titleSpacing: 8,
        toolbarHeight: 56, // More compact
        title: Row(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              color: secondaryGold,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Expenses',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: secondaryGold, size: 22),
            onPressed: () {
              // Show expense filters
            },
          ),
          IconButton(
            icon:
                Icon(Icons.add_circle_outline, color: secondaryGold, size: 22),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddExpenseScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Add padding at the bottom to prevent content from being hidden behind the nav bar
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expense Summary Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              height: 160, // Fixed height for compactness
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF0B192E),
                    const Color(0xFF0B192E),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Subtle pattern overlay
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ShaderMask(
                        shaderCallback: (rect) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.05),
                            ],
                          ).createShader(rect);
                        },
                        blendMode: BlendMode.dstIn,
                        child: Image.network(
                          'https://www.transparenttextures.com/patterns/carbon-fibre.png',
                          repeat: ImageRepeat.repeat,
                        ),
                      ),
                    ),
                  ),

                  // Card content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top row - Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'This Month\'s Expenses',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: primaryGold.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primaryGold.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: secondaryGold,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'MAY 2023',
                                    style: TextStyle(
                                      color: secondaryGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Middle - Total amount
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '₹',
                                style: TextStyle(
                                  color: secondaryGold,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '4,650',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                '.00',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom - Categories summary
                        Row(
                          children: [
                            _buildExpenseStat(
                              context,
                              'Fuel',
                              '₹2,250',
                              secondaryGold,
                              0.48,
                            ),
                            const SizedBox(width: 16),
                            _buildExpenseStat(
                              context,
                              'Food',
                              '₹1,475',
                              secondaryGold,
                              0.32,
                            ),
                            const SizedBox(width: 16),
                            _buildExpenseStat(
                              context,
                              'Other',
                              '₹925',
                              secondaryGold,
                              0.20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Recent Transactions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 3,
                        height: 16,
                        decoration: BoxDecoration(
                          color: primaryGold,
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                        margin: const EdgeInsets.only(right: 8),
                      ),
                      Text(
                        'RECENT EXPENSES',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: darkText,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: primaryGold,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'VIEW ALL',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 0.8,
                            color: primaryGold,
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 16, color: primaryGold),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Recent expense items
            _buildExpenseItem(
              context,
              'Diesel Refill',
              'Today, 10:30 AM',
              '₹850',
              'Station: Indian Oil, Chennai',
              Icons.local_gas_station_rounded,
              const Color(0xFFFF7043),
            ),
            _buildExpenseItem(
              context,
              'Highway Toll',
              'Today, 9:15 AM',
              '₹125',
              'NH7 Highway',
              Icons.car_rental,
              const Color(0xFF42A5F5),
            ),
            _buildExpenseItem(
              context,
              'Lunch',
              'Yesterday, 1:45 PM',
              '₹180',
              'Hotel Saravana Bhavan',
              Icons.restaurant,
              const Color(0xFFE53935),
            ),
            _buildExpenseItem(
              context,
              'Parking Fee',
              'Yesterday, 11:30 AM',
              '₹60',
              'Central Mall, Chennai',
              Icons.local_parking_rounded,
              const Color(0xFF66BB6A),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseStat(
    BuildContext context,
    String label,
    String amount,
    Color color,
    double percentage,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 4,
              backgroundColor: Colors.white.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
    BuildContext context,
    String title,
    String date,
    String amount,
    String description,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            // View expense details
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expense icon
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),

                // Expense details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            amount,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
