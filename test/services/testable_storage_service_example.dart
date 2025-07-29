import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

// Interface for Storage service to make testing easier
abstract class StorageServiceInterface {
  Future<String?> uploadFile(File file, String fileName);
}

class StorageService implements StorageServiceInterface {
  // Make dependencies injectable for testing
  final FirebaseStorage _storage;
  final ImagePicker _imagePicker;
  final FilePicker _filePicker;

  // Constructor with optional dependency injection
  StorageService({
    FirebaseStorage? storage,
    ImagePicker? imagePicker,
    FilePicker? filePicker,
  }) : _storage = storage ?? FirebaseStorage.instance,
       _imagePicker = imagePicker ?? ImagePicker(),
       _filePicker = filePicker ?? FilePicker.platform;

  // Testable method for file upload logic
  @override
  Future<String?> uploadFile(File file, String fileName) async {
    try {
      // Generate unique file name
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final fileExtension = path.extension(fileName);
      final uniqueFileName = 'infografis_$timestamp$fileExtension';

      // Reference untuk path upload
      final ref = _storage.ref().child('lkpd_submissions/$uniqueFileName');

      // Upload file
      await ref.putFile(file);

      // Dapatkan URL download
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  // Method to choose source using dialog - separated from upload logic
  Future<String?> chooseFileSource(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pilih Sumber File'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'gallery'),
              child: const Text('Galeri'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 'file'),
              child: const Text('Dokumen (PDF, PNG, JPG)'),
            ),
          ],
        );
      },
    );
  }

  // Method to pick file from gallery - separated for testability
  Future<(File?, String?)?> pickImageFromGallery() async {
    final pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
    );
    if (pickedFile == null) return null;
    final file = File(pickedFile.path);
    final fileName = path.basename(pickedFile.path);
    return (file, fileName);
  }

  // Method to pick file from document storage - separated for testability
  Future<(File?, String?)?> pickFile() async {
    final result = await _filePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      allowMultiple: false,
    );
    if (result == null || result.files.isEmpty) return null;
    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;
    return (file, fileName);
  }

  // The original method, now using the more testable methods above
  Future<String?> uploadInfografis(BuildContext context) async {
    try {
      // Get file source choice
      final source = await chooseFileSource(context);
      if (source == null) return null;

      // Get file based on source
      (File?, String?)? fileInfo;
      if (source == 'gallery') {
        fileInfo = await pickImageFromGallery();
      } else {
        fileInfo = await pickFile();
      }

      // Check if file selection was successful
      if (fileInfo == null) return null;
      final (file, fileName) = fileInfo;
      if (file == null || fileName == null) return null;

      // Upload the file
      return await uploadFile(file, fileName);
    } catch (e) {
      print('Error in uploadInfografis: $e');
      return null;
    }
  }
}
