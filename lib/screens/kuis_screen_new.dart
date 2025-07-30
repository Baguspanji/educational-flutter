import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../widgets/custom_button.dart';
import 'kuis_kerjakan_screen.dart';

class KuisScreen extends StatefulWidget {
  const KuisScreen({super.key});

  @override
  State<KuisScreen> createState() => _KuisScreenState();
}

class _KuisScreenState extends State<KuisScreen> {
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
      title: 'Kuis Formatif Sistem Pencernaan Kelas V',
      category: 'IPAS',
      createdAt: DateTime(2023, 7, 15),
      description:
          'Kuis ini mencakup materi sistem pencernaan manusia dengan berbagai level kognitif dari C2 hingga C6',
      isCompleted: false,
      questionCount: 18,
      timeInMinutes: 45,
      questions: [
        // Tujuan 1: Mengurutkan organ dan proses sistem pencernaan
        'Urutkanlah organ-organ sistem pencernaan manusia mulai dari mulut hingga anus!',
        'Susunlah organ pencernaan manusia berikut sesuai urutan proses pencernaan: usus halus, mulut, anus, lambung, kerongkongan, usus besar!',
        // Tujuan 2: Menjelaskan fungsi organ
        'Jelaskan fungsi utama dari rongga mulut dalam proses pencernaan makanan!',
        'Apa fungsi dari lambung dalam proses pencernaan makanan?',
      ],
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Kuis')),
      body: Stack(
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
                      const SizedBox(height: 16),

                      // Instructions and objectives
                      _buildInstructionsCard(),
                      const SizedBox(height: 24),

                      // Strategy Card
                      _buildStrategyCard(),
                      const SizedBox(height: 24),
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
            color: Colors.teal.shade700.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            kuis!.category,
            style: TextStyle(
              color: Colors.teal.shade700,
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
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

  // Helper method for objective items
  Widget _buildObjectiveItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(height: 1.5))),
        ],
      ),
    );
  }

  // Strategy section card
  Widget _buildStrategyCard() {
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
                  Icons.lightbulb_outline,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Strategi Menjawab Soal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildStrategyItem(
              'Pilihan Ganda:',
              '• Baca pertanyaan dengan teliti\n'
                  '• Eliminasi jawaban yang jelas salah\n'
                  '• Jangan terlalu lama di satu soal\n'
                  '• Kembali ke soal yang sulit jika waktu mencukupi',
            ),
            const SizedBox(height: 12),

            _buildStrategyItem(
              'Soal Isian Singkat:',
              '• Tulis jawaban dengan singkat dan jelas\n'
                  '• Perhatikan ejaan dan istilah ilmiah yang tepat\n'
                  '• Fokus pada kata kunci yang ditanyakan',
            ),
            const SizedBox(height: 12),

            _buildStrategyItem(
              'Soal Esai:',
              '• Pahami kata kunci dalam pertanyaan\n'
                  '• Gunakan poin-poin untuk menjawab\n'
                  '• Berikan contoh konkret jika memungkinkan\n'
                  '• Kaitkan jawaban dengan konsep sistem pencernaan',
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for strategy items
  Widget _buildStrategyItem(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        const SizedBox(height: 8),
        Text(content, style: const TextStyle(height: 1.5)),
      ],
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
                  'Petunjuk & Tujuan',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              'Petunjuk Pengerjaan:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const Text(
              '1. Kuis ini terdiri dari soal pilihan ganda, isian singkat, dan esai.',
              style: TextStyle(height: 1.5),
            ),
            const Text(
              '2. Setiap soal memiliki bobot nilai sesuai dengan level kognitif.',
              style: TextStyle(height: 1.5),
            ),
            const Text(
              '3. Kerjakan soal dalam waktu yang telah ditentukan (45 menit).',
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
            const Divider(),
            const SizedBox(height: 16),

            Text(
              'Tujuan Pembelajaran:',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildObjectiveItem(
              'Mengurutkan organ dan proses sistem pencernaan manusia',
            ),
            _buildObjectiveItem('Menjelaskan fungsi organ sistem pencernaan'),
            _buildObjectiveItem(
              'Menganalisis proses pencernaan secara mekanik dan kimiawi',
            ),
            _buildObjectiveItem(
              'Menyelesaikan masalah seputar gangguan pencernaan',
            ),
            _buildObjectiveItem(
              'Mengaitkan gaya hidup dengan kesehatan pencernaan',
            ),
            _buildObjectiveItem(
              'Membuat diagram atau infografis proses pencernaan',
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
              label: kuis!.isCompleted ? 'Kerjakan Lagi' : 'Mulai Kuis',
              onPressed: () async {
                // Navigate to the interactive quiz screen
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KuisKerjakanScreen(kuis: kuis!),
                  ),
                );

                // Update kuis if we got a result back
                if (result != null && result is Kuis) {
                  setState(() {
                    kuis = result;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
