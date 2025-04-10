import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddDieselScreen extends StatefulWidget {
  const AddDieselScreen({super.key});

  @override
  State<AddDieselScreen> createState() => _AddDieselScreenState();
}

class _AddDieselScreenState extends State<AddDieselScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  String? _selectedBusNumber;
  String? _selectedDriverId;
  final TextEditingController _litresController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _stationController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  File? _receipt;

  // Sample data - Replace with actual data from backend
  final List<String> _busNumbers = ['BUS001', 'BUS002', 'BUS003'];
  final List<String> _driverIds = ['DRV001', 'DRV002', 'DRV003'];

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() => _receipt = File(image.path));
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
              'Upload Receipt',
              style: TextStyle(
                fontSize: 18,
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
                    _pickImage(ImageSource.camera);
                  },
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library,
                  title: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
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

  @override
  Widget build(BuildContext context) {
    final secondaryGold = Color(0xFFD88226);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Color(0xFF0B192E),
        elevation: 0,
        title: Text(
          'Add Diesel Entry',
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
              _selectedBusNumber,
              _busNumbers,
              (value) => setState(() => _selectedBusNumber = value),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Driver ID',
              _selectedDriverId,
              _driverIds,
              (value) => setState(() => _selectedDriverId = value),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Litres Filled',
              _litresController,
              TextInputType.number,
              onChanged: _updateTotal,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Rate per Litre',
              _rateController,
              TextInputType.number,
              prefix: '₹',
              onChanged: _updateTotal,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Total Amount',
              TextEditingController(text: _calculateTotal()),
              TextInputType.number,
              prefix: '₹',
              readOnly: true,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Fuel Station',
              _stationController,
              TextInputType.text,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Remarks',
              _remarksController,
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
    bool readOnly = false,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      readOnly: readOnly,
      onChanged: onChanged,
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
      onTap: _showImageSourceOptions,
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

  void _updateTotal(String _) {
    setState(() {});
  }

  String _calculateTotal() {
    final litres = double.tryParse(_litresController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    return (litres * rate).toStringAsFixed(2);
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Process form data
      Navigator.pop(context);
    }
  }
}
