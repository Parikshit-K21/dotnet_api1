import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '/custom_widgets.dart';
import 'ApiCon.dart';

class RetailerOnboardingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retailer Onboarding',
      home: RetailerFormPage(),
    );
  }
}

class RetailerFormPage extends StatefulWidget {
  @override
  _RetailerFormPageState createState() => _RetailerFormPageState();
}

class _RetailerFormPageState extends State<RetailerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final bool _isVATRequired= true;
   RetailerApiService api = RetailerApiService();
  // Individual controllers for each field
  final firmNameController = TextEditingController();
  final taxRegNumberController = TextEditingController();
  final registeredAddressController = TextEditingController();
  final effectiveDateController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final issuingAuthorityController = TextEditingController();
  final establishmentDateController = TextEditingController();
  final expiryDateController = TextEditingController();
  final tradeNameController = TextEditingController();
  final responsiblePersonController = TextEditingController();
  final accountNameController = TextEditingController();
  final ibanController = TextEditingController();
  final bankNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final branchAddressController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

 Future<void> _saveData() async {
  try {

  

    await api.insertRetailer(
      licenseNumber: licenseNumberController.text,
      issuingAuthority: issuingAuthorityController.text,
      establishmentDate: establishmentDateController.text,
      expiryDate: expiryDateController.text,
      tradeName: tradeNameController.text,
      responsiblePerson: responsiblePersonController.text,
      registeredAddress: registeredAddressController.text,
      effectiveRegistrationDate: effectiveDateController.text,
      isVATRequired: _isVATRequired,
      taxRegistrationNumber: taxRegNumberController.text,
      vatFirmName: firmNameController.text,
      vatRegisteredAddress: registeredAddressController.text,
      vatEffectiveDate: effectiveDateController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data sent to server successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error sending data: $e')),
    );
  }
}

 String? _validateTaxRegNumber(String? p1) {
  if (p1 != null && p1.length != 14) return 'Only 15 Nuemrics allowed';
    return null;
  }
  
  String? _validateLicense(String? value) {
    if (value != null && value.length > 20) return 'Max 20 characters allowed';
    return null;
  }

  String? _validateIBAN(String? value) {
    if (value != null && value.isNotEmpty && !RegExp(r'^AE\d{21}$').hasMatch(value)) {
      return 'IBAN must start with AE and be 23 characters';
    }
    return null;
  }

  Widget _buildTextField(String label, TextEditingController controller,IconData icon, {String? Function(String?)? validator }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
     child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          label:  Text(label),
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
    )
    );
  }

  final sectionTitleStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w600,
  color: Colors.blue.shade700,
);


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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Icon(Icons.assignment_rounded, color: Colors.blue, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'Retailer Registration Form',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Trade License Section (Always Visible)
                Text('Trade License (Mandatory)', style: sectionTitleStyle),
                const SizedBox(height: 12),
                _buildTextField('License Number', licenseNumberController, Icons.confirmation_number, validator: _validateLicense),const SizedBox(height: 8),
                buildModernTextField(label: 'Issuing Authority', controller: issuingAuthorityController, icon: Icons.account_balance),const SizedBox(height: 8),
                buildModernDateField(label: 'Establishment Date', controller: establishmentDateController, icon: Icons.event, context: context),const SizedBox(height: 8),
                buildModernDateField(label: 'Expiry Date', controller: expiryDateController, icon: Icons.event_busy, context: context),const SizedBox(height: 8),
                buildModernTextField(label: 'Trade Name', controller: tradeNameController, icon: Icons.store),const SizedBox(height: 8),
                buildModernTextField(label: 'Responsible Person', controller: responsiblePersonController, icon: Icons.person),const SizedBox(height: 8),
                buildModernTextField(label: 'Registered Address', controller: registeredAddressController, icon: Icons.location_on),const SizedBox(height: 8),
                buildModernDateField(label: 'Effective Registration Date', controller: effectiveDateController, icon: Icons.calendar_today, context: context),
                const SizedBox(height: 8),
                Text(
                  'Note: License Numbers vary across Emirates. (Max 20 Characters)',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 24),

                // VAT Registration Section (Conditional)
                if (_isVATRequired)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('VAT Registration (Conditional)', style: sectionTitleStyle),
                      const SizedBox(height: 12),
                      _buildTextField('Tax Registration Number', taxRegNumberController, Icons.numbers, validator: _validateTaxRegNumber),const SizedBox(height: 8),
                      buildModernTextField(label: 'Firm Name', controller: firmNameController, icon: Icons.business),const SizedBox(height: 8),
                      buildModernTextField(label: 'Registered Address', controller: registeredAddressController, icon: Icons.location_on),const SizedBox(height: 8),
                      buildModernDateField(label: 'Effective Registration Date', controller: effectiveDateController, icon: Icons.calendar_today, context: context),
                      const SizedBox(height: 8),
                      Text(
                        'Required only if the firm’s Annual Turnover exceeds AED 3,75,000.',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                // Submit Button
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(Icons.send_rounded),
                  label: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveData();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),   
      );
}
}
