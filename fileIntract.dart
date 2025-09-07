
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io' as io;


Future<Uint8List?> pickImageFromGallery() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if (image != null) {
    return await image.readAsBytes();
  }
  return null;
}
Future<Uint8List?> captureImageFromCamera() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.camera);
  if (image != null) {
    return await image.readAsBytes();
  }
  return null;
}


Future<void> uploadImageToDotNetApi(Uint8List imageBytes) async {
  final uri = Uri.parse("https://your-dotnet-api.com/upload");

  final request = http.MultipartRequest('POST', uri)
    ..files.add(http.MultipartFile.fromBytes(
      'file',
      imageBytes,
      filename: 'upload.jpg',
      contentType: MediaType('image', 'jpeg'),
    ));

  final response = await request.send();

  if (response.statusCode == 200) {
    print("Image uploaded successfully");
  } else {
    print("Upload failed with status: ${response.statusCode}");
  }
}


class PickedFileData {
  final String fileName;
  final Uint8List? fileBytes; // Web
  final String? filePath;     // Mobile

  PickedFileData({required this.fileName, this.fileBytes, this.filePath});
}

Future<PickedFileData?> pickFile() async {
  try {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      withData: true,
      withReadStream: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.single;
      return PickedFileData(
        fileName: file.name,
        fileBytes: kIsWeb ? file.bytes : null,
        filePath: !kIsWeb ? file.path : null,
      );
    }
  } catch (e) {
    debugPrint("Error picking file: $e");
  }
  return null;
}


void viewFile(BuildContext context, PickedFileData fileData) {
  final isImage = fileData.fileName.toLowerCase().endsWith('.jpg') ||
      fileData.fileName.toLowerCase().endsWith('.jpeg') ||
      fileData.fileName.toLowerCase().endsWith('.png');

  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 300,
        height: 400,
        child: isImage
            ? kIsWeb
                ? Image.memory(fileData.fileBytes!, fit: BoxFit.fill)
                : Image.file(io.File(fileData.filePath!), fit: BoxFit.fill)
            : const Center(
                child: Text(
                  'Cannot preview this file type.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
      ),
    ),
  );
}


 
//Usage
// ElevatedButton(
//   onPressed: () async {
//     final fileData = await pickFile();
//     if (fileData != null) {
//       viewFile(context, fileData);
//       final success = await uploadFileToDotNetApi(fileData);
//       if (success) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("File uploaded successfully")),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Upload failed")),
//         );
//       }
//     }
//   },
//   child: const Text("Pick and Upload File"),
// )
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

// Future<bool> uploadFileToDotNetApi(PickedFileData fileData) async {
//   try {
//     final uri = Uri.parse("https://your-dotnet-api.com/upload");

//     http.MultipartFile multipartFile;

//     if (kIsWeb && fileData.fileBytes != null) {
//       multipartFile = http.MultipartFile.fromBytes(
//         'file',
//         fileData.fileBytes!,
//         filename: fileData.fileName,
//         contentType: MediaType('application', 'octet-stream'),
//       );
//     } else if (fileData.filePath != null) {
//       multipartFile = await http.MultipartFile.fromPath(
//         'file',
//         fileData.filePath!,
//         filename: fileData.fileName,
//         contentType: MediaType('application', 'octet-stream'),
//       );
//     } else {
//       throw Exception("No valid file data to upload.");
//     }

//     final request = http.MultipartRequest('POST', uri)..files.add(multipartFile);
//     final response = await request.send();

//     return response.statusCode == 200;
//   } catch (e) {
//     debugPrint("Error uploading file: $e");
//     return false;
//   }
// }

