import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';
import 'kuis_kerjakan_screen.dart';

class KuisDetailScreen extends StatefulWidget {
  final Kuis kuis;

  const KuisDetailScreen({super.key, required this.kuis});

  @override
  State<KuisDetailScreen> createState() => _KuisDetailScreenState();
}

class _KuisDetailScreenState extends State<KuisDetailScreen> {
  late bool _isCompleted;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.kuis.isCompleted;

    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 300 && !_showBackToTop) {
        setState(() {
          _showBackToTop = true;
        });
      } else if (_scrollController.position.pixels <= 300 && _showBackToTop) {
        setState(() {
          _showBackToTop = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kuis.category),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur berbagi belum tersedia')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.kuis.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Score badge if completed
                if (_isCompleted && widget.kuis.score != null)
                  _buildScoreBadge(),

                const SizedBox(height: 16),

                // Metadata Row
                Row(
                  children: [
                    _buildMetadataPill(
                      context,
                      _getDifficultyText(),
                      _getDifficultyIcon(),
                      _getDifficultyColor(),
                    ),
                    const SizedBox(width: 8),
                    _buildMetadataPill(
                      context,
                      '${widget.kuis.timeInMinutes} menit',
                      Icons.timer,
                      Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    _buildMetadataPill(
                      context,
                      '${widget.kuis.questionCount} soal',
                      Icons.question_answer,
                      Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                Text(
                  'Deskripsi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.kuis.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),

                // Content Card
                _buildKuisContentCard(),
                const SizedBox(height: 24),

                // Previous Result if completed
                if (_isCompleted && widget.kuis.completedAt != null)
                  _buildPreviousResultCard(),

                const SizedBox(height: 24),

                // Related Kuis section
                Text(
                  'Kuis Terkait',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRelatedKuis(),
              ],
            ),
          ),

          // Back to top button
          if (_showBackToTop)
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
        ],
      ),
      floatingActionButton: !_isCompleted
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KuisKerjakanScreen(kuis: widget.kuis),
                  ),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: const Text('Mulai Kuis'),
              icon: const Icon(Icons.play_arrow),
            )
          : null,
    );
  }

  Widget _buildScoreBadge() {
    final score = widget.kuis.score ?? 0;
    Color scoreColor = score >= 80
        ? Colors.green
        : score >= 60
        ? Colors.orange
        : Colors.red;

    return Center(
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: scoreColor.withOpacity(0.1),
          border: Border.all(color: scoreColor, width: 3),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.kuis.score}%',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
              Text('Nilai', style: TextStyle(fontSize: 14, color: scoreColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviousResultCard() {
    final dateStr = _formatDate(widget.kuis.completedAt!);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.history, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Hasil Kuis Terakhir',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Nilai', '${widget.kuis.score}%'),
            const Divider(),
            _buildInfoRow('Dikerjakan Pada', dateStr),
            const SizedBox(height: 16),
            Center(
              child: CustomButton(
                label: 'Lihat Detail Hasil',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KuisKerjakanScreen(
                        kuis: widget.kuis,
                        showResults: true,
                      ),
                    ),
                  );
                },
                small: true,
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataPill(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _getDifficultyText() {
    final timePerQuestion =
        widget.kuis.timeInMinutes / widget.kuis.questionCount;
    if (timePerQuestion < 1.0) {
      return 'Mudah';
    } else if (timePerQuestion < 2.0) {
      return 'Menengah';
    } else {
      return 'Sulit';
    }
  }

  IconData _getDifficultyIcon() {
    final timePerQuestion =
        widget.kuis.timeInMinutes / widget.kuis.questionCount;
    if (timePerQuestion < 1.0) {
      return Icons.sentiment_satisfied;
    } else if (timePerQuestion < 2.0) {
      return Icons.sentiment_neutral;
    } else {
      return Icons.sentiment_very_dissatisfied;
    }
  }

  Color _getDifficultyColor() {
    final timePerQuestion =
        widget.kuis.timeInMinutes / widget.kuis.questionCount;
    if (timePerQuestion < 1.0) {
      return Colors.green;
    } else if (timePerQuestion < 2.0) {
      return Colors.amber;
    } else {
      return Colors.red;
    }
  }

  Widget _buildKuisContentCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi Kuis',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Kategori', widget.kuis.category),
            const Divider(),
            _buildInfoRow('Jumlah Soal', '${widget.kuis.questionCount} soal'),
            const Divider(),
            _buildInfoRow('Waktu', '${widget.kuis.timeInMinutes} menit'),
            const Divider(),
            _buildInfoRow('Tingkat Kesulitan', _getDifficultyText()),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pastikan Anda sudah memahami materi sebelum mengerjakan kuis ini',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRelatedKuis() {
    // Get related Kuis based on category
    final relatedKuises = KuisRepository.instance
        .getKuisesByCategory(widget.kuis.category)
        .where((l) => l.id != widget.kuis.id)
        .toList();

    if (relatedKuises.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text('Tidak ada Kuis terkait')),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: relatedKuises.length > 3 ? 3 : relatedKuises.length,
      itemBuilder: (context, index) {
        final kuis = relatedKuises[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            title: Text(
              kuis.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.question_answer,
                  size: 12,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '${kuis.questionCount} soal',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 8),
                Icon(Icons.timer, size: 12, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '${kuis.timeInMinutes} min',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            trailing: kuis.isCompleted
                ? Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${kuis.score ?? 0}%',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  )
                : const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => KuisDetailScreen(kuis: kuis),
                ),
              );
            },
          ),
        );
      },
    );
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
