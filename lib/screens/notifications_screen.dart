import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Define theme colors to match app's design with more professional palette
    final primaryGold = Color(0xFFD88226);
    final darkText = Colors.grey.shade900;

    // Calculate the bottom padding needed to account for the bottom navigation bar
    final bottomPadding = MediaQuery.of(context).padding.bottom +
        65; // 65 is the height of the bottom nav bar

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B192E),
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 56, // More compact
        centerTitle: false,
        leading: IconButton(
          icon: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryGold.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_back, color: primaryGold)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: primaryGold, size: 22),
            onPressed: () {
              // Show notification filters
            },
          ),
          IconButton(
            icon: Icon(Icons.done_all, color: primaryGold, size: 22),
            onPressed: () {
              // Mark all as read
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
            // Notifications Summary Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              height: 130, // Fixed height for compactness
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
                              'Notification Center',
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
                                color: Colors.red.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.notifications_active,
                                    size: 12,
                                    color: Colors.red.shade300,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '5 NEW',
                                    style: TextStyle(
                                      color: Colors.red.shade300,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Bottom - Categories summary
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildNotificationStat(
                              context,
                              'System',
                              '3',
                              primaryGold,
                            ),
                            _buildNotificationStat(
                              context,
                              'Trips',
                              '2',
                              Colors.lightBlue.shade300,
                            ),
                            _buildNotificationStat(
                              context,
                              'Payments',
                              '1',
                              Colors.green.shade300,
                            ),
                            _buildNotificationStat(
                              context,
                              'Alerts',
                              '0',
                              Colors.red.shade300,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Today's Notifications
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
                        'TODAY',
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
                          'CLEAR ALL',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 0.8,
                            color: primaryGold,
                          ),
                        ),
                        Icon(Icons.delete_outline,
                            size: 16, color: primaryGold),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Today's notification items
            _buildNotificationItem(
              context,
              'System Update',
              '2 hours ago',
              'App updated to version 2.3.5 with new features',
              Icons.system_update,
              const Color(0xFF7C4DFF),
              isUnread: true,
            ),
            _buildNotificationItem(
              context,
              'New Trip Assigned',
              '3 hours ago',
              'You have been assigned a new trip to Chennai',
              Icons.directions_car_filled,
              const Color(0xFF42A5F5),
              isUnread: true,
            ),
            _buildNotificationItem(
              context,
              'Payment Received',
              '5 hours ago',
              'You received ₹2,450 for trip #1234',
              Icons.payment,
              const Color(0xFF66BB6A),
              isUnread: true,
            ),

            // Yesterday's Notifications
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
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
                        'YESTERDAY',
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
                          'CLEAR ALL',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                            letterSpacing: 0.8,
                            color: primaryGold,
                          ),
                        ),
                        Icon(Icons.delete_outline,
                            size: 16, color: primaryGold),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Yesterday's notification items
            _buildNotificationItem(
              context,
              'Trip Completed',
              'Yesterday',
              'Trip #1234 to Bangalore has been completed successfully',
              Icons.check_circle,
              const Color(0xFF66BB6A),
              isUnread: false,
            ),
            _buildNotificationItem(
              context,
              'Maintenance Reminder',
              'Yesterday',
              'Your vehicle is due for regular maintenance',
              Icons.build,
              const Color(0xFFFF7043),
              isUnread: false,
            ),
            _buildNotificationItem(
              context,
              'Fuel Alert',
              'Yesterday',
              'Fuel level is below 20%. Please refill soon',
              Icons.local_gas_station,
              const Color(0xFFE53935),
              isUnread: false,
            ),

            // Older Notifications
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
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
                        'OLDER',
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

            // Older notification items
            _buildNotificationItem(
              context,
              'Weekly Summary',
              '3 days ago',
              'Your weekly performance summary is available',
              Icons.summarize,
              const Color(0xFF78909C),
              isUnread: false,
            ),
            _buildNotificationItem(
              context,
              'Holiday Notice',
              '5 days ago',
              'Office will be closed on May 25 for company holiday',
              Icons.event,
              const Color(0xFFFFCA28),
              isUnread: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationStat(
    BuildContext context,
    String label,
    String count,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              count,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationItem(BuildContext context, String title, String time,
      String message, IconData icon, Color color,
      {required bool isUnread}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isUnread ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color:
              isUnread ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            // View notification details
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Notification icon
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

                // Notification details
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
                              style: TextStyle(
                                fontWeight: isUnread
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            time,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11,
                              fontWeight: isUnread
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Unread indicator
                if (isUnread)
                  Container(
                    margin: const EdgeInsets.only(left: 8, top: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
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
