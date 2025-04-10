import 'package:flutter/material.dart';
import 'package:driver_application/screens/apply_leave_screen.dart';

class ViewLeavesScreen extends StatelessWidget {
  const ViewLeavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGold = Color(0xFFD88226);
    final darkText = Color(0xFF0B192E);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: darkText,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Leave History',
          style: TextStyle(
            color: primaryGold,
            fontSize: 18, // Increased from 16
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryGold, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              primaryGold,
              primaryGold.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primaryGold.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ApplyLeaveScreen()),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.event_note, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Apply Leave',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: darkText,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                    child: _buildCompactStat('12', 'Total', Icons.event_note)),
                Container(height: 30, width: 1, color: Colors.white12),
                Expanded(
                    child: _buildCompactStat(
                        '2', 'Pending', Icons.hourglass_empty)),
                Container(height: 30, width: 1, color: Colors.white12),
                Expanded(
                    child: _buildCompactStat(
                        '8', 'Approved', Icons.check_circle_outline)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: 5,
              itemBuilder: (context, index) => _buildCompactLeaveCard(
                startDate: '2024-04-${10 + index}',
                endDate: '2024-04-${11 + index}',
                type: index % 2 == 0 ? 'Sick Leave' : 'Personal Leave',
                status: _getStatus(index),
                reason: 'Medical appointment',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStat(String value, String label, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white70, size: 22), // Increased from 18
        SizedBox(height: 4), // Increased from 2
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16, // Increased from 14
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white60,
            fontSize: 13, // Increased from 11
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLeaveCard({
    required String startDate,
    required String endDate,
    required String type,
    required String status,
    required String reason,
  }) {
    Color statusColor = status.toLowerCase() == 'approved'
        ? Colors.green
        : status.toLowerCase() == 'rejected'
            ? Colors.red
            : Colors.orange;

    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 8), // Increased from 6
      elevation: 1, // Increased from 0.5
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Increased from 8
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(14), // Increased from 10
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    type,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15, // Increased from 13
                      color: Colors.grey[800],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8, // Increased from 6
                    vertical: 4, // Increased from 2
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6), // Increased from 4
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6, // Increased from 4
                        height: 6, // Increased from 4
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6), // Increased from 4
                      Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 13, // Increased from 11
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8), // Increased from 6
            Row(
              children: [
                Icon(Icons.calendar_today,
                    size: 14, color: Colors.grey[600]), // Increased from 12
                SizedBox(width: 6), // Increased from 4
                Text(
                  '$startDate - $endDate',
                  style: TextStyle(
                    fontSize: 13, // Increased from 11
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(width: 16), // Increased from 12
                Icon(Icons.notes,
                    size: 14, color: Colors.grey[600]), // Increased from 12
                SizedBox(width: 6), // Increased from 4
                Expanded(
                  child: Text(
                    reason,
                    style: TextStyle(
                      fontSize: 13, // Increased from 11
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatus(int index) {
    switch (index) {
      case 0:
        return 'Pending';
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      default:
        return 'Pending';
    }
  }
}
