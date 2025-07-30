import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../services/sheets_service.dart';
import '../widgets/custom_button.dart';
import 'kuis_kerjakan_screen.dart';
import '../utils/utils.dart';

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
  bool _isSubmitting = false;

  // Multiple Choice Section
  Map<int, int?> multipleChoiceAnswers = {};

  // Text controllers for short answer questions
  List<TextEditingController> shortAnswerControllers = [];

  // Text controllers for essay questions
  List<TextEditingController> essayControllers = [];

  // Student info controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController classController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Setup controllers for answers
    _setupControllers();

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
      questions: [],
    );
    setState(() {
      isLoading = false;
    });
  }

  // Set up the controllers when the quiz data is loaded
  void _setupControllers() {
    // Initialize short answer controllers
    shortAnswerControllers.clear();
    for (int i = 0; i < 10; i++) {
      shortAnswerControllers.add(TextEditingController());
    }

    // Initialize essay controllers
    essayControllers.clear();
    for (int i = 0; i < 5; i++) {
      essayControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    classController.dispose();

    // Dispose all text controllers
    for (var controller in shortAnswerControllers) {
      controller.dispose();
    }
    for (var controller in essayControllers) {
      controller.dispose();
    }

    super.dispose();
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
                    const SizedBox(height: 16),

                    // Instructions and objectives
                    // _buildInstructionsCard(),
                    // const SizedBox(height: 24),

                    // Kuis Content Card
                    _buildKuisContentCard(),
                    const SizedBox(height: 24),

                    // Sample Questions
                    // _buildSampleQuestionsCard(),
                    // const SizedBox(height: 24),

                    // Strategy Card
                    _buildStrategyCard(),
                    const SizedBox(height: 24),

                    // Tips Card
                    _buildSuccessTipsCard(),
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
              Utils.formatDate(kuis!.createdAt),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic info section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informasi Kuis',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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

          // Kisi-kisi soal
          // Container(
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     color: Colors.grey.shade50,
          //     borderRadius: const BorderRadius.only(
          //       bottomLeft: Radius.circular(12),
          //       bottomRight: Radius.circular(12),
          //     ),
          //     border: Border(top: BorderSide(color: Colors.grey.shade300)),
          //   ),
          //   padding: const EdgeInsets.all(16),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         children: [
          //           Icon(
          //             Icons.assignment,
          //             color: Theme.of(context).colorScheme.secondary,
          //           ),
          //           const SizedBox(width: 8),
          //           Text(
          //             'Kisi-Kisi Soal',
          //             style: Theme.of(context).textTheme.titleMedium?.copyWith(
          //               fontWeight: FontWeight.bold,
          //               color: Theme.of(context).colorScheme.secondary,
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 16),

          //       // Table header
          //       Container(
          //         padding: const EdgeInsets.symmetric(
          //           vertical: 8,
          //           horizontal: 12,
          //         ),
          //         decoration: BoxDecoration(
          //           color: Theme.of(
          //             context,
          //           ).colorScheme.primary.withOpacity(0.1),
          //           borderRadius: const BorderRadius.only(
          //             topLeft: Radius.circular(8),
          //             topRight: Radius.circular(8),
          //           ),
          //         ),
          //         child: Row(
          //           children: [
          //             Expanded(
          //               flex: 3,
          //               child: Text(
          //                 'Tujuan Pembelajaran',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   color: Theme.of(context).colorScheme.primary,
          //                 ),
          //               ),
          //             ),
          //             Expanded(
          //               flex: 2,
          //               child: Text(
          //                 'Level Kognitif',
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   color: Theme.of(context).colorScheme.primary,
          //                 ),
          //               ),
          //             ),
          //             Expanded(
          //               flex: 1,
          //               child: Text(
          //                 'No. Soal',
          //                 textAlign: TextAlign.center,
          //                 style: TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                   color: Theme.of(context).colorScheme.primary,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),

          //       // Table rows
          //       _buildKisiKisiRow(
          //         'Mengurutkan organ dan proses sistem pencernaan',
          //         'C3 (Mengaplikasi)',
          //         '1-2',
          //       ),
          //       _buildKisiKisiRow(
          //         'Menjelaskan fungsi organ sistem pencernaan',
          //         'C2 (Memahami)',
          //         '3-5',
          //       ),
          //       _buildKisiKisiRow(
          //         'Menganalisis proses pencernaan',
          //         'C4 (Menganalisis)',
          //         '6-8',
          //       ),
          //       _buildKisiKisiRow(
          //         'Menyelesaikan masalah seputar gangguan pencernaan',
          //         'C4 (Menganalisis)',
          //         '9-10',
          //       ),
          //       _buildKisiKisiRow(
          //         'Mengaitkan gaya hidup dengan kesehatan pencernaan',
          //         'C4 (Menganalisis)',
          //         '11-12',
          //       ),
          //       _buildKisiKisiRow(
          //         'Membuat diagram atau infografis proses pencernaan',
          //         'C6 (Mencipta)',
          //         '13-15',
          //       ),

          //       const SizedBox(height: 16),

          //       // Bentuk soal legend
          //       Container(
          //         padding: const EdgeInsets.all(12),
          //         decoration: BoxDecoration(
          //           color: Colors.grey.shade100,
          //           borderRadius: BorderRadius.circular(8),
          //           border: Border.all(color: Colors.grey.shade300),
          //         ),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               'Bentuk Soal:',
          //               style: Theme.of(context).textTheme.titleSmall?.copyWith(
          //                 fontWeight: FontWeight.bold,
          //               ),
          //             ),
          //             const SizedBox(height: 8),
          //             Container(
          //               width: double.infinity,
          //               child: Wrap(
          //                 spacing: 16,
          //                 runSpacing: 8,
          //                 crossAxisAlignment: WrapCrossAlignment.center,
          //                 children: [
          //                   Row(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       _buildSoalTypeBadge('PG', Colors.blue),
          //                       const SizedBox(width: 8),
          //                       const Text('Pilihan Ganda'),
          //                     ],
          //                   ),
          //                   Row(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       _buildSoalTypeBadge('IS', Colors.orange),
          //                       const SizedBox(width: 8),
          //                       const Text('Isian Singkat'),
          //                     ],
          //                   ),
          //                   Row(
          //                     mainAxisSize: MainAxisSize.min,
          //                     children: [
          //                       _buildSoalTypeBadge('E', Colors.green),
          //                       const SizedBox(width: 8),
          //                       const Text('Esai'),
          //                     ],
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
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

  // Helper method for kisi-kisi table rows
  Widget _buildKisiKisiRow(
    String tujuan,
    String levelKognitif,
    String nomorSoal,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: Text(tujuan)),
          Expanded(flex: 2, child: Text(levelKognitif)),
          Expanded(
            flex: 1,
            child: Text(
              nomorSoal,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for soal type badges
  Widget _buildSoalTypeBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: color,
        ),
      ),
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

  // Success tips card
  Widget _buildSuccessTipsCard() {
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
                Icon(Icons.emoji_events, color: Colors.amber.shade700),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Kiat Sukses Mengerjakan Kuis',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.tips_and_updates,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sebelum Mulai:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Pelajari kembali materi sistem pencernaan\n'
                    '• Siapkan lingkungan yang tenang\n'
                    '• Pastikan perangkat dan koneksi internet stabil',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.psychology,
                        color: Colors.green.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Saat Mengerjakan:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '• Perhatikan level kognitif setiap soal\n'
                    '• Kerjakan soal dari yang mudah ke yang sulit\n'
                    '• Gunakan pengetahuan logika jika tidak yakin',
                    style: TextStyle(height: 1.5),
                  ),
                ],
              ),
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

            // Show the first 3 questions as samples with updated styling
            ...kuis!.questions.take(3).map((question) {
              final index = kuis!.questions.indexOf(question);
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.lock,
                                        size: 18,
                                        color: Colors.grey,
                                      ),
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
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),

            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Dan ${kuis!.questions.length - 3} soal lainnya...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
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
              backgroundColor: Theme.of(context).colorScheme.secondary,
              textColor: Colors.white,
              borderRadius: 8,
            ),
          ),
        ],
      ),
    );
  }
}
