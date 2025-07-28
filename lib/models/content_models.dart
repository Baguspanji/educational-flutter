class Content {
  final String id;
  final String title;
  final String category;
  final DateTime createdAt;
  final bool isCompleted;

  Content({
    required this.id,
    required this.title,
    required this.category,
    required this.createdAt,
    this.isCompleted = false,
  });
}

class Materi extends Content {
  final String description;
  final List<String> chapters;
  final String difficultyLevel;

  Materi({
    required super.id,
    required super.title,
    required super.category,
    required super.createdAt,
    super.isCompleted,
    required this.description,
    required this.chapters,
    required this.difficultyLevel,
  });
}

class LKPD extends Content {
  final String description;
  final int questionCount;
  final String type; // multiple-choice, essay, etc.
  final int estimatedTimeMinutes;

  LKPD({
    required super.id,
    required super.title,
    required super.category,
    required super.createdAt,
    super.isCompleted,
    required this.description,
    required this.questionCount,
    required this.type,
    required this.estimatedTimeMinutes,
  });
}

class Video extends Content {
  final String description;
  final String videoUrl;
  final int durationInMinutes;
  final String thumbnailUrl;

  Video({
    required super.id,
    required super.title,
    required super.category,
    required super.createdAt,
    super.isCompleted,
    required this.description,
    required this.videoUrl,
    required this.durationInMinutes,
    required this.thumbnailUrl,
  });
}

class Artikel extends Content {
  final String description;
  final String author;
  final String content;
  final int readTimeMinutes;
  final bool isBookmarked;

  Artikel({
    required super.id,
    required super.title,
    required super.category,
    required super.createdAt,
    super.isCompleted,
    required this.description,
    required this.author,
    required this.content,
    required this.readTimeMinutes,
    this.isBookmarked = false,
  });
}

class Kuis extends Content {
  final String description;
  final int questionCount;
  final int timeInMinutes;
  final int? score; // null if not taken yet
  final DateTime? completedAt;

  Kuis({
    required super.id,
    required super.title,
    required super.category,
    required super.createdAt,
    super.isCompleted,
    required this.description,
    required this.questionCount,
    required this.timeInMinutes,
    this.score,
    this.completedAt,
  });
}
