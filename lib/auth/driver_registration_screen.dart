import 'package:driver_application/screens/main_screen.dart';
import 'package:flutter/material.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() => _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _licenseController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _nameController.dispose();
    _licenseController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay for registration submission
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
          _isSubmitted = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Registration submitted for admin approval'),
            backgroundColor: Colors.amber.shade800,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  void _simulateApproval() async {
    setState(() {
      _isLoading = true;
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Your registration has been approved!'),
          backgroundColor: Colors.amber.shade800,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const MainScreen(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.grey.shade900.withOpacity(0.8),
              Colors.black,
            ],
          ),
          image: DecorationImage(
            image: const AssetImage('assets/images/subtle_pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.05,
            colorFilter: ColorFilter.mode(
              Colors.amber.withOpacity(0.1),
              BlendMode.overlay,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Centered logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.amber.shade200,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: RadialGradient(
                            colors: [
                              Colors.amber.withOpacity(0.15),
                              Colors.transparent,
                            ],
                            stops: const [0.1, 1.0],
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            'R',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Company name and tagline - centered
                      const Text(
                        'RAYAN TRAVELS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 120,
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.amber.shade200,
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'CREATING MEMORIES',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white70,
                          letterSpacing: 1.5,
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Header text with decorative elements
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.amber.shade200.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!_isSubmitted) 
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber.shade200,
                              ),
                            if (!_isSubmitted) const SizedBox(width: 8),
                            Text(
                              _isSubmitted ? 'APPLICATION PENDING APPROVAL' : 'JOIN OUR ELITE TEAM',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _isSubmitted ? Colors.amber.shade200 : Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                            if (!_isSubmitted) const SizedBox(width: 8),
                            if (!_isSubmitted) 
                              Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber.shade200,
                              ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Main content
                      if (_isSubmitted) 
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.withOpacity(0.3)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.hourglass_top,
                                  color: Colors.amber.shade200,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PENDING APPROVAL',
                                      style: TextStyle(
                                        color: Colors.amber.shade200,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Your application is being reviewed by our team',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Form fields or submitted info
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20.0),
                        child: _isSubmitted
                            ? _buildSubmittedInfo()
                            : _buildRegistrationForm(),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Button with enhanced styling
                      Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(
                          maxWidth: 400,
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: _isSubmitted 
                                  ? Colors.amber.withOpacity(0.2) 
                                  : Colors.white.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading 
                              ? null 
                              : (_isSubmitted ? _simulateApproval : _submitForm),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isSubmitted 
                                ? Colors.amber.shade700 
                                : Colors.white,
                            foregroundColor: Colors.black,
                            disabledBackgroundColor: Colors.white24,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: _isSubmitted ? Colors.black : Colors.amber.shade700,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (!_isSubmitted) 
                                      Icon(
                                        Icons.verified_user_outlined,
                                        size: 16,
                                        color: Colors.amber.shade800,
                                      ),
                                    if (!_isSubmitted) const SizedBox(width: 8),
                                    Text(
                                      _isSubmitted ? 'CHECK STATUS' : 'REGISTER',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: _isSubmitted ? Colors.black : Colors.amber.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      
                      // Terms text with subtle divider
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            width: 40,
                            height: 1,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          Text(
                            'By registering, you agree to our Terms & Privacy Policy',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4), 
                              fontSize: 10,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildRegistrationForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 16,
              color: Colors.amber.shade200,
              margin: const EdgeInsets.only(right: 8),
            ),
            const Text(
              'PERSONAL INFORMATION',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: _nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'FULL NAME',
            labelStyle: TextStyle(
              color: Colors.amber.shade200.withOpacity(0.7),
              fontSize: 12,
              letterSpacing: 1,
            ),
            prefixIcon: Icon(Icons.person_outline, color: Colors.amber.shade200.withOpacity(0.7), size: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.amber.shade200),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.redAccent.shade200),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.redAccent.shade200),
            ),
            errorStyle: TextStyle(color: Colors.redAccent.shade200, fontSize: 10),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _licenseController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'LICENSE NUMBER',
            labelStyle: TextStyle(
              color: Colors.amber.shade200.withOpacity(0.7),
              fontSize: 12,
              letterSpacing: 1,
            ),
            prefixIcon: Icon(Icons.badge_outlined, color: Colors.amber.shade200.withOpacity(0.7), size: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.amber.shade200),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.redAccent.shade200),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.redAccent.shade200),
            ),
            errorStyle: TextStyle(color: Colors.redAccent.shade200, fontSize: 10),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your license number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'PHONE NUMBER',
            labelStyle: TextStyle(
              color: Colors.amber.shade200.withOpacity(0.7),
              fontSize: 12,
              letterSpacing: 1,
            ),
            prefixIcon: Icon(Icons.phone_outlined, color: Colors.amber.shade200.withOpacity(0.7), size: 20),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.amber.shade200),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.redAccent.shade200),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.redAccent.shade200),
            ),
            errorStyle: TextStyle(color: Colors.redAccent.shade200, fontSize: 10),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
              return 'Please enter a valid 10-digit phone number';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  Widget _buildSubmittedInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 3,
              height: 16,
              color: Colors.amber.shade200,
              margin: const EdgeInsets.only(right: 8),
            ),
            const Text(
              'APPLICATION DETAILS',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildInfoRow(Icons.person_outline, 'Full Name', _nameController.text),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        _buildInfoRow(Icons.badge_outlined, 'License Number', _licenseController.text),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        _buildInfoRow(Icons.phone_outlined, 'Phone Number', _phoneController.text),
      ],
    );
  }
  
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: Colors.amber.shade200.withOpacity(0.7),
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
            ),
          ],
        ),
      ),
      ],
    );
  }
} 