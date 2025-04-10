import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ApplyLeaveScreen extends StatefulWidget {
  const ApplyLeaveScreen({super.key});

  @override
  State<ApplyLeaveScreen> createState() => _ApplyLeaveScreenState();
}

class _ApplyLeaveScreenState extends State<ApplyLeaveScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedDriverId;
  String? _selectedLeaveType;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int _totalDays = 1;
  final TextEditingController _reasonController = TextEditingController();
  String _status = 'Pending'; // Initial status
  File? _document;

  final List<String> _driverIds = ['DRV001', 'DRV002', 'DRV003'];
  final List<String> _leaveTypes = [
    'Sick Leave',
    'Casual Leave',
    'Emergency Leave',
    'Personal Leave',
    'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final secondaryGold = Color(0xFFD88226);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B192E),
        elevation: 0,
        title: Text(
          'Apply Leave',
          style: TextStyle(
            color: secondaryGold,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: secondaryGold),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text(
              'SUBMIT',
              style: TextStyle(
                color: secondaryGold,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildDropdown(
              'Driver ID',
              _selectedDriverId,
              _driverIds,
              (value) => setState(() => _selectedDriverId = value),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Leave Type',
              _selectedLeaveType,
              _leaveTypes,
              (value) => setState(() => _selectedLeaveType = value),
            ),
            const SizedBox(height: 16),
            _buildDatePicker('From Date', _startDate, (date) {
              if (date != null) {
                setState(() {
                  _startDate = date;
                  _calculateTotalDays();
                });
              }
            }),
            const SizedBox(height: 16),
            _buildDatePicker('To Date', _endDate, (date) {
              if (date != null) {
                setState(() {
                  _endDate = date;
                  _calculateTotalDays();
                });
              }
            }),
            const SizedBox(height: 16),
            _buildTotalDays(),
            const SizedBox(height: 16),
            _buildTextField(
              'Reason',
              _reasonController,
              TextInputType.multiline,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildStatus(),
            const SizedBox(height: 16),
            _buildDocumentUpload(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalDays() {
    return InputDecorator(
      decoration: _getInputDecoration('Total Days'),
      child: Text(
        '$_totalDays days',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildStatus() {
    return InputDecorator(
      decoration: _getInputDecoration('Status'),
      child: Text(
        _status,
        style: TextStyle(
          fontSize: 16,
          color: _getStatusColor(_status),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      default:
        return Colors.orange;
    }
  }

  Widget _buildDocumentUpload() {
    return GestureDetector(
      onTap: _showImageSourceOptions, // Changed this line
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: _document != null
            ? Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_present, color: Color(0xFFD88226)),
                        Text('Document uploaded'),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _document = null),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file,
                      size: 32, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text('Upload Supporting Document',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
      ),
    );
  }

  void _calculateTotalDays() {
    _totalDays = _endDate.difference(_startDate).inDays + 1;
    if (_totalDays < 1) {
      _totalDays = 1;
    }
  }

  Future<void> _pickDocument(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _document = File(image.path);
      });
    }
  }

  Widget _buildDatePicker(
      String label, DateTime selectedDate, Function(DateTime?) onDateSelected) {
    return InkWell(
      onTap: () async {
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        onDateSelected(date);
      },
      child: InputDecorator(
        decoration: _getInputDecoration(label),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              style: const TextStyle(fontSize: 16),
            ),
            Icon(Icons.calendar_today, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _getInputDecoration(label),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select $label' : null,
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType keyboardType, {
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _getInputDecoration(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  InputDecoration _getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.amber.shade300),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Process form data
      Navigator.pop(context);
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Upload Document',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0B192E),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageSourceOption(
                  icon: Icons.camera_alt,
                  title: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _pickDocument(ImageSource.camera);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  title: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickDocument(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFFD88226).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 32,
              color: Color(0xFFD88226),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF0B192E),
            ),
          ),
        ],
      ),
    );
  }
}
