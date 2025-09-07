import 'dart:convert';
import 'package:dio/dio.dart';
import 'dio_client.dart';

class RetailerApiService {
  static const String baseUrl = "http://localhost:5202/api"; // Adjust if needed

  final dioClient = DioClient();

  Future<void> insertRetailer({
    required String licenseNumber,
    required String issuingAuthority,
    required String establishmentDate,
    required String expiryDate,
    required String tradeName,
    required String responsiblePerson,
    required String registeredAddress,
    required String effectiveRegistrationDate,
    required bool isVATRequired,
    String? taxRegistrationNumber,
    String? vatFirmName,
    String? vatRegisteredAddress,
    String? vatEffectiveDate,
  }) async {
    final body = {
      "LicenseNumber": licenseNumber,
      "IssuingAuthority": issuingAuthority,
      "EstablishmentDate": establishmentDate,
      "ExpiryDate": expiryDate,
      "TradeName": tradeName,
      "ResponsiblePerson": responsiblePerson,
      "RegisteredAddress": registeredAddress,
      "EffectiveRegistrationDate": effectiveRegistrationDate,
      "IsVATRequired": isVATRequired,
      "TaxRegistrationNumber": taxRegistrationNumber ?? "",
      "VATFirmName": vatFirmName ?? "",
      "VATRegisteredAddress": vatRegisteredAddress ?? "",
      "VATEffectiveDate": vatEffectiveDate ?? "",
    };

    try {
      final response = await dioClient.dio.post(
        "$baseUrl/retInsert",
        data: jsonEncode(body),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Retailer data inserted successfully");
      } else {
        throw Exception("Failed to insert data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error inserting retailer data: $e");
    }
  }

  Future<void> updateRetailer({
    required String licenseNumber,
    required String issuingAuthority,
    required String establishmentDate,
    required String expiryDate,
    required String tradeName,
    required String responsiblePerson,
    required String registeredAddress,
    required String effectiveRegistrationDate,
    required bool isVATRequired,
    String? taxRegistrationNumber,
    String? vatFirmName,
    String? vatRegisteredAddress,
    String? vatEffectiveDate,
  }) async {
    final body = {
      "LicenseNumber": licenseNumber,
      "IssuingAuthority": issuingAuthority,
      "EstablishmentDate": establishmentDate,
      "ExpiryDate": expiryDate,
      "TradeName": tradeName,
      "ResponsiblePerson": responsiblePerson,
      "RegisteredAddress": registeredAddress,
      "EffectiveRegistrationDate": effectiveRegistrationDate,
      "IsVATRequired": isVATRequired,
      "TaxRegistrationNumber": taxRegistrationNumber ?? "",
      "VATFirmName": vatFirmName ?? "",
      "VATRegisteredAddress": vatRegisteredAddress ?? "",
      "VATEffectiveDate": vatEffectiveDate ?? "",
    };

    try {
      final response = await dioClient.dio.put(
        "$baseUrl/update/$licenseNumber",
        data: jsonEncode(body),
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Retailer data updated successfully");
      } else {
        throw Exception("Failed to update data. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error updating retailer data: $e");
    }
  }
}
