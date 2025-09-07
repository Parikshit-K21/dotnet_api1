import 'dart:io' as io; // For mobile file handling
// For web file handling

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:rak_web/screens/home_screen.dart';

class RetailerRegistrationApp extends StatelessWidget {
  const RetailerRegistrationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RetailerRegistrationPage(),
    );
  }
}

class RetailerRegistrationPage extends StatefulWidget {
  const RetailerRegistrationPage({super.key});

  @override
  State<RetailerRegistrationPage> createState() =>
      _RetailerRegistrationPageState();
}

class _RetailerRegistrationPageState extends State<RetailerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
//  late final RetailerService _retailerService;
  String? _areasCode;
  List<String>? _areas;
  List<String>? _states;

  String? _uploadedFileName;
  Uint8List? _fileBytes; // For web
  String? _filePath; // For mobile

  TextEditingController ProcesTp = TextEditingController();
  TextEditingController retailCat = TextEditingController();
  TextEditingController Area = TextEditingController();
  TextEditingController District = TextEditingController();
  TextEditingController GST = TextEditingController();
  TextEditingController PAN = TextEditingController();
  TextEditingController Mobile = TextEditingController();
  TextEditingController Address = TextEditingController();
  TextEditingController Scheme = TextEditingController();



  // Future<void> _loadStates() async {
  //   try {
  //     final data = await api.getStates();
  //     setState(() {
  //       _states = data;
  //     });
  //   } catch (e) {
  //     print('Error loading data: $e');
  //   }
  // }

  Future<String> retailCodes(String cat) async {
    final categoryMap = {'Urban': 'URB', 'Rural': 'RUR', 'Direct': 'DDR'};
    return categoryMap[cat] ?? '';
  }

  @override
  void initState() {
    super.initState();
    // _retailerService = RetailerService(api: ApiService());
    // _loadStates();
  }

  // Future<void> _loadArea(String state) async {
  //   try {
  //     final areas = await _retailerService.getAreas(state);
  //     setState(() {
  //       _areas = areas;
  //     });
  //   } catch (e) {
  //     _showError('Error loading areas: $e');
  //   }
  // }

  // Future<void> areaCodes(String district) async {
  //   try {
  //     final code = await _retailerService.getAreaCode(district);
  //     setState(() {
  //       _areasCode = code;
  //     });
  //     print(_areasCode);
  //   } catch (e) {
  //     _showError('Error getting area code: $e');
  //   }
  // }

  // Add this helper method for showing errors
  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // Modify your submit button's onPressed handler
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      _showError('Please fill all required fields');
      return;
    }

    try {
      // Get area code first
      final areaCode = await District.text;
      print('Retrieved area code: $areaCode'); // Debug log

      if (areaCode!.isEmpty) {
        throw Exception('Invalid area code received');
      }

      // Get retail code
      final retailCode = await retailCodes(retailCat.text);
      print('Retrieved retail code: $retailCode'); // Debug log

      if (retailCode.isEmpty) {
        throw Exception('Invalid retail code received');
      }

      // Generate document number
      final year = (DateTime.now().year % 100).toString();
      // final doc = await _retailerService.generateDocumentNumber(
      //   year,
      //   areaCode,
      //   retailCode,
      // );

      // print('Generated document number: $doc'); // Debug log

      // // Submit data
      // await _retailerService.submitRetailerData(
      //   doc: doc,
      //   processType: ProcesTp.text,
      //   gst: GST.text,
      //   time: DateTime.now(),
      //   mobile: Mobile.text,
      //   area: Area.text,
      //   district: District.text,
      //   retailCategory: retailCat.text,
      //   address: Address.text,
      // );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      _showError(e.toString());
    }
  }

  // Update your submit button in the build method
  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          backgroundColor: const Color.fromRGBO(0, 112, 183, 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true, // Required for web
      withReadStream: false, // Optional for large files
    );

    if (result != null) {
      setState(() {
        _uploadedFileName = result.files.single.name;
        if (kIsWeb) {
          // For web, use bytes
          _fileBytes = result.files.single.bytes;
        } else {
          // For mobile, use file path
          _filePath = result.files.single.path;
        }
      });
    }
  }

  void _viewFile() {
    if (kIsWeb) {
      // Web: Display file from bytes
      if (_fileBytes != null) {
        showDialog(
          context: context,
          builder:
              (context) => Dialog(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: 300,
                  height: 400,
                  child:
                      _uploadedFileName!.endsWith('.jpg') ||
                              _uploadedFileName!.endsWith('.png') ||
                              _uploadedFileName!.endsWith('.jpeg')
                          ? Image.memory(_fileBytes!, fit: BoxFit.fill)
                          : Center(
                            child: const Text(
                              'Cannot preview this file type.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                ),
              ),
        );
      }
    } else {
      // Mobile: Display file from path
      if (_filePath != null) {
        showDialog(
          context: context,
          builder:
              (context) => Dialog(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  width: 300,
                  height: 500,
                  child:
                      _filePath!.endsWith('.jpg') ||
                              _filePath!.endsWith('.png') ||
                              _filePath!.endsWith('.jpeg')
                          ? Image.file(io.File(_filePath!), fit: BoxFit.fill)
                          : Center(
                            child: const Text(
                              'Cannot preview this file type.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                ),
              ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = MediaQuery.of(context).size.width > 1080;

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(
                        0,
                        112,
                        183,
                        1,
                      ), // Background color
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          width: 8,
                        ), // Spacing between icon and text
                        const Text(
                          'Retailer Registration',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text color
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  isWideScreen
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildBasicDetailsForm()),
                          const SizedBox(width: 8.0),
                          Expanded(child: _buildContactDetailsForm()),
                        ],
                      )
                      : Column(
                        children: [
                          _buildBasicDetailsForm(),
                          const SizedBox(height: 16.0),
                          _buildContactDetailsForm(),
                        ],
                      ),
                  const SizedBox(height: 16.0),
                  _buildSubmitButton(), // Use the new submit button
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicDetailsForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Basic Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 112, 183, 1),
            ),
          ),
          const SizedBox(height: 8.0),
          _buildDropdownField('Process Type*', ['Add', 'Update'], ProcesTp),
          _buildDropdownField('Retailer Category*', [
            'Urban',
            'Rural',
            'Direct Dealer',
          ], retailCat),
          _buildDropdownField(
            'Area*',
            _states ?? [],
            Area,
            onChanged: (value) {
              setState(() {
                Area.text = value!;
                District.text = ''; // Reset district when area changes
                //_loadArea(value); // Load districts for selected area
              });
            },
          ),
          _buildDropdownField('District*', _areas ?? [], District),
          _buildClickableOptions('Register With PAN/GST*', ['GST', 'PAN']),
          const SizedBox(height: 5.0),
          _buildTextFieldTick('GST Number*', GST),
          _buildTextFieldTick('PAN Number*', PAN),
          _buildTextField('Firm Name', TextEditingController()),
          _buildTextField(
            'Mobile*',
            Mobile,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(
                10,
              ), // Optional: limit to 10 digits
            ],
          ),
          _buildTextField('Office Telephone', TextEditingController()),
          _buildTextField('Email', TextEditingController()),
          _buildTextField('Address 1*', Address),
          _buildTextField('Address 2', TextEditingController()),
          _buildTextField('Address 3', TextEditingController()),
        ],
      ),
    );
  }

  Widget _buildContactDetailsForm() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(0, 112, 183, 1),
            ),
          ),
          const SizedBox(height: 8.0),
          _buildPredefinedField('Stockist Code', '4401S711'),
          _buildTextField('Tally Retailer Code', TextEditingController()),
          _buildTextField('Concern Employee', TextEditingController()),
          _buildUploadField('Retailer Profile Image'),
          _buildUploadField('PAN / GST No Image Upload / View'),
          _buildDropdownField('Scheme Required', ['Yes', 'No'], Scheme),
          _buildTextField('Aadhar Card No', TextEditingController()),
          _buildUploadField('Aadhar Card Upload'),
          _buildTextField('Proprietor / Partner Name', TextEditingController()),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: controller,
            style: const TextStyle(fontSize: 14),
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (label.endsWith('*') && (value == null || value.isEmpty)) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildDropdownField(
    String label,
    List<String> items,
    TextEditingController controller, {
    ValueChanged<String?>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: DropdownButtonFormField<String>(
            value:
                controller.text.isNotEmpty && items.contains(controller.text)
                    ? controller.text
                    : null,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            dropdownColor: Colors.white,
            items:
                items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
            onChanged: (value) {
              setState(() {
                controller.text = value!;
              });
              if (onChanged != null) {
                onChanged(value);
              }
            },
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (selectedValue) {
              if (label.endsWith('*') && selectedValue == null) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  String? selectedOption; // To track the selected option

  Widget _buildClickableOptions(String label, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Row(
          children:
              options.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedOption = option;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              selectedOption == option
                                  ? Colors.blue
                                  : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color:
                            selectedOption == option
                                ? Colors.blue
                                : Colors.transparent,
                      ),
                      child: Text(
                        option,
                        style: TextStyle(
                          color:
                              selectedOption == option
                                  ? Colors.black
                                  : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextFieldTick(String label, TextEditingController controller) {
    bool isEnabled = false;

    if (label.contains('GST')) {
      isEnabled = selectedOption == 'GST';
    } else if (label.contains('PAN')) {
      isEnabled = selectedOption == 'PAN';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: TextFormField(
            controller: controller,
            enabled: isEnabled,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              filled: !isEnabled,
              fillColor: !isEnabled ? Colors.grey[200] : Colors.transparent,
            ),
            validator: (value) {
              if (label.endsWith('*') && (value == null || value.isEmpty)) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildUploadField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 40,
              width: 120, // Increased width for better spacing
              child: ElevatedButton.icon(
                onPressed: _pickFile,
                icon: const Icon(
                  Icons.file_upload,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  'Upload',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 112, 183, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      4.0,
                    ), // Rectangular shape
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 40,
              width: 120,
              child: ElevatedButton.icon(
                onPressed: _uploadedFileName != null ? _viewFile : null,
                icon: const Icon(
                  Icons.remove_red_eye_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                label: const Text(
                  'View',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
        if (_uploadedFileName != null)
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              'Uploaded File: ${_uploadedFileName!.split('/').last}',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  Widget _buildPredefinedField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
          child: TextFormField(
            initialValue: value,
            enabled: false,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
