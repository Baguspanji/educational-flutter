import 'package:gastrofun/services/sheets_service.dart';

// A wrapper for SheetsService to make it more testable
class SheetsServiceWrapper {
  // Delegate to the real SheetsService
  Future<bool> init() => SheetsService.init();

  Future<bool> submitLkpd({
    required String name,
    required String group,
    required Map<String, String> answers,
    required Map<String, String> organOrders,
    required Map<String, String> organFunctions,
    String? infografisUrl,
  }) => SheetsService.submitLkpd(
    name: name,
    group: group,
    answers: answers,
    organOrders: organOrders,
    organFunctions: organFunctions,
    infografisUrl: infografisUrl,
  );
}
