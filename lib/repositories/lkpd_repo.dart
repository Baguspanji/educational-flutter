import '../models/content_models.dart';

class LkpdRepository {
  // Singleton pattern
  LkpdRepository._privateConstructor();
  static final LkpdRepository instance = LkpdRepository._privateConstructor();

  // Dummy data for LKPD
  final List<LKPD> _lkpds = [
    LKPD(
      id: 'lkpd-001',
      title: 'Latihan Soal Matematika',
      category: 'Matematika',
      createdAt: DateTime(2025, 5, 12),
      description: 'Latihan soal-soal matematika dasar untuk pemahaman konsep',
      questionCount: 15,
      type: 'Pilihan Ganda',
      estimatedTimeMinutes: 30,
    ),
    LKPD(
      id: 'lkpd-002',
      title: 'Eksperimen Fisika Sederhana',
      category: 'Fisika',
      createdAt: DateTime(2025, 5, 18),
      description:
          'Panduan untuk melakukan eksperimen fisika sederhana di rumah',
      questionCount: 5,
      type: 'Praktikum',
      estimatedTimeMinutes: 60,
    ),
    LKPD(
      id: 'lkpd-003',
      title: 'Latihan Grammar Bahasa Inggris',
      category: 'Bahasa',
      createdAt: DateTime(2025, 6, 5),
      description: 'Latihan tata bahasa untuk meningkatkan kemampuan menulis',
      questionCount: 20,
      type: 'Isian & Pilihan Ganda',
      estimatedTimeMinutes: 45,
    ),
    LKPD(
      id: 'lkpd-004',
      title: 'Analisis Sosial Budaya',
      category: 'Sosial',
      createdAt: DateTime(2025, 6, 15),
      description: 'Lembar kerja untuk menganalisis fenomena sosial budaya',
      questionCount: 8,
      type: 'Essay',
      estimatedTimeMinutes: 90,
      isCompleted: true,
    ),
    LKPD(
      id: 'lkpd-005',
      title: 'Latihan Reaksi Kimia',
      category: 'Kimia',
      createdAt: DateTime(2025, 7, 8),
      description: 'Latihan menyelesaikan persamaan reaksi kimia',
      questionCount: 12,
      type: 'Isian',
      estimatedTimeMinutes: 40,
    ),
    LKPD(
      id: 'lkpd-006',
      title: 'Pengamatan Ekosistem',
      category: 'Biologi',
      createdAt: DateTime(2025, 7, 12),
      description: 'Lembar kerja untuk pengamatan dan analisis ekosistem',
      questionCount: 10,
      type: 'Observasi & Laporan',
      estimatedTimeMinutes: 120,
    ),
  ];

  // Get all LKPD
  List<LKPD> getAllLkpd() {
    return _lkpds;
  }

  // Get LKPD by category
  List<LKPD> getLkpdByCategory(String category) {
    return _lkpds.where((lkpd) => lkpd.category == category).toList();
  }

  // Get LKPD by id
  LKPD? getLkpdById(String id) {
    try {
      return _lkpds.firstWhere((lkpd) => lkpd.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get LKPD by type
  List<LKPD> getLkpdByType(String type) {
    return _lkpds.where((lkpd) => lkpd.type == type).toList();
  }

  // Get completed LKPD
  List<LKPD> getCompletedLkpd() {
    return _lkpds.where((lkpd) => lkpd.isCompleted).toList();
  }
}
