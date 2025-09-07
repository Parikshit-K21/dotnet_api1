import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/custom_widgets.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NewProductEntry extends StatefulWidget {
  @override
  _NewProductEntryState createState() => _NewProductEntryState();
}

class _NewProductEntryState extends State<NewProductEntry> {
  // Controllers
  final areaController = TextEditingController();
  final cityDistrictController = TextEditingController();
  final pinCodeController = TextEditingController();
  final customerNameController = TextEditingController();
  final contractorNameController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final siteTypeController = TextEditingController();
  final sampleReceiverController = TextEditingController();
  final targetDateController = TextEditingController();
  final remarksController = TextEditingController();
  final regionController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  File? _selectedImage;
  final samplingDateController = TextEditingController();
  final productController = TextEditingController();
  final expectedOrderController = TextEditingController();
  final sampleTypeController = TextEditingController();

void _submitForm() async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('area', areaController.text);
  await prefs.setString('cityDistrict', cityDistrictController.text);
  await prefs.setString('pinCode', pinCodeController.text);
  await prefs.setString('customerName', customerNameController.text);
  await prefs.setString('contractorName', contractorNameController.text);
  await prefs.setString('mobile', mobileController.text);
  await prefs.setString('address', addressController.text);
  await prefs.setString('siteType', siteTypeController.text);
  await prefs.setString('sampleReceiver', sampleReceiverController.text);
  await prefs.setString('targetDate', targetDateController.text);
  await prefs.setString('remarks', remarksController.text);
  await prefs.setString('region', regionController.text);
  await prefs.setString('latitude', latitudeController.text);
  await prefs.setString('longitude', longitudeController.text);
  await prefs.setString('samplingDate', samplingDateController.text);
  await prefs.setString('product', productController.text);
  await prefs.setString('expectedOrder', expectedOrderController.text);
  await prefs.setString('sampleType', sampleTypeController.text);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Form data saved successfully!')),
  );
}

 

  void _uploadSamplePhoto() async {
    // Upload photo logic
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = File(image.path);
    }
  }

  void _viewPhoto(BuildContext context) {
    if (_selectedImage != null) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Image.file(_selectedImage!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected.')),
      );
    }
  }
  final ImagePicker _picker = ImagePicker();
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('sample drive entry by image')),
     body: Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.blue.shade50,
        Colors.white,
        Colors.grey.shade50,
      ],
    ),
  ),
  child: SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.shade100.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Site Details', style: sectionTitleStyle),
            const SizedBox(height: 12),

            buildDropdownField(label: 'Area*', controller: areaController),
            const SizedBox(height: 8),
            buildDropdownField(label: 'City and District*', controller: cityDistrictController),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Pin Code*', controller: pinCodeController, icon: Icons.pin),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Customer Name*', controller: customerNameController, icon: Icons.person),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Contractor/Purchase Name*', controller: contractorNameController, icon: Icons.business),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Mobile*', controller: mobileController, icon: Icons.phone),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Address*', controller: addressController,icon: Icons.location_city),
            const SizedBox(height: 8),
            buildDropdownField(label: 'Site Type*', controller: siteTypeController),
            const SizedBox(height: 8),
            buildDropdownField(label: 'Sample Local Received Person*', controller: sampleReceiverController),
            const SizedBox(height: 8),
            buildModernDateField(label: 'Target Date of Conversion*', controller: targetDateController, icon: Icons.date_range, context: context),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Remarks*', controller: remarksController, icon: Icons.location_city),
            const SizedBox(height: 8),
            buildDropdownField(label: 'Region of Construction*', controller: regionController),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: buildModernTextField(label: 'Latitude', controller: latitudeController, icon: Icons.location_on)),
                const SizedBox(width: 8),
                Expanded(child: buildModernTextField(label: 'Longitude', controller: longitudeController, icon: Icons.location_on)),
              ],
            ),
            const SizedBox(height: 8),
           

            const SizedBox(height: 24),
            Text('Sampling Details', style: sectionTitleStyle),
            const SizedBox(height: 12),

            buildModernDateField(label: 'Sampling Date', controller: samplingDateController, icon: Icons.event, context: context),
            const SizedBox(height: 8),
            buildDropdownField(label: 'Product', controller: productController),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Site Material Expected Order (kg)', controller: expectedOrderController, icon: Icons.scale),
            const SizedBox(height: 8),
            buildDropdownField(label: 'Sample Type', controller: sampleTypeController),
            const SizedBox(height: 8),

            Row(
              children: [
                ElevatedButton(onPressed: _uploadSamplePhoto, child: Text('Upload Sample Photo')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () => _viewPhoto(context), child: Text('View Photo')),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
          ],
        ),
      ),
      ),
      ),
    );
  }

  TextStyle get sectionTitleStyle => TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
}
