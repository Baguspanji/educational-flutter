import '../models/content_models.dart';

class MateriRepository {
  // Singleton pattern
  MateriRepository._privateConstructor();
  static final MateriRepository instance =
      MateriRepository._privateConstructor();

  // Dummy data for materi
  final List<Materi> _materis = [
    Materi(
      id: 'mat-001',
      title: 'Pengenalan Matematika Dasar',
      category: 'Matematika',
      createdAt: DateTime(2025, 5, 10),
      description: 'Mempelajari konsep dasar matematika untuk pemula',
      chapters: [
        'Bilangan dan Operasi Dasar',
        'Aljabar Dasar',
        'Geometri Sederhana',
        'Pengukuran',
        'Statistik Dasar',
      ],
      difficultyLevel: 'Pemula',
    ),
    Materi(
      id: 'mat-002',
      title: 'Fisika Terapan',
      category: 'Fisika',
      createdAt: DateTime(2025, 5, 15),
      description:
          'Memahami konsep fisika dan aplikasinya dalam kehidupan sehari-hari',
      chapters: [
        'Mekanika',
        'Termodinamika',
        'Listrik dan Magnetisme',
        'Optik',
        'Fisika Modern',
      ],
      difficultyLevel: 'Menengah',
    ),
    Materi(
      id: 'mat-003',
      title: 'Bahasa Inggris Percakapan',
      category: 'Bahasa',
      createdAt: DateTime(2025, 6, 1),
      description:
          'Panduan praktis untuk percakapan bahasa Inggris sehari-hari',
      chapters: [
        'Perkenalan Diri',
        'Percakapan Dasar',
        'Situasi di Tempat Umum',
        'Berbicara di Lingkungan Kerja',
        'Ungkapan Populer',
      ],
      difficultyLevel: 'Pemula',
    ),
    Materi(
      id: 'mat-004',
      title: 'Ilmu Sosial & Budaya',
      category: 'Sosial',
      createdAt: DateTime(2025, 6, 12),
      description:
          'Pengantar tentang ilmu sosial dan keragaman budaya Indonesia',
      chapters: [
        'Dasar-dasar Sosiologi',
        'Budaya dan Masyarakat',
        'Etnografi Indonesia',
        'Perubahan Sosial',
        'Globalisasi dan Identitas',
      ],
      difficultyLevel: 'Menengah',
    ),
    Materi(
      id: 'mat-005',
      title: 'Kimia Organik',
      category: 'Kimia',
      createdAt: DateTime(2025, 7, 5),
      description: 'Mempelajari struktur, sifat, dan reaksi senyawa organik',
      chapters: [
        'Pengantar Kimia Organik',
        'Gugus Fungsi',
        'Reaksi-reaksi Organik',
        'Polimer dan Aplikasi',
        'Kimia Organik dalam Kehidupan',
      ],
      difficultyLevel: 'Lanjut',
      isCompleted: true,
    ),
    Materi(
      id: 'mat-006',
      title: 'Biologi Sel',
      category: 'Biologi',
      createdAt: DateTime(2025, 7, 10),
      description:
          'Memahami struktur dan fungsi sel sebagai unit dasar kehidupan',
      chapters: [
        'Pengantar Biologi Sel',
        'Struktur Sel',
        'Organela dan Fungsinya',
        'Metabolisme Sel',
        'Reproduksi Sel',
      ],
      difficultyLevel: 'Menengah',
    ),
  ];

  // Get all materials
  List<Materi> getAllMateri() {
    return _materis;
  }

  // Get materials by category
  List<Materi> getMateriByCategory(String category) {
    return _materis.where((materi) => materi.category == category).toList();
  }

  // Get material by id
  Materi? getMateriById(String id) {
    try {
      return _materis.firstWhere((materi) => materi.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get completed materials
  List<Materi> getCompletedMateri() {
    return _materis.where((materi) => materi.isCompleted).toList();
  }
}
