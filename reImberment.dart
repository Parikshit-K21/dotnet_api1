import 'package:flutter/material.dart';

import 'custom_widgets.dart';




class IncentiveSchemeFormPage extends StatefulWidget {
  @override
  _IncentiveSchemeFormPageState createState() => _IncentiveSchemeFormPageState();
}

class _IncentiveSchemeFormPageState extends State<IncentiveSchemeFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Section selection
  String selectedRole = 'Retailer'; // Default
  final List<String> roleOptions = [
    'Retailer', 'Purchase Manager', 'Salesman', 'Contractor/Painter'
  ];

  // Field controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final channelPartnerController = TextEditingController();
  final invoiceController = TextEditingController();
  final qtyController = TextEditingController();
  final monthController = TextEditingController();
  final remarksController = TextEditingController();

  // Edge case logic
  String? validateQty(String? value) {
    if (value == null || value.isEmpty) return 'Enter bag quantity';
    final int? qty = int.tryParse(value);
    if (qty == null || qty < 1) return 'Enter a valid positive number';
    if (qty > 1000) return 'Exceeded max monthly limit (1000 bags)';
    return null;
  }

  String benefitPerBag(String role) {
    switch (role) {
      case 'Retailer': return '1 AED/bag';
      case 'Purchase Manager': return '0.5 AED/bag';
      case 'Salesman': return '1 AED/bag';
      case 'Contractor/Painter': return '1 AED/bag';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Incentive Scheme & Reimbursement')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Beneficiary Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
              const SizedBox(height: 12),
              buildModernDropdown(
                label: 'Select Role',
                icon: Icons.group,
                items: roleOptions,
                onChanged: (value) => setState(() => selectedRole = value ?? 'Retailer'),
              ),
              const SizedBox(height: 16),
              if (selectedRole.isNotEmpty) ...[
                Text('Exchange Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                const SizedBox(height: 12),
                buildModernTextField(label: '$selectedRole Name', controller: nameController, icon: Icons.person),
                const SizedBox(height: 8),
                buildModernTextField(label: 'Contact Number', controller: phoneController, isPhone: true, icon: Icons.phone),
                const SizedBox(height: 8),
                buildModernTextField(label: 'Channel Partner Name', controller: channelPartnerController, icon: Icons.business),
                const SizedBox(height: 8),
                buildModernTextField(label: 'Invoice / Supporting Doc No.', controller: invoiceController, icon: Icons.receipt_long),
                const SizedBox(height: 8),
                buildModernTextField(label: 'Month', controller: monthController, icon: Icons.calendar_today),
                const SizedBox(height: 8),
                buildModernTextField(
                  label: 'Material Quantity (Bags)',
                  controller: qtyController,
                  icon: Icons.numbers,
                  isRequired: true,
                ),
                const SizedBox(height: 8),
                buildModernTextField(label: 'Remarks', controller: remarksController, icon: Icons.notes, isRequired: false),
                const SizedBox(height: 16),
                // Display dynamic benefit per bag info
                Text(
                  'Scheme Benefit: ${benefitPerBag(selectedRole)}',
                  style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
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
                      final qty = int.tryParse(qtyController.text) ?? 0;
                      // Edge case: Large quantity alert
                      if (qty > 500) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('High Entry Alert'),
                            content: Text('You entered a high monthly bag count ($qty). Please verify!'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text('OK'),
                              )
                            ],
                          ),
                        );
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sales Entry Saved!')),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
