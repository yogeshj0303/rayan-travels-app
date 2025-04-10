import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String? _selectedBus;
  String? _selectedDriverId;
  String? _selectedExpenseType;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _receipt;

  // Dummy data for dropdowns
  final List<String> _busNumbers = ['KA01AA1234', 'KA01BB5678', 'KA01CC9012'];
  final List<String> _driverIds = ['DRV001', 'DRV002', 'DRV003'];
  final List<String> _expenseTypes = [
    'Diesel',
    'Bus Repair',
    'Tyre Change',
    'Engine Maintenance',
    'Driver Allowance',
    'Toll/Parking',
    'Insurance',
    'Other'
  ];

  Future<void> _pickImage() async {
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title:
            Text('Select Source', style: TextStyle(color: Color(0xFF0B192E))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: Color(0xFFD88226)),
              title: Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Color(0xFFD88226)),
              title: Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source != null) {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _receipt = File(image.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final secondaryGold = Color(0xFFD88226);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B192E),
        elevation: 0,
        title: Text(
          'Add Expense',
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
              'SAVE',
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
            _buildDate(),
            const SizedBox(height: 16),
            _buildDropdown(
              'Bus Number',
              _selectedBus,
              _busNumbers,
              (value) => setState(() => _selectedBus = value),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Driver ID',
              _selectedDriverId,
              _driverIds,
              (value) => setState(() => _selectedDriverId = value),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Expense Type',
              _selectedExpenseType,
              _expenseTypes,
              (value) => setState(() => _selectedExpenseType = value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Amount',
              _amountController,
              TextInputType.number,
              prefix: '₹',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Description',
              _descriptionController,
              TextInputType.multiline,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildImagePicker(),
          ],
        ),
      ),
    );
  }

  Widget _buildDate() {
    return InkWell(
      onTap: () async {
        final DateTime? date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          setState(() => _selectedDate = date);
        }
      },
      child: InputDecorator(
        decoration: _getInputDecoration('Date'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
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
    String? prefix,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: _getInputDecoration(label, prefix: prefix),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: _receipt != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(_receipt!, fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => setState(() => _receipt = null),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload_outlined,
                      size: 40, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text('Upload Receipt',
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
      ),
    );
  }

  InputDecoration _getInputDecoration(String label, {String? prefix}) {
    return InputDecoration(
      labelText: label,
      prefixText: prefix,
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
}
