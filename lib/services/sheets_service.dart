import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:gsheets/gsheets.dart';

class SheetsService {
  // ID spreadsheet Anda (dari URL)
  static const _spreadsheetId = '1i_blKgJrrm6sPPireicB5O4n2dZ3m9H1ft__dwhAfds';

  // Inisialisasi gsheets
  static GSheets? _gsheets;
  static Worksheet? _worksheetLkpd;
  static Worksheet? _worksheetKuis;

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

  // Method untuk menyiapkan worksheet Kuis
  static Future<void> _initKuisWorksheet() async {
    if (_gsheets == null) {
      await init();
    }

    final ss = await _gsheets!.spreadsheet(_spreadsheetId);
    _worksheetKuis = await _getWorksheet(ss, 'Kuis Submissions');

    // Buat header jika belum ada
    final firstRow = [
      'Timestamp',
      'Nama',
      'Kelompok',
      'MultipleChoice1',
      'MultipleChoice2',
      'MultipleChoice3',
      'MultipleChoice4',
      'MultipleChoice5',
      'MultipleChoice6',
      'MultipleChoice7',
      'MultipleChoice8',
      'MultipleChoice9',
      'MultipleChoice10',
      'MultipleChoice11',
      'MultipleChoice12',
      'MultipleChoice13',
      'MultipleChoice14',
      'MultipleChoice15',
      'ShortAnswer1',
      'ShortAnswer2',
      'ShortAnswer3',
      'ShortAnswer4',
      'ShortAnswer5',
      'ShortAnswer6',
      'ShortAnswer7',
      'ShortAnswer8',
      'ShortAnswer9',
      'ShortAnswer10',
      'Essay1',
      'Essay2',
      'Essay3',
      'Essay4',
      'Essay5',
      'Total Score',
    ];

    await _worksheetKuis!.values.insertRow(1, firstRow);
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

  // Method untuk menyimpan jawaban Kuis
  static Future<bool> submitKuis({
    required String name,
    required String group,
    required Map<String, String> multipleChoiceAnswers,
    required Map<String, String> shortAnswers,
    required Map<String, String> essayAnswers,
    required double totalScore,
  }) async {
    if (_worksheetKuis == null) {
      await _initKuisWorksheet();
    }

    try {
      final timestamp = DateTime.now().toIso8601String();
      final newRow = [
        timestamp,
        name,
        group,
        multipleChoiceAnswers['mc1'] ?? '',
        multipleChoiceAnswers['mc2'] ?? '',
        multipleChoiceAnswers['mc3'] ?? '',
        multipleChoiceAnswers['mc4'] ?? '',
        multipleChoiceAnswers['mc5'] ?? '',
        multipleChoiceAnswers['mc6'] ?? '',
        multipleChoiceAnswers['mc7'] ?? '',
        multipleChoiceAnswers['mc8'] ?? '',
        multipleChoiceAnswers['mc9'] ?? '',
        multipleChoiceAnswers['mc10'] ?? '',
        multipleChoiceAnswers['mc11'] ?? '',
        multipleChoiceAnswers['mc12'] ?? '',
        multipleChoiceAnswers['mc13'] ?? '',
        multipleChoiceAnswers['mc14'] ?? '',
        multipleChoiceAnswers['mc15'] ?? '',
        shortAnswers['sa1'] ?? '',
        shortAnswers['sa2'] ?? '',
        shortAnswers['sa3'] ?? '',
        shortAnswers['sa4'] ?? '',
        shortAnswers['sa5'] ?? '',
        shortAnswers['sa6'] ?? '',
        shortAnswers['sa7'] ?? '',
        shortAnswers['sa8'] ?? '',
        shortAnswers['sa9'] ?? '',
        shortAnswers['sa10'] ?? '',
        essayAnswers['essay1'] ?? '',
        essayAnswers['essay2'] ?? '',
        essayAnswers['essay3'] ?? '',
        essayAnswers['essay4'] ?? '',
        essayAnswers['essay5'] ?? '',
        totalScore.toString(),
      ];

      return await _worksheetKuis!.values.appendRow(newRow);
    } catch (e) {
      print('Error submitting quiz data: $e');
      return false;
    }
  }
}
