# Testing StorageService

This document provides recommendations for improving the testability of the `StorageService` class and explains the current limitations of testing it.

## Current Limitations

The current `StorageService` class has several characteristics that make it difficult to test:

1. **Direct dependency on Firebase**: The class directly initializes `FirebaseStorage.instance` as a private field, making it difficult to substitute with a mock during testing.

2. **UI dependencies in business logic**: The `uploadInfografis` method shows a dialog and interacts with the UI, which is challenging to test in unit tests.

3. **External dependencies**: The class uses `ImagePicker` and `FilePicker` directly, which interact with device capabilities that can't be easily mocked in unit tests.

## Recommendations for Improved Testability

Here are some suggested modifications to make the `StorageService` more testable:

### 1. Dependency Injection

Modify the class to accept dependencies in the constructor:

```dart
class StorageService {
  final FirebaseStorage storage;
  final ImagePicker imagePicker;
  final FilePicker filePicker;

  StorageService({
    FirebaseStorage? storage,
    ImagePicker? imagePicker,
    FilePicker? filePicker,
  }) : 
    this.storage = storage ?? FirebaseStorage.instance,
    this.imagePicker = imagePicker ?? ImagePicker(),
    this.filePicker = filePicker ?? FilePicker.platform;
  
  // Rest of the class...
}
```

### 2. Extract UI Logic

Separate UI logic from business logic:

```dart
class StorageService {
  // ...
  
  Future<String?> uploadFile(File file, String fileName) async {
    try {
      // Generate unique file name
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final fileExtension = path.extension(fileName);
      final uniqueFileName = 'infografis_$timestamp$fileExtension';

      // Reference untuk path upload
      final ref = storage.ref().child('lkpd_submissions/$uniqueFileName');

      // Upload file
      await ref.putFile(file);

      // Dapatkan URL download
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }
  
  // UI wrapper that calls the testable method above
  Future<String?> uploadInfografisWithUI(BuildContext context) async {
    // Dialog and picker code here...
    // Then call uploadFile(file, fileName);
  }
}
```

### 3. Create Interfaces for Dependencies

Define interfaces for your dependencies to make mocking easier:

```dart
abstract class StorageInterface {
  Reference ref();
  // Other methods...
}

class FirebaseStorageAdapter implements StorageInterface {
  final FirebaseStorage _storage;
  
  FirebaseStorageAdapter([FirebaseStorage? storage]) 
      : _storage = storage ?? FirebaseStorage.instance;
      
  @override
  Reference ref() => _storage.ref();
  // Implement other methods...
}
```

## Test Examples with Improved Design

With these changes, you could write tests like:

```dart
test('uploadFile successfully uploads and returns URL', () async {
  final mockStorage = MockFirebaseStorage();
  final mockRef = MockReference();
  
  when(mockStorage.ref()).thenReturn(mockRef);
  when(mockRef.child(any)).thenReturn(mockRef);
  when(mockRef.putFile(any)).thenReturn(MockUploadTask());
  when(mockRef.getDownloadURL()).thenAnswer((_) async => 'https://example.com/file.jpg');
  
  final service = StorageService(storage: mockStorage);
  final file = File('test.jpg');
  
  final url = await service.uploadFile(file, 'test.jpg');
  
  expect(url, 'https://example.com/file.jpg');
});
```

## Conclusion

Making these changes would significantly improve the testability of the `StorageService` class while maintaining its functionality. The key principle is to design with testing in mind by making dependencies explicit and injectable.
