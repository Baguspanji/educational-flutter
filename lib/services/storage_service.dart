import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload infografis dari galeri atau file lokal
  Future<String?> uploadInfografis(BuildContext context) async {
    try {
      // Tampilkan dialog untuk memilih sumber file
      final source = await showDialog<String>(
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

      if (source == null) return null;

      File? file;
      String? fileName;

      // Pilih file berdasarkan sumber
      if (source == 'gallery') {
        final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          maxWidth: 2000,
          maxHeight: 2000,
        );
        if (pickedFile == null) return null;
        file = File(pickedFile.path);
        fileName = path.basename(pickedFile.path);
      } else {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
          allowMultiple: false,
        );
        if (result == null || result.files.isEmpty) return null;
        file = File(result.files.single.path!);
        fileName = result.files.single.name;
      }

      print('Selected file: $fileName');

      // Generate unique file name
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final fileExtension = path.extension(fileName);
      final uniqueFileName = 'infografis_$timestamp$fileExtension';

      print('Unique file name: $uniqueFileName');

      // Reference untuk path upload
      final ref = _storage.ref().child('lkpd_submissions/$uniqueFileName');

      // Upload file
      await ref.putFile(file);

      // Dapatkan URL download
      final url = await ref.getDownloadURL();
      return url;
    } catch (e, stackTrace) {
      print('Error uploading file: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }
}
