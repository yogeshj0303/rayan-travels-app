import 'package:flutter/material.dart';
import 'dart:ui';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define theme colors to match app's design with more professional palette
    final primaryGold = Colors.amber.shade700;
    final secondaryGold = Colors.amber.shade300;
    final darkText = Colors.grey.shade900;


    // Calculate the bottom padding needed to account for the bottom navigation bar
    final bottomPadding = MediaQuery.of(context).padding.bottom + 65; // 65 is the height of the bottom nav bar

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 8,
        toolbarHeight: 56, // More compact
        title: Row(
          children: [
            Icon(
              Icons.account_balance_wallet_rounded,
              color: secondaryGold,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Wallet',
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
            icon: Icon(Icons.history, color: secondaryGold, size: 22),
            onPressed: () {
              // Show full transaction history
            },
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: secondaryGold, size: 22),
            onPressed: () {
              // Show wallet options menu
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
            // Balance Card (more compact and professional)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              height: 180, // Fixed height for compactness
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF000000),
                    const Color(0xFF1A1A1A),
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
                  
                  // Decorative elements
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryGold.withOpacity(0.05),
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
                        // Top row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Available Balance',
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
                                    Icons.account_balance,
                                    size: 12,
                                    color: secondaryGold,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Virtual',
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
                        
                        // Balance display
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
                                '2,450',
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
                        
                        // Quick actions row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBalanceAction(
                              context,
                              Icons.add_circle_outline,
                              'Add Money',
                              secondaryGold,
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.white.withOpacity(0.1),
                            ),
                            _buildBalanceAction(
                              context,
                              Icons.send_outlined,
                              'Send Money',
                              secondaryGold,
                            ),
                            Container(
                              width: 1,
                              height: 24,
                              color: Colors.white.withOpacity(0.1),
                            ),
                            _buildBalanceAction(
                              context,
                              Icons.qr_code_scanner_outlined,
                              'Scan & Pay',
                              secondaryGold,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Quick Payment Options (enhanced)
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
                        'QUICK PAYMENTS',
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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

            // Quick Payment Options cards
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  _buildQuickPaymentOption(
                    context,
                    'Fuel',
                    Icons.local_gas_station_rounded,
                    const Color(0xFF7C4DFF),
                  ),
                  _buildQuickPaymentOption(
                    context,
                    'Food',
                    Icons.restaurant,
                    const Color(0xFFE53935),
                  ),
                  _buildQuickPaymentOption(
                    context,
                    'Toll',
                    Icons.car_rental,
                    const Color(0xFF1E88E5),
                  ),
                  _buildQuickPaymentOption(
                    context,
                    'Recharge',
                    Icons.phone_android,
                    const Color(0xFF43A047),
                  ),
                  _buildQuickPaymentOption(
                    context,
                    'More',
                    Icons.grid_view,
                    const Color(0xFF607D8B),
                  ),
                ],
              ),
            ),

            // Recent Transactions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
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
                        'RECENT TRANSACTIONS',
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
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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

            // Transactions list (enhanced)
            _buildTransactionItem(
              context,
              'Fuel Payment',
              'Yesterday, 3:45 PM',
              '- ₹450',
              Icons.local_gas_station_rounded,
              const Color(0xFFFF7043),
              isDebit: true,
            ),
            _buildTransactionItem(
              context,
              'Trip Bonus',
              'May 22, 2023',
              '+ ₹1,200',
              Icons.monetization_on,
              const Color(0xFF66BB6A),
              isDebit: false,
            ),
            _buildTransactionItem(
              context,
              'Toll Payment',
              'May 20, 2023',
              '- ₹125',
              Icons.car_rental,
              const Color(0xFF42A5F5),
              isDebit: true,
            ),
            _buildTransactionItem(
              context,
              'Weekly Incentive',
              'May 18, 2023',
              '+ ₹600',
              Icons.card_giftcard,
              const Color(0xFF9575CD),
              isDebit: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceAction(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // Handle tap on balance action
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: color,
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPaymentOption(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      width: 75,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle quick payment option tap
          },
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: color.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade800,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context,
    String title,
    String date,
    String amount,
    IconData icon,
    Color color, {
    required bool isDebit,
  }) {
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
            // View transaction details on tap
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                // Transaction icon
                Container(
                  padding: const EdgeInsets.all(10),
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
                
                // Transaction details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
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
                
                // Amount
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDebit 
                        ? Colors.red.shade50 
                        : Colors.green.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    amount,
                    style: TextStyle(
                      color: isDebit ? Colors.red.shade700 : Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
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