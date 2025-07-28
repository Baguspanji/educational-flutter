import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';

class MateriDetailScreen extends StatefulWidget {
  final String materiId;

  const MateriDetailScreen({super.key, required this.materiId});

  @override
  State<MateriDetailScreen> createState() => _MateriDetailScreenState();
}

class _MateriDetailScreenState extends State<MateriDetailScreen> {
  late Materi? materi;
  int currentChapterIndex = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Load the materi data
    _loadMateri();
  }

  void _loadMateri() {
    // In a real app, this would be an async operation
    materi = MateriRepository.instance.getMateriById(widget.materiId);
    setState(() {
      isLoading = false;
    });
  }

  void _nextChapter() {
    if (materi != null && currentChapterIndex < materi!.chapters.length - 1) {
      setState(() {
        currentChapterIndex++;
      });
    }
  }

  void _previousChapter() {
    if (currentChapterIndex > 0) {
      setState(() {
        currentChapterIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (materi == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Materi tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(materi!.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (currentChapterIndex + 1) / materi!.chapters.length,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header info
                  _buildHeader(context),
                  const SizedBox(height: 24),

                  // Chapter navigation
                  _buildChapterNav(context),
                  const SizedBox(height: 24),

                  // Chapter content
                  _buildChapterContent(context),
                ],
              ),
            ),
          ),

          // Bottom navigation
          _buildBottomNav(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getCategoryColor(materi!.category).withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            materi!.category,
            style: TextStyle(
              color: _getCategoryColor(materi!.category),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Title and metadata
        Text(
          materi!.title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(materi!.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),

        // Metadata row
        Row(
          children: [
            _buildMetadataItem(
              context,
              Icons.signal_cellular_alt,
              materi!.difficultyLevel,
            ),
            const SizedBox(width: 16),
            _buildMetadataItem(
              context,
              Icons.library_books,
              '${materi!.chapters.length} Bab',
            ),
            const SizedBox(width: 16),
            _buildMetadataItem(
              context,
              Icons.calendar_today,
              _formatDate(materi!.createdAt),
            ),
          ],
        ),
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildMetadataItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
        ),
      ],
    );
  }

  Widget _buildChapterNav(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chapter navigation header
        Row(
          children: [
            Text(
              'Bab ${currentChapterIndex + 1} dari ${materi!.chapters.length}',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () {
                _showChaptersBottomSheet(context);
              },
              tooltip: 'Daftar Bab',
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Current chapter title
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            materi!.chapters[currentChapterIndex],
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showChaptersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Daftar Bab',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: materi!.chapters.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(materi!.chapters[index]),
                      leading: CircleAvatar(
                        backgroundColor: currentChapterIndex == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade200,
                        foregroundColor: currentChapterIndex == index
                            ? Colors.white
                            : Colors.black,
                        child: Text('${index + 1}'),
                      ),
                      onTap: () {
                        setState(() {
                          currentChapterIndex = index;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChapterContent(BuildContext context) {
    // In a real app, this would load the actual content for the chapter
    // Here we're just showing a placeholder
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          materi!.chapters[currentChapterIndex],
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          'Konten materi untuk bab ini akan ditampilkan di sini. '
          'Pada aplikasi yang sebenarnya, konten ini akan berisi teks, gambar, '
          'dan mungkin interaksi lainnya yang relevan dengan topik pembelajaran.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Catatan Penting:',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ini adalah contoh bagian penting dari materi yang mungkin '
                'perlu diperhatikan khusus oleh pengguna.',
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        // Add some space at the bottom for better scrolling
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          // Previous button
          if (currentChapterIndex > 0)
            Expanded(
              child: CustomButton(
                label: 'Sebelumnya',
                onPressed: _previousChapter,
                backgroundColor: Colors.white,
                textColor: Theme.of(context).colorScheme.primary,
                borderRadius: 8,
              ),
            ),
          if (currentChapterIndex > 0) const SizedBox(width: 16),

          // Next/Finish button
          Expanded(
            child: CustomButton(
              label: currentChapterIndex < materi!.chapters.length - 1
                  ? 'Selanjutnya'
                  : 'Selesai',
              onPressed: () {
                if (currentChapterIndex < materi!.chapters.length - 1) {
                  _nextChapter();
                } else {
                  // Mark as completed and navigate back
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Selamat! Anda telah menyelesaikan materi ini.',
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              borderRadius: 8,
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Matematika':
        return Colors.blue.shade700;
      case 'Fisika':
        return Colors.purple.shade700;
      case 'Bahasa':
        return Colors.green.shade700;
      case 'Sosial':
        return Colors.orange.shade700;
      case 'Kimia':
        return Colors.red.shade700;
      case 'Biologi':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
