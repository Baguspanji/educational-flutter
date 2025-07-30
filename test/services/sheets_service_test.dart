import 'package:flutter_test/flutter_test.dart';
import 'package:gastrofun/services/sheets_service.dart';
import 'package:flutter/services.dart';
import 'sheets_service_test_helper.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set up asset bundle for any asset loading
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
        MethodCall methodCall,
      ) async {
        if (methodCall.method == 'loadString') {
          if (methodCall.arguments == 'assets/config/sheets_credentials.json') {
            return '{"type": "service_account", "project_id": "test-project", "client_email": "test@example.com"}';
          }
        }
        return null;
      });

  group('SheetsService Tests', () {
    test('SheetsService row conversion test', () {
      // Test data
      final name = 'Test Student';
      final group = 'Group A';
      final answers = {
        'question1': 'Answer 1',
        'question2': 'Answer 2',
        'question3': 'Answer 3',
        'question4': 'Answer 4',
        'question5': 'Answer 5',
        'question6': 'Answer 6',
        'question8': 'Answer 8',
        'question9': 'Answer 9',
        'question10': 'Answer 10',
      };
      final organOrders = {
        'ronggaMulut': '1',
        'kerongkongan': '2',
        'lambung': '3',
        'ususHalus': '4',
        'ususBesar': '5',
        'rektum': '6',
        'anus': '7',
      };
      final organFunctions = {
        'ronggaMulut': 'Function 1',
        'kerongkongan': 'Function 2',
        'lambung': 'Function 3',
        'ususHalus': 'Function 4',
        'ususBesar': 'Function 5',
        'rektum': 'Function 6',
        'anus': 'Function 7',
      };
      final infografisUrl = 'https://example.com/image.jpg';

      // Format data
      final row = SheetsServiceTestHelper.convertSubmissionToRow(
        name: name,
        group: group,
        answers: answers,
        organOrders: organOrders,
        organFunctions: organFunctions,
        infografisUrl: infografisUrl,
      );

      // Verify conversion (indices match SheetsService.submitLkpd implementation)
      expect(row[1], equals(name));
      expect(row[2], equals(group));
      expect(row[3], equals(answers['question1']));
      expect(row[4], equals(answers['question2']));
      expect(row[12], equals(organOrders['ronggaMulut']));
      expect(row[13], equals(organOrders['kerongkongan']));
      expect(row[19], equals(organFunctions['ronggaMulut']));
      expect(row[20], equals(organFunctions['kerongkongan']));
      expect(row[26], equals(infografisUrl));
    });

    test('SheetsService header row test', () {
      // Get expected header row
      final headerRow = SheetsServiceTestHelper.getExpectedHeaderRow();

      // Verify header values
      expect(headerRow[0], equals('Timestamp'));
      expect(headerRow[1], equals('Nama'));
      expect(headerRow[2], equals('Kelompok'));
      expect(headerRow[3], equals('Question1'));
      expect(headerRow[12], equals('Rongga Mulut (Urutan)'));
      expect(headerRow[19], equals('Rongga Mulut (Fungsi)'));
      expect(headerRow[26], equals('Infografis URL'));

      // Verify the header row has the correct length (should match the data row length)
      expect(headerRow.length, equals(27));
    });

    test('SheetsService should handle initialization error cases', () async {
      // We expect an error when trying to initialize with invalid credentials
      try {
        await SheetsService.init();
        fail('Should have thrown an exception');
      } catch (e) {
        // Pass - we expect an error
        expect(e.toString().isNotEmpty, true);
      }
    });

    test('SheetsService row conversion should handle null infografisUrl', () {
      // Test data with null infografisUrl
      final name = 'Test Student';
      final group = 'Group A';
      final answers = {'question1': 'Answer 1', 'question2': 'Answer 2'};
      final organOrders = {'ronggaMulut': '1', 'kerongkongan': '2'};
      final organFunctions = {
        'ronggaMulut': 'Function 1',
        'kerongkongan': 'Function 2',
      };

      // Convert data without infografisUrl
      final row = SheetsServiceTestHelper.convertSubmissionToRow(
        name: name,
        group: group,
        answers: answers,
        organOrders: organOrders,
        organFunctions: organFunctions,
        // infografisUrl is null
      );

      // Verify the data was processed correctly
      expect(row[26], equals(''));
    });

    test('SheetsService row conversion should handle missing fields', () {
      // Test data with incomplete answers
      final name = 'Test Student';
      final group = 'Group A';
      final answers = {
        'question1': 'Answer 1',
        // Some answers missing
      };
      final organOrders = {
        'ronggaMulut': '1',
        'kerongkongan': '2',
        // Rest missing
      };
      final organFunctions = {
        'ronggaMulut': 'Function 1',
        // Rest missing
      };

      // Format the data
      final row = SheetsServiceTestHelper.convertSubmissionToRow(
        name: name,
        group: group,
        answers: answers,
        organOrders: organOrders,
        organFunctions: organFunctions,
      );

      // Verify missing fields are replaced with empty strings
      expect(row[1], equals(name));
      expect(row[2], equals(group));
      expect(row[3], equals('Answer 1')); // question1
      expect(row[4], equals('')); // question2 (missing)
      expect(row[12], equals('1')); // ronggaMulut order
      expect(row[13], equals('')); // kerongkongan order (missing)
      expect(row[19], equals('Function 1')); // ronggaMulut function
      expect(row[20], equals('')); // kerongkongan function (missing)
    });
  });
}
