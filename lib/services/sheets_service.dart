import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gsheets/gsheets.dart';

class SheetsService {
  // ID spreadsheet Anda (dari URL)
  static const _spreadsheetId = '1i_blKgJrrm6sPPireicB5O4n2dZ3m9H1ft__dwhAfds';

  // Inisialisasi gsheets
  static GSheets? _gsheets;
  static Worksheet? _worksheetLkpd;

  // Inisialisasi
  static Future<bool> init() async {
    try {
      // Load credentials from JSON file
      final String credentialsJson = await rootBundle.loadString(
        'assets/config/sheets_credentials.json',
      );
      _gsheets = GSheets(credentialsJson);

      final ss = await _gsheets!.spreadsheet(_spreadsheetId);
      _worksheetLkpd = await _getWorksheet(ss, 'LKPD Submissions');

      // Buat header jika belum ada
      final firstRow = [
        'Timestamp',
        'Nama',
        'Kelompok',
        'Question1',
        'Question2',
        'Question3',
        'Question4',
        'Question5',
        'Question6',
        'Question8',
        'Question9',
        'Question10',
        // Organ ordering
        'Rongga Mulut (Urutan)',
        'Kerongkongan (Urutan)',
        'Lambung (Urutan)',
        'Usus Halus (Urutan)',
        'Usus Besar (Urutan)',
        'Rektum (Urutan)',
        'Anus (Urutan)',
        // Organ functions
        'Rongga Mulut (Fungsi)',
        'Kerongkongan (Fungsi)',
        'Lambung (Fungsi)',
        'Usus Halus (Fungsi)',
        'Usus Besar (Fungsi)',
        'Rektum (Fungsi)',
        'Anus (Fungsi)',
        'Infografis URL',
      ];

      await _worksheetLkpd!.values.insertRow(1, firstRow);
      return true;
    } catch (e) {
      print('Error initializing sheets: $e');
      return false;
    }
  }

  static Future<Worksheet> _getWorksheet(
    Spreadsheet spreadsheet,
    String title,
  ) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title)!;
    }
  }

  // Method untuk menyimpan jawaban LKPD
  static Future<bool> submitLkpd({
    required String name,
    required String group,
    required Map<String, String> answers,
    required Map<String, String> organOrders,
    required Map<String, String> organFunctions,
    String? infografisUrl,
  }) async {
    if (_worksheetLkpd == null) {
      await init();
    }

    try {
      final timestamp = DateTime.now().toIso8601String();
      final newRow = [
        timestamp,
        name,
        group,
        answers['question1'] ?? '',
        answers['question2'] ?? '',
        answers['question3'] ?? '',
        answers['question4'] ?? '',
        answers['question5'] ?? '',
        answers['question6'] ?? '',
        answers['question8'] ?? '',
        answers['question9'] ?? '',
        answers['question10'] ?? '',
        // Organ ordering
        organOrders['ronggaMulut'] ?? '',
        organOrders['kerongkongan'] ?? '',
        organOrders['lambung'] ?? '',
        organOrders['ususHalus'] ?? '',
        organOrders['ususBesar'] ?? '',
        organOrders['rektum'] ?? '',
        organOrders['anus'] ?? '',
        // Organ functions
        organFunctions['ronggaMulut'] ?? '',
        organFunctions['kerongkongan'] ?? '',
        organFunctions['lambung'] ?? '',
        organFunctions['ususHalus'] ?? '',
        organFunctions['ususBesar'] ?? '',
        organFunctions['rektum'] ?? '',
        organFunctions['anus'] ?? '',
        infografisUrl ?? '',
      ];

      return await _worksheetLkpd!.values.appendRow(newRow);
    } catch (e) {
      print('Error submitting data: $e');
      return false;
    }
  }
}
