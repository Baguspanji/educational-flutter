import 'package:gastrofun/services/sheets_service.dart';

// A testable wrapper for the SheetsService
class SheetsServiceTestHelper {
  // Method to convert submission data to a row format matching what the service does
  static List<String> convertSubmissionToRow({
    required String name,
    required String group,
    required Map<String, String> answers,
    required Map<String, String> organOrders,
    required Map<String, String> organFunctions,
    String? infografisUrl,
  }) {
    final timestamp = DateTime.now().toIso8601String();

    return [
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
  }

  // Helper method to get expected header row
  static List<String> getExpectedHeaderRow() {
    return [
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
  }
}
