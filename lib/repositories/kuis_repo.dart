import '../models/content_models.dart';

class KuisRepository {
  // Singleton pattern
  KuisRepository._privateConstructor();
  static final KuisRepository instance = KuisRepository._privateConstructor();

  // Dummy data for Kuis
  final List<Kuis> _kuises = [
    Kuis(
      id: 'quiz-001',
      title: 'Kuis Matematika Dasar',
      category: 'Matematika',
      createdAt: DateTime(2025, 5, 15),
      description: 'Uji pemahaman konsep dasar matematika',
      questionCount: 10,
      timeInMinutes: 15,
    ),
    Kuis(
      id: 'quiz-002',
      title: 'Kuis Konsep Fisika',
      category: 'Fisika',
      createdAt: DateTime(2025, 5, 25),
      description: 'Tes pemahaman tentang hukum fisika dasar',
      questionCount: 8,
      timeInMinutes: 20,
      score: 75,
      completedAt: DateTime(2025, 5, 26),
      isCompleted: true,
    ),
    Kuis(
      id: 'quiz-003',
      title: 'Kuis Vocabulary',
      category: 'Bahasa',
      createdAt: DateTime(2025, 6, 10),
      description: 'Tes kosakata bahasa Inggris tingkat menengah',
      questionCount: 15,
      timeInMinutes: 12,
      score: 85,
      completedAt: DateTime(2025, 6, 12),
      isCompleted: true,
    ),
    Kuis(
      id: 'quiz-004',
      title: 'Kuis Pengetahuan Umum',
      category: 'Sosial',
      createdAt: DateTime(2025, 6, 22),
      description: 'Kuis umum tentang pengetahuan sosial dan budaya',
      questionCount: 12,
      timeInMinutes: 15,
    ),
    Kuis(
      id: 'quiz-005',
      title: 'Kuis Kimia Organik',
      category: 'Kimia',
      createdAt: DateTime(2025, 7, 13),
      description: 'Evaluasi pemahaman tentang kimia organik',
      questionCount: 10,
      timeInMinutes: 20,
      score: 90,
      completedAt: DateTime(2025, 7, 15),
      isCompleted: true,
    ),
    Kuis(
      id: 'quiz-006',
      title: 'Kuis Struktur Sel',
      category: 'Biologi',
      createdAt: DateTime(2025, 7, 18),
      description: 'Tes pengetahuan tentang struktur dan fungsi sel',
      questionCount: 10,
      timeInMinutes: 15,
    ),
  ];

  // Get all kuises
  List<Kuis> getAllKuises() {
    return _kuises;
  }

  // Get kuises by category
  List<Kuis> getKuisesByCategory(String category) {
    return _kuises.where((kuis) => kuis.category == category).toList();
  }

  // Get kuis by id
  Kuis? getKuisById(String id) {
    try {
      return _kuises.firstWhere((kuis) => kuis.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get completed kuises
  List<Kuis> getCompletedKuises() {
    return _kuises.where((kuis) => kuis.isCompleted).toList();
  }

  // Get kuises by score range
  List<Kuis> getKuisesByScoreRange(int minScore, int maxScore) {
    return _kuises
        .where(
          (kuis) =>
              kuis.score != null &&
              kuis.score! >= minScore &&
              kuis.score! <= maxScore,
        )
        .toList();
  }

  // Get kuises by difficulty (estimated by time per question)
  List<Kuis> getKuisesByDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'mudah':
        return _kuises
            .where((kuis) => kuis.timeInMinutes / kuis.questionCount < 1.0)
            .toList();
      case 'menengah':
        return _kuises
            .where(
              (kuis) =>
                  kuis.timeInMinutes / kuis.questionCount >= 1.0 &&
                  kuis.timeInMinutes / kuis.questionCount < 2.0,
            )
            .toList();
      case 'sulit':
        return _kuises
            .where((kuis) => kuis.timeInMinutes / kuis.questionCount >= 2.0)
            .toList();
      default:
        return _kuises;
    }
  }

  // Get short kuises (under 15 minutes)
  List<Kuis> getShortKuises() {
    return _kuises.where((kuis) => kuis.timeInMinutes < 15).toList();
  }
}
