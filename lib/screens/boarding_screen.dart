import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:async';

class BoardingScreen extends StatefulWidget {
  const BoardingScreen({super.key});

  @override
  State<BoardingScreen> createState() => _BoardingScreenState();
}

class _BoardingScreenState extends State<BoardingScreen> with SingleTickerProviderStateMixin {
  bool _isScanning = true;
  bool _isProcessing = false;
  String _lastScanned = '';
  bool _torchEnabled = false;
  String? _errorMessage;
  MobileScannerController? _scannerController;
  
  // Animation controller for scanner line
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Initialize scanner controller with error handling
    try {
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: false,
        formats: const [BarcodeFormat.qrCode],
      );
      // We can't use onCancel and onError as they aren't available
      // Error handling will be done with try-catch blocks instead
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to initialize camera: $e";
      });
    }
    
    // Initialize animation controller for scanner line
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
    // Start scanning animation
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scannerController?.dispose();
    super.dispose();
  }

  // Method to handle successful scans
  void _handleSuccessfulScan(String code) {
    if (!mounted) return;
    
    setState(() {
      _lastScanned = code;
      _isScanning = false;
      _isProcessing = true;
    });
    
    // Simulate processing the code
    Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        // Show the success notification
        _showSuccessNotification(code);
        
        // Reset after delay
        Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isScanning = true;
            });
          }
        });
      }
    });
  }
  
  // Method to show success notification
  void _showSuccessNotification(String code) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Successfully scanned: $code',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  // Method to retry after error
  void _retryScanner() {
    setState(() {
      _errorMessage = null;
    });
    
    // Re-initialize scanner
    try {
      _scannerController?.dispose();
      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.normal,
        facing: CameraFacing.back,
        torchEnabled: _torchEnabled,
        formats: const [BarcodeFormat.qrCode],
      );
      setState(() {});
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to restart scanner: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define theme colors to match app's design with more professional palette
    final primaryGold = Colors.amber.shade700;
    final secondaryGold = Colors.amber.shade300;

    // Scanner overlay dimensions
    final scannerOverlaySize = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        titleSpacing: 8,
        toolbarHeight: 56, // More compact
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryGold, size: 22),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Icon(
              Icons.qr_code_scanner,
              color: secondaryGold,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Text(
              'Boarding Scanner',
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
            icon: Icon(
              _torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: secondaryGold, 
              size: 22
            ),
            onPressed: () {
              try {
                setState(() {
                  _torchEnabled = !_torchEnabled;
                  _scannerController?.toggleTorch();
                });
              } catch (e) {
                setState(() {
                  _errorMessage = "Failed to toggle torch: $e";
                });
              }
            },
          ),
          IconButton(
            icon: Icon(
              Icons.settings,
              color: secondaryGold, 
              size: 22
            ),
            onPressed: () {
              // Could implement scanner settings here
              // For now just a placeholder
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Scanner settings'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Error state
          if (_errorMessage != null)
            _buildErrorState(primaryGold, secondaryGold)
          // Normal scanner state  
          else
            Stack(
              children: [
                // Scanner
                MobileScanner(
                  controller: _scannerController,
                  onDetect: (capture) {
                    if (!_isScanning || _isProcessing) return;
                    
                    try {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes) {
                        final String code = barcode.rawValue ?? '';
                        if (code.isNotEmpty && code != _lastScanned) {
                          _handleSuccessfulScan(code);
                          break;
                        }
                      }
                    } catch (e) {
                      setState(() {
                        _errorMessage = "Error reading QR code: $e";
                      });
                    }
                  },
                  errorBuilder: (context, error, child) {
                    // Set the error message state
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _errorMessage = "Scanner error: ${error.errorDetails?.message ?? 'Unknown error'}";
                      });
                    });
                    
                    // Return an empty container, as the error UI is built elsewhere
                    return Container();
                  },
                ),
                
                // Overlay elements
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Scanner cut-out overlay
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.6),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Cut out area
                            Container(
                              width: scannerOverlaySize,
                              height: scannerOverlaySize,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                border: Border.all(
                                  color: primaryGold,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Corner markers
                      Positioned(
                        top: (MediaQuery.of(context).size.height - scannerOverlaySize) / 2 - 20,
                        left: (MediaQuery.of(context).size.width - scannerOverlaySize) / 2 - 20,
                        child: _buildCornerMarker(primaryGold, topLeft: true),
                      ),
                      Positioned(
                        top: (MediaQuery.of(context).size.height - scannerOverlaySize) / 2 - 20,
                        right: (MediaQuery.of(context).size.width - scannerOverlaySize) / 2 - 20,
                        child: _buildCornerMarker(primaryGold, topRight: true),
                      ),
                      Positioned(
                        bottom: (MediaQuery.of(context).size.height - scannerOverlaySize) / 2 - 20,
                        left: (MediaQuery.of(context).size.width - scannerOverlaySize) / 2 - 20,
                        child: _buildCornerMarker(primaryGold, bottomLeft: true),
                      ),
                      Positioned(
                        bottom: (MediaQuery.of(context).size.height - scannerOverlaySize) / 2 - 20,
                        right: (MediaQuery.of(context).size.width - scannerOverlaySize) / 2 - 20,
                        child: _buildCornerMarker(primaryGold, bottomRight: true),
                      ),
                      
                      // Animated scanner line
                      if (_isScanning && !_isProcessing)
                        AnimatedBuilder(
                          animation: _animationController,
                          builder: (context, child) {
                            return Positioned(
                              top: (MediaQuery.of(context).size.height - scannerOverlaySize) / 2 + 
                                   (_animation.value * scannerOverlaySize),
                              child: Container(
                                width: scannerOverlaySize - 20,
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      primaryGold.withOpacity(0.5),
                                      primaryGold,
                                      primaryGold.withOpacity(0.5),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGold.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      
                      // Processing indicator
                      if (_isProcessing)
                        Positioned(
                          top: (MediaQuery.of(context).size.height - scannerOverlaySize) / 2 + 
                                (scannerOverlaySize / 2) - 25,
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: CircularProgressIndicator(
                              color: primaryGold,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      
                      // Instructions
                      Positioned(
                        bottom: (MediaQuery.of(context).size.height - scannerOverlaySize) / 2 - 80,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: primaryGold.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _isProcessing 
                                  ? 'Processing QR code...' 
                                  : 'Position QR Code within frame',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isProcessing 
                                  ? 'Please wait a moment' 
                                  : 'Scanning will happen automatically',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Last scanned data display
                      if (_lastScanned.isNotEmpty && !_isScanning && !_isProcessing)
                        Positioned(
                          bottom: 40,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: primaryGold.withOpacity(0.5),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Scan Successful',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Text(
                                    _lastScanned,
                                    style: TextStyle(
                                      color: secondaryGold,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Scanning will resume automatically...",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryGold,
        foregroundColor: Colors.black,
        elevation: 4,
        onPressed: () {
          if (_errorMessage != null) {
            _retryScanner();
          } else {
            setState(() {
              _isScanning = true;
              _isProcessing = false;
              _lastScanned = '';
            });
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildErrorState(Color primaryGold, Color secondaryGold) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Scanner Error',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'Unknown error occurred',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry Scanner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _retryScanner,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCornerMarker(Color color, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return SizedBox(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: CornerPainter(
          color: color,
          topLeft: topLeft,
          topRight: topRight,
          bottomLeft: bottomLeft,
          bottomRight: bottomRight,
        ),
      ),
    );
  }
}

// Custom painter for corner markers
class CornerPainter extends CustomPainter {
  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  CornerPainter({
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final length = size.width * 0.4;

    if (topLeft) {
      canvas.drawLine(
        Offset(0, 0),
        Offset(length, 0),
        paint,
      );
      canvas.drawLine(
        Offset(0, 0),
        Offset(0, length),
        paint,
      );
    }

    if (topRight) {
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width - length, 0),
        paint,
      );
      canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width, length),
        paint,
      );
    }

    if (bottomLeft) {
      canvas.drawLine(
        Offset(0, size.height),
        Offset(length, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(0, size.height),
        Offset(0, size.height - length),
        paint,
      );
    }

    if (bottomRight) {
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width - length, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width, size.height - length),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
} 