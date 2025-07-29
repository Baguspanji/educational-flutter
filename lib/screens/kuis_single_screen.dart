import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../widgets/custom_button.dart';

class KuisSingleScreen extends StatefulWidget {
  const KuisSingleScreen({super.key});

  @override
  State<KuisSingleScreen> createState() => _KuisSingleScreenState();
}

class _KuisSingleScreenState extends State<KuisSingleScreen> {
  late Kuis? kuis;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    // Load the kuis data
    _loadKuis();

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

  void _loadKuis() {
    // In a real app, this would be an async operation
    kuis = Kuis(
      id: 'kuis-001',
      title: 'Kuis Sistem Pencernaan Manusia',
      category: 'Biologi',
      createdAt: DateTime(2025, 7, 15),
      description:
          'Uji pemahaman Anda tentang sistem pencernaan manusia melalui kuis ini',
      isCompleted: false,
      questionCount: 15,
      timeInMinutes: 30,
      questions: [
        'Sebutkan urutan organ dalam sistem pencernaan manusia!',
        'Jelaskan perbedaan antara pencernaan mekanik dan kimiawi!',
        'Bagaimana proses penyerapan nutrisi terjadi di usus halus?',
        'Jelaskan fungsi utama enzim amilase dalam pencernaan!',
        'Apa peran empedu dalam pencernaan lemak?',
        'Jelaskan perbedaan antara usus besar dan usus halus!',
        'Bagaimana peristalsis membantu proses pencernaan?',
        'Sebutkan minimal 3 gangguan umum pada sistem pencernaan dan penyebabnya!',
        'Jelaskan proses pencernaan karbohidrat secara lengkap!',
        'Bagaimana hubungan antara pola makan dengan kesehatan sistem pencernaan?',
      ],
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (kuis == null) {
      return const Center(child: Text('Kuis tidak ditemukan'));
    }

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header info
                    _buildHeader(context),
                    const SizedBox(height: 24),

                    // Kuis Content Card
                    _buildKuisContentCard(),
                    const SizedBox(height: 24),

                    // Instructions
                    _buildInstructionsCard(),
                    const SizedBox(height: 24),

                    // Sample Questions
                    _buildSampleQuestionsCard(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            // Bottom navigation
            _buildBottomNav(context),
          ],
        ),

        // Back to top button
        if (_showBackToTop)
          Positioned(
            bottom: 90,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              heroTag: 'backToTop',
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.7),
              child: const Icon(Icons.arrow_upward, size: 20),
            ),
          ),
      ],
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
            color: _getCategoryColor(kuis!.category).withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            kuis!.category,
            style: TextStyle(
              color: _getCategoryColor(kuis!.category),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Title and description
        Text(
          kuis!.title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(kuis!.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),

        // Metadata row
        Row(
          children: [
            _buildMetadataItem(
              context,
              Icons.help_outline,
              '${kuis!.questionCount} soal',
            ),
            const SizedBox(width: 16),
            _buildMetadataItem(
              context,
              Icons.timer,
              '${kuis!.timeInMinutes} menit',
            ),
            const SizedBox(width: 16),
            _buildMetadataItem(
              context,
              Icons.calendar_today,
              _formatDate(kuis!.createdAt),
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
            _buildInfoRow('Kategori', kuis!.category),
            const Divider(),
            _buildInfoRow('Jumlah Soal', '${kuis!.questionCount} soal'),
            const Divider(),
            _buildInfoRow('Waktu', '${kuis!.timeInMinutes} menit'),
            const Divider(),
            _buildInfoRow('Tingkat Kesulitan', _getDifficultyText()),
            const SizedBox(height: 16),
            if (kuis!.isCompleted && kuis!.score != null) ...[
              const Divider(),
              const SizedBox(height: 16),
              Center(child: _buildScoreBadge()),
            ],
          ],
        ),
      ),
    );
  }

  String _getDifficultyText() {
    final timePerQuestion = kuis!.timeInMinutes / kuis!.questionCount;
    if (timePerQuestion < 1.0) {
      return 'Mudah';
    } else if (timePerQuestion < 2.0) {
      return 'Menengah';
    } else {
      return 'Sulit';
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildInstructionsCard() {
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
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Petunjuk Pengerjaan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              '1. Kuis ini terdiri dari soal pilihan ganda dan esai.',
              style: TextStyle(height: 1.5),
            ),
            const Text(
              '2. Setiap soal memiliki bobot nilai yang sama.',
              style: TextStyle(height: 1.5),
            ),
            const Text(
              '3. Kerjakan soal dalam waktu yang telah ditentukan.',
              style: TextStyle(height: 1.5),
            ),
            const Text(
              '4. Pastikan koneksi internet Anda stabil selama mengerjakan kuis.',
              style: TextStyle(height: 1.5),
            ),
            const Text(
              '5. Anda tidak dapat kembali ke soal sebelumnya setelah menjawab.',
              style: TextStyle(height: 1.5),
            ),
            const Text(
              '6. Nilai akan muncul setelah semua soal dikerjakan.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade800,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Pastikan Anda sudah mempelajari materi Sistem Pencernaan sebelum mengerjakan kuis ini.',
                      style: TextStyle(
                        color: Colors.orange.shade800,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleQuestionsCard() {
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
                Icon(
                  Icons.question_answer,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Contoh Soal',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Show the first 3 questions as samples
            ...kuis!.questions.take(3).map((question) {
              final index = kuis!.questions.indexOf(question);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Soal ${index + 1}:',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(question, style: const TextStyle(height: 1.5)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.lock, size: 18, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Jawaban akan tersedia setelah Anda mengerjakan kuis',
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            Center(
              child: Text(
                'Dan ${kuis!.questions.length - 3} soal lainnya...',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBadge() {
    final score = kuis!.score ?? 0;
    Color scoreColor = score >= 80
        ? Colors.green
        : score >= 60
        ? Colors.orange
        : Colors.red;

    return Container(
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
            Text('Nilai', style: TextStyle(fontSize: 14, color: scoreColor)),
            Text(
              '$score',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: scoreColor,
              ),
            ),
          ],
        ),
      ),
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
          Expanded(
            child: CustomButton(
              label: 'Bagikan',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membagikan Kuis...')),
                );
              },
              backgroundColor: Colors.white,
              textColor: Theme.of(context).colorScheme.secondary,
              borderRadius: 8,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              label: kuis!.isCompleted ? 'Kerjakan Lagi' : 'Mulai Kuis',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Memulai Kuis...')),
                );
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              textColor: Colors.white,
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
