import '../models/content_models.dart';

class VideoRepository {
  // Singleton pattern
  VideoRepository._privateConstructor();
  static final VideoRepository instance = VideoRepository._privateConstructor();

  // Dummy data for Video
  final List<Video> _videos = [
    Video(
      id: 'vid-001',
      title: 'Penjelasan Teorema Pythagoras',
      category: 'Matematika',
      createdAt: DateTime(2025, 5, 13),
      description:
          'Video penjelasan tentang teorema Pythagoras dan contoh aplikasinya',
      videoUrl: 'https://example.com/videos/pythagoras',
      durationInMinutes: 8,
      thumbnailUrl: 'assets/images/thumbnails/pythagoras.jpg',
    ),
    Video(
      id: 'vid-002',
      title: 'Hukum Newton dalam Kehidupan',
      category: 'Fisika',
      createdAt: DateTime(2025, 5, 20),
      description:
          'Menjelaskan aplikasi hukum Newton dalam kehidupan sehari-hari',
      videoUrl: 'https://example.com/videos/newton-laws',
      durationInMinutes: 12,
      thumbnailUrl: 'assets/images/thumbnails/newton.jpg',
    ),
    Video(
      id: 'vid-003',
      title: 'Teknik Percakapan Bahasa Inggris',
      category: 'Bahasa',
      createdAt: DateTime(2025, 6, 7),
      description:
          'Tutorial teknik percakapan bahasa Inggris untuk berbagai situasi',
      videoUrl: 'https://example.com/videos/english-conversation',
      durationInMinutes: 15,
      thumbnailUrl: 'assets/images/thumbnails/english.jpg',
      isCompleted: true,
    ),
    Video(
      id: 'vid-004',
      title: 'Kebudayaan Nusantara',
      category: 'Sosial',
      createdAt: DateTime(2025, 6, 18),
      description: 'Dokumenter tentang keberagaman budaya di Indonesia',
      videoUrl: 'https://example.com/videos/indonesian-culture',
      durationInMinutes: 25,
      thumbnailUrl: 'assets/images/thumbnails/culture.jpg',
    ),
    Video(
      id: 'vid-005',
      title: 'Reaksi Kimia yang Menarik',
      category: 'Kimia',
      createdAt: DateTime(2025, 7, 9),
      description:
          'Demonstrasi berbagai reaksi kimia yang spektakuler dan penjelasannya',
      videoUrl: 'https://example.com/videos/chemical-reactions',
      durationInMinutes: 18,
      thumbnailUrl: 'assets/images/thumbnails/chemistry.jpg',
    ),
    Video(
      id: 'vid-006',
      title: 'Eksplorasi Sel dengan Mikroskop',
      category: 'Biologi',
      createdAt: DateTime(2025, 7, 14),
      description:
          'Video pengamatan berbagai jenis sel menggunakan mikroskop elektron',
      videoUrl: 'https://example.com/videos/cell-exploration',
      durationInMinutes: 14,
      thumbnailUrl: 'assets/images/thumbnails/cells.jpg',
    ),
  ];

  // Get all videos
  List<Video> getAllVideos() {
    return _videos;
  }

  // Get videos by category
  List<Video> getVideosByCategory(String category) {
    return _videos.where((video) => video.category == category).toList();
  }

  // Get video by id
  Video? getVideoById(String id) {
    try {
      return _videos.firstWhere((video) => video.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get videos by duration (less than or equal to specified minutes)
  List<Video> getVideosByMaxDuration(int maxMinutes) {
    return _videos
        .where((video) => video.durationInMinutes <= maxMinutes)
        .toList();
  }

  // Get completed videos
  List<Video> getCompletedVideos() {
    return _videos.where((video) => video.isCompleted).toList();
  }

  // Get recent videos (last 30 days)
  List<Video> getRecentVideos() {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return _videos
        .where((video) => video.createdAt.isAfter(thirtyDaysAgo))
        .toList();
  }
}
