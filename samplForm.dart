import 'package:flutter/material.dart';
import 'custom_widgets.dart';



class SamplingDriveFormPage extends StatefulWidget {
  @override
  _SamplingDriveFormPageState createState() => _SamplingDriveFormPageState();
}

class _SamplingDriveFormPageState extends State<SamplingDriveFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final retailerController = TextEditingController();
  final retailerCodeController = TextEditingController();
  final distributorController = TextEditingController();
  final areaController = TextEditingController();
  final dateController = TextEditingController();
  final painterController = TextEditingController();
  final phoneController = TextEditingController();
  final skuController = TextEditingController();
  final qtyController = TextEditingController();
  final missedQtyController = TextEditingController();
  final photoPathController = TextEditingController();
  final reimbursementModeController = TextEditingController();
  final reimbursementAmtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WallCare Putty Sampling Drive by Employee')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Sample Material Distribution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              const SizedBox(height: 12),
              buildModernTextField(label: 'Retailer', controller: retailerController, icon: Icons.store),
              const SizedBox(height: 8),
              buildModernTextField(label: 'Retailer Code', controller: retailerCodeController, icon: Icons.code),
              const SizedBox(height: 8),
              buildModernTextField(label: 'Concern Distributor', controller: distributorController, icon: Icons.business),
              const SizedBox(height: 8),
              buildModernTextField(label: 'Area', controller: areaController, icon: Icons.location_city),
              const SizedBox(height: 8),
              buildModernDateField(label: 'Date of Distribution', controller: dateController, icon: Icons.calendar_today, context: context),
              const SizedBox(height: 16),
              Text('Execution Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              const SizedBox(height: 12),
              buildModernTextField(label: 'Painter/Contractor Name', controller: painterController, icon: Icons.person),
              const SizedBox(height: 8),
              buildModernTextField(label: 'Contact Number', controller: phoneController, icon: Icons.phone, isPhone: true),
              const SizedBox(height: 8),
              buildModernTextField(label: 'SKU / Size (kg)', controller: skuController, icon: Icons.list),
              const SizedBox(height: 8),
              buildModernTextField(label: 'Material Qty Distributed (Kg)', controller: qtyController, icon: Icons.numbers),
              const SizedBox(height: 8),
              buildModernTextField(label: 'Missed Quantity (if any)', controller: missedQtyController, icon: Icons.error_outline, isRequired: false),
              const SizedBox(height: 16),
              Text('Sample Proof', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              const SizedBox(height: 8),
              buildModernImageUpload(
                  label: 'Sample Photograph', icon: Icons.camera_alt, onImageSelected: (String? path) {
                photoPathController.text = path ?? '';
              }, context: context),
              const SizedBox(height: 16),
              Text('Reimbursement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              const SizedBox(height: 12),
              buildModernDropdown(
                  label: 'Reimbursement Mode',
                  icon: Icons.monetization_on,
                  items: ['By Hired Painter: 250 AED', 'By Site Painter: 150 AED'],
                  onChanged: (String? value) {
                    reimbursementModeController.text = value ?? '';
                  }),
              const SizedBox(height: 8),
              buildModernTextField(label: 'Amount Reimbursed', controller: reimbursementAmtController, icon: Icons.attach_money),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: Icon(Icons.save),
                label: Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Submit logic here
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sampling Entry Saved!')));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
