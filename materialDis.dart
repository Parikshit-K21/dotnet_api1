import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_widgets.dart';

class SampleDistributEntry extends StatefulWidget {
  @override
  _SampleDistributEntryState createState() => _SampleDistributEntryState();
}

class _SampleDistributEntryState extends State<SampleDistributEntry> {
  final emiratesController = TextEditingController();
  final areaController = TextEditingController();
  final retailerNameController = TextEditingController();
  final retailerCodeController = TextEditingController();
  final distributorController = TextEditingController();
  final painterNameController = TextEditingController();
  final painterMobileController = TextEditingController();
  final skuSizeController = TextEditingController();
  final materialQtyController = TextEditingController();
  final distributionDateController = TextEditingController();

  void _submitForm() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('emirates', emiratesController.text);
    await prefs.setString('area', areaController.text);
    await prefs.setString('retailerName', retailerNameController.text);
    await prefs.setString('retailerCode', retailerCodeController.text);
    await prefs.setString('distributor', distributorController.text);
    await prefs.setString('painterName', painterNameController.text);
    await prefs.setString('painterMobile', painterMobileController.text);
    await prefs.setString('skuSize', skuSizeController.text);
    await prefs.setString('materialQty', materialQtyController.text);
    await prefs.setString('distributionDate', distributionDateController.text);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sample distribution data saved successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Retailer Onboarding Form')),
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
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildModernTextField(label: 'Emirates ID', controller: emiratesController,icon: Icons.person_2),
            const SizedBox(height: 8),
            buildDropdownField(label: 'Area', controller: areaController),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Retailer Name', controller: retailerNameController, icon: Icons.store),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Retailer Code', controller: retailerCodeController, icon: Icons.code),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Concern Distributor', controller: distributorController, icon: Icons.business),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Name of Painter / Contractor', controller: painterNameController, icon: Icons.person),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Mobile no Painter / Contractor', controller: painterMobileController, icon: Icons.phone),
            const SizedBox(height: 8),
            buildDropdownField(label: 'SKU Size (1/5 Kg)', controller: skuSizeController, items: ['1 Kg', '5 Kg']),
            const SizedBox(height: 8),
            buildModernTextField(label: 'Material distributed in Kg.', controller: materialQtyController, icon: Icons.scale),
            const SizedBox(height: 8),
            buildModernDateField(label: 'Date of distribution', controller: distributionDateController, icon: Icons.event, context: context),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _submitForm, child: Text('Submit')),
          ],
        ),
      ),
  ),
     ),
    );
  }
}
