import 'package:driver_application/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:driver_application/auth/login_screen.dart'; // Import the login screen

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() =>
      _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic Info Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime _selectedDOB = DateTime.now();
  final _addressController = TextEditingController();
  File? _profilePhoto;

  // License & ID Controllers
  final _licenseController = TextEditingController();
  DateTime _licenseExpiry = DateTime.now();
  final _aadharController = TextEditingController();
  final _panController = TextEditingController();

  // Add new document storage variables
  File? _licenseDocument;
  File? _aadharDocument;

  // Bus & Employment Controllers
  final _busNumberController = TextEditingController();
  DateTime _joiningDate = DateTime.now();
  final _salaryController = TextEditingController();
  String? _employmentType;

  // Dropdown options
  final List<String> _employmentTypes = ['Full Time', 'Part Time', 'Contract'];

  bool _isLoading = false;

  // Updated primary colors
  final Color primaryBrown = const Color(0xFFD88226);
  final Color secondaryBlue = const Color(0xFF0B192E);

  // State to manage collapsible sections
  bool _isBasicInfoExpanded = true;
  bool _isLicenseInfoExpanded = false;
  bool _isEmploymentInfoExpanded = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _busNumberController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _profilePhoto = File(image.path));
    }
  }

  Future<void> _pickDocument(String type) async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: secondaryBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: primaryBrown.withOpacity(0.2)),
        ),
        title: Text(
          'Select Document Source',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: primaryBrown),
              title: Text('Camera', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: primaryBrown),
              title: Text('Gallery', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final ImagePicker picker = ImagePicker();
      final XFile? document = await picker.pickImage(source: source);
      if (document != null) {
        setState(() {
          if (type == 'license') {
            _licenseDocument = File(document.path);
          } else if (type == 'aadhar') {
            _aadharDocument = File(document.path);
          }
        });
        _showSnackbar('Document uploaded successfully');
      }
    }
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
        });

        _showSnackbar('Registration successful');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: primaryBrown,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryBlue, // Updated background color
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              secondaryBlue,
              secondaryBlue.withOpacity(0.8),
              secondaryBlue,
            ],
          ),
          image: DecorationImage(
            image: const AssetImage('assets/images/subtle_pattern.png'),
            fit: BoxFit.cover,
            opacity: 0.05,
            colorFilter: ColorFilter.mode(
              primaryBrown.withOpacity(0.1),
              BlendMode.overlay,
            ),
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 50.0),
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
                            color: primaryBrown.withOpacity(0.5),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryBrown.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: RadialGradient(
                            colors: [
                              primaryBrown.withOpacity(0.15),
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
                          gradient: _getDividerGradient(),
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

                      const SizedBox(height: 24),

                      // Main content
                      // Collapsible sections
                      _buildCollapsibleSection(
                        title: 'BASIC INFORMATION',
                        isExpanded: _isBasicInfoExpanded,
                        onToggle: () => setState(
                            () => _isBasicInfoExpanded = !_isBasicInfoExpanded),
                        content: _buildBasicInfoSection(),
                      ),
                      const SizedBox(height: 16),

                      _buildCollapsibleSection(
                        title: 'LICENSE & ID DETAILS',
                        isExpanded: _isLicenseInfoExpanded,
                        onToggle: () => setState(() =>
                            _isLicenseInfoExpanded = !_isLicenseInfoExpanded),
                        content: _buildLicenseInfoSection(),
                      ),
                      const SizedBox(height: 16),

                      _buildCollapsibleSection(
                        title: 'BUS & EMPLOYMENT INFO',
                        isExpanded: _isEmploymentInfoExpanded,
                        onToggle: () => setState(() =>
                            _isEmploymentInfoExpanded =
                                !_isEmploymentInfoExpanded),
                        content: _buildEmploymentInfoSection(),
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
                              color: Colors.white.withOpacity(0.1),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryBrown,
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
                                    color: primaryBrown,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.verified_user_outlined,
                                      size: 16,
                                      color: primaryBrown,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'REGISTER',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                        color: primaryBrown,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Login option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            ),
                            child: Text(
                              'Login',
                              style: TextStyle(
                                color: primaryBrown,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

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

  Widget _buildCollapsibleSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
    required Widget content,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryBrown.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white,
            ),
            onTap: onToggle,
          ),
          if (isExpanded)
            Padding(padding: const EdgeInsets.all(16.0), child: content),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Profile Photo
        Center(
          child: GestureDetector(
            onTap: _pickProfilePhoto,
            child: _buildProfilePhotoContainer(),
          ),
        ),
        const SizedBox(height: 20),

        // Name Field
        _buildTextField(
          controller: _nameController,
          label: 'FULL NAME',
          icon: Icons.person_outline,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter your name' : null,
        ),
        const SizedBox(height: 16),

        // Email Field
        _buildTextField(
          controller: _emailController,
          label: 'EMAIL',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter your email';
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Phone Number Field
        _buildTextField(
          controller: _phoneController,
          label: 'PHONE NUMBER',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value?.isEmpty ?? true) return 'Please enter your phone number';
            if (!RegExp(r'^\d{10}$').hasMatch(value!)) {
              return 'Please enter a valid 10-digit phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Date of Birth
        _buildDatePicker(
          label: 'DATE OF BIRTH',
          selectedDate: _selectedDOB,
          onDateSelected: (date) => setState(() => _selectedDOB = date),
        ),
        const SizedBox(height: 16),

        // Address Field
        _buildTextField(
          controller: _addressController,
          label: 'ADDRESS',
          icon: Icons.location_on_outlined,
          maxLines: 3,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter your address' : null,
        ),
      ],
    );
  }

  Widget _buildLicenseInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // License Number with upload button
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _licenseController,
                label: 'LICENSE NUMBER',
                icon: Icons.badge_outlined,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter license number'
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: IconButton(
                onPressed: () => _pickDocument('license'),
                icon: Icon(
                  _licenseDocument != null
                      ? Icons.check_circle
                      : Icons.upload_file,
                  color: _licenseDocument != null ? Colors.green : primaryBrown,
                ),
                tooltip: 'Upload License Document',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // License Expiry
        _buildDatePicker(
          label: 'LICENSE EXPIRY',
          selectedDate: _licenseExpiry,
          onDateSelected: (date) => setState(() => _licenseExpiry = date),
        ),
        const SizedBox(height: 16),

        // Aadhar Number with upload button
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _aadharController,
                label: 'AADHAR NUMBER',
                icon: Icons.credit_card_outlined,
                validator: (value) => value?.isEmpty ?? true
                    ? 'Please enter Aadhar number'
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: IconButton(
                onPressed: () => _pickDocument('aadhar'),
                icon: Icon(
                  _aadharDocument != null
                      ? Icons.check_circle
                      : Icons.upload_file,
                  color: _aadharDocument != null ? Colors.green : primaryBrown,
                ),
                tooltip: 'Upload Aadhar Document',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // PAN Number
        _buildTextField(
          controller: _panController,
          label: 'PAN NUMBER',
          icon: Icons.article_outlined,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter PAN number' : null,
        ),
      ],
    );
  }

  Widget _buildEmploymentInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bus Number
        _buildTextField(
          controller: _busNumberController,
          label: 'ASSIGNED BUS NUMBER',
          icon: Icons.directions_bus_outlined,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter bus number' : null,
        ),
        const SizedBox(height: 16),

        // Joining Date
        _buildDatePicker(
          label: 'JOINING DATE',
          selectedDate: _joiningDate,
          onDateSelected: (date) => setState(() => _joiningDate = date),
        ),
        const SizedBox(height: 16),

        // Salary
        _buildTextField(
          controller: _salaryController,
          label: 'SALARY',
          icon: Icons.currency_rupee_outlined,
          keyboardType: TextInputType.number,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter salary' : null,
        ),
        const SizedBox(height: 16),

        // Employment Type
        _buildDropdown(
          label: 'EMPLOYMENT TYPE',
          value: _employmentType,
          items: _employmentTypes,
          onChanged: (value) => setState(() => _employmentType = value),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          color: primaryBrown,
          margin: const EdgeInsets.only(right: 8),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: primaryBrown.withOpacity(0.7),
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                DateTime? lastDate;
                DateTime firstDate;

                switch (label) {
                  case 'DATE OF BIRTH':
                    lastDate =
                        DateTime.now().subtract(const Duration(days: 6570));
                    firstDate = DateTime(1950);
                    break;
                  case 'LICENSE EXPIRY':
                    firstDate = DateTime.now();
                    lastDate = DateTime.now().add(const Duration(days: 3650));
                    break;
                  default:
                    firstDate =
                        DateTime.now().subtract(const Duration(days: 30));
                    lastDate = DateTime.now().add(const Duration(days: 30));
                }

                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: label == 'DATE OF BIRTH'
                      ? lastDate ?? DateTime.now()
                      : selectedDate,
                  firstDate: firstDate,
                  lastDate: lastDate ?? DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: primaryBrown,
                          onPrimary: Colors.white,
                          surface: secondaryBlue,
                          onSurface: Colors.white,
                        ),
                        dialogBackgroundColor: secondaryBlue,
                      ),
                      child: child!,
                    );
                  },
                );
                if (pickedDate != null) {
                  onDateSelected(pickedDate);
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 20,
                      color: primaryBrown.withOpacity(0.7),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatDate(selectedDate),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: primaryBrown.withOpacity(0.7),
            fontSize: 12,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(
              '---',
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14,
              ),
            ),
            icon: Icon(Icons.arrow_drop_down,
                color: Colors.white.withOpacity(0.5)),
            dropdownColor: secondaryBlue,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.work_outline,
                size: 20,
                color: primaryBrown.withOpacity(0.7),
              ),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: (value) =>
                value == null ? 'Please select employment type' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: primaryBrown.withOpacity(0.7),
          fontSize: 12,
          letterSpacing: 1,
        ),
        prefixIcon: Icon(icon, color: primaryBrown.withOpacity(0.7), size: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryBrown),
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      ),
      validator: validator,
    );
  }

  BoxDecoration _getContainerDecoration() {
    return BoxDecoration(
      color: Colors.white.withOpacity(0.05),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: primaryBrown.withOpacity(0.2),
      ),
      boxShadow: [
        BoxShadow(
          color: primaryBrown.withOpacity(0.1),
          blurRadius: 8,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildProfilePhotoContainer() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
        border: Border.all(color: primaryBrown.withOpacity(0.5)),
        image: _profilePhoto != null
            ? DecorationImage(
                image: FileImage(_profilePhoto!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: _profilePhoto == null
          ? Icon(Icons.add_a_photo,
              color: primaryBrown.withOpacity(0.7), size: 32)
          : null,
    );
  }

  Gradient _getDividerGradient() {
    return LinearGradient(
      colors: [
        Colors.transparent,
        primaryBrown.withOpacity(0.3),
        Colors.transparent,
      ],
    );
  }
}
