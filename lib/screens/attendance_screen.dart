import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:driver_application/theme/theme_constants.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  bool isCheckedIn = false;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final goldAccent = Color(0xFFD88226);
    final darkText = Color(0xFF0B192E);

    return Scaffold(
      backgroundColor: ThemeConstants.secondaryBlue,
      appBar: AppBar(
        backgroundColor: ThemeConstants.secondaryBlue,
        elevation: 0,
        flexibleSpace: Container(
          decoration: ThemeConstants.gradientBackground,
        ),
        titleSpacing: 8,
        toolbarHeight: 60,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: goldAccent, size: 24),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF0B192E).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.fingerprint,
                color: goldAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Attendance',
              style: TextStyle(
                color: goldAccent,
                fontWeight: FontWeight.w600,
                fontSize: 20,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade50,
              Colors.grey.shade100,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Status Card
            Container(
              margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF0B192E),
                    Color(0xFF0B192E).withOpacity(0.8)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Current Status',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isCheckedIn
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isCheckedIn ? 'Checked In' : 'Not Checked In',
                                style: TextStyle(
                                  color:
                                      isCheckedIn ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (checkInTime != null)
                          _buildTimeCard(
                            'Check-in Time',
                            '${checkInTime!.hour}:${checkInTime!.minute.toString().padLeft(2, '0')}',
                            Icons.login,
                            Colors.green,
                          ),
                        if (checkOutTime != null)
                          _buildTimeCard(
                            'Check-out Time',
                            '${checkOutTime!.hour}:${checkOutTime!.minute.toString().padLeft(2, '0')}',
                            Icons.logout,
                            Colors.red,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Slider Section
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        isCheckedIn
                            ? 'Slide to Check Out'
                            : 'Slide to Check In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkText,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: SliderButton(
                        action: () {
                          setState(() {
                            if (isCheckedIn) {
                              checkOutTime = DateTime.now();
                            } else {
                              checkInTime = DateTime.now();
                            }
                            isCheckedIn = !isCheckedIn;
                          });
                          _animationController.forward().then((_) {
                            _animationController.reverse();
                          });
                        },
                        label: Text(
                          isCheckedIn
                              ? "Slide to Check Out"
                              : "Slide to Check In",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                          ),
                        ),
                        icon: Icon(
                          isCheckedIn ? Icons.logout : Icons.login,
                          color: Colors.white,
                          size: 20,
                        ),
                        backgroundColor:
                            isCheckedIn ? Colors.red : Colors.green,
                        buttonColor: Colors.white,
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

  Widget _buildTimeCard(String title, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SliderButton extends StatefulWidget {
  final Function action;
  final Widget label;
  final Widget icon;
  final Color backgroundColor;
  final Color buttonColor;

  const SliderButton({
    super.key,
    required this.action,
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.buttonColor,
  });

  @override
  State<SliderButton> createState() => _SliderButtonState();
}

class _SliderButtonState extends State<SliderButton>
    with TickerProviderStateMixin {
  double _value = 0.0; // 0.0 to 1.0 representing percentage
  bool _isDragging = false;

  late AnimationController _slideController;
  late Animation<double> _slideAnimation;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _handlePanEnd(DragEndDetails details) {
    if (!mounted) return;
    if (_value >= 0.95) {
      widget.action();
      // Add a completion animation if desired (e.g., ripple)
    }
    setState(() {
      _isDragging = false;
      _value = 0.0;
      _slideController.reverse(from: _slideController.value);
      _pulseController.repeat(reverse: true); // Resume pulsing
    });
  }

  @override
  Widget build(BuildContext context) {
    final double thumbSize = 60.0;
    final double trackHeight = 60.0;
    final borderRadius = BorderRadius.circular(trackHeight / 2);

    return ClipRect(
      clipBehavior: Clip.none,
      child: GestureDetector(
        onHorizontalDragStart: (_) => setState(() {
          _isDragging = true;
          _pulseController.stop();
        }),
        onHorizontalDragUpdate: (details) {
          if (!mounted) return;
          final RenderBox box = context.findRenderObject() as RenderBox;
          final localPosition = box.globalToLocal(details.globalPosition);

          setState(() {
            _isDragging = true;
            final newPosition = localPosition.dx - thumbSize / 2;
            final trackWidth = box.size.width - thumbSize;
            _value = (newPosition / trackWidth).clamp(0.0, 1.0);
            _slideController.value = _value;
            _pulseController.stop();
          });
        },
        onHorizontalDragEnd: _handlePanEnd,
        behavior: HitTestBehavior.translucent,
        child: Container(
          clipBehavior: Clip.none,
          height: trackHeight,
          width: 320, // Slightly wider
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade200, // Lighter background
            borderRadius: borderRadius,
            border: Border.all(
              color: widget.backgroundColor
                  .withOpacity(0.3), // More visible border
              width: 2.0, // Thicker border
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackWidth = constraints.maxWidth - thumbSize;
              final currentThumbX = _value * trackWidth;

              return Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  // Background Fill
                  AnimatedBuilder(
                    animation: _slideController,
                    builder: (context, child) {
                      return ClipRRect(
                        borderRadius: borderRadius,
                        child: Container(
                          width:
                              thumbSize + (_slideAnimation.value * trackWidth),
                          height: trackHeight,
                          decoration: BoxDecoration(
                            color: widget.backgroundColor, // Full opacity
                            borderRadius: borderRadius,
                          ),
                        ),
                      );
                    },
                  ),

                  // Label Text
                  Positioned(
                    left: thumbSize / 2,
                    right: thumbSize / 2,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: (1.0 - (_value * 2)).clamp(0.0, 1.0),
                        duration: const Duration(milliseconds: 150),
                        child: DefaultTextStyle.merge(
                          style: TextStyle(
                            color: _value > 0.2
                                ? Colors.white
                                : Colors.black87, // Dynamic text color
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: widget.label,
                        ),
                      ),
                    ),
                  ),

                  // Thumb
                  Positioned(
                    left: currentThumbX,
                    child: AnimatedBuilder(
                      animation: _pulseAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _isDragging ? 1.0 : _pulseAnimation.value,
                          child: Container(
                            width: thumbSize,
                            height: thumbSize,
                            decoration: BoxDecoration(
                              color: widget.buttonColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: widget.backgroundColor.withOpacity(0.5),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                child: _value > 0.5
                                    ? Icon(
                                        Icons.check_rounded,
                                        key: const ValueKey('check'),
                                        color: widget.backgroundColor,
                                        size: 32,
                                      )
                                    : Icon(
                                        (widget.icon is Icon)
                                            ? (widget.icon as Icon).icon
                                            : Icons.error,
                                        key: const ValueKey('icon'),
                                        color: widget.backgroundColor,
                                        size: 28,
                                      ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Helper class for rotating the shimmer gradient
class _GradientRotation extends GradientTransform {
  final double radians;
  const _GradientRotation(this.radians);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    final double R = radians;
    final double S = math.cos(R);
    final double C = math.sin(R);
    final double D = bounds.height / bounds.width;
    final double X = bounds.left + bounds.width / 2;
    final double Y = bounds.top + bounds.height / 2;

    return Matrix4.identity()
      ..translate(X, Y)
      ..rotateZ(R)
      ..scale(1.0, D, 1.0)
      ..translate(-X, -Y);
  }
}
