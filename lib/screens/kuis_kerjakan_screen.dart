import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../services/sheets_service.dart';
import '../widgets/custom_button.dart';

class KuisKerjakanScreen extends StatefulWidget {
  final Kuis kuis;

  const KuisKerjakanScreen({Key? key, required this.kuis}) : super(key: key);

  @override
  State<KuisKerjakanScreen> createState() => _KuisKerjakanScreenState();
}

class _KuisKerjakanScreenState extends State<KuisKerjakanScreen> {
  late Kuis kuis;
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
  final TextEditingController groupController = TextEditingController();

  @override
  void initState() {
    super.initState();
    kuis = widget.kuis;

    // Setup controllers for answers
    _setupControllers();

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

    // Dispose all text controllers
    nameController.dispose();
    groupController.dispose();

    for (var controller in shortAnswerControllers) {
      controller.dispose();
    }

    for (var controller in essayControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  // Set up the controllers for the quiz answers
  void _setupControllers() {
    // Initialize short answer controllers
    shortAnswerControllers = List.generate(5, (_) => TextEditingController());

    // Initialize essay controllers
    essayControllers = List.generate(3, (_) => TextEditingController());

    // Initialize multiple choice answers
    multipleChoiceAnswers = {};
  }

  // Method untuk menyimpan jawaban kuis
  Future<void> _submitQuiz() async {
    setState(() {
      _isSubmitting = true;
    });

    final name = nameController.text.trim();
    final group = groupController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama harus diisi')));
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    try {
      // Prepare multiple choice answers
      Map<String, String> mcAnswers = {};
      multipleChoiceAnswers.forEach((index, answer) {
        mcAnswers['mc${index + 1}'] = answer?.toString() ?? '';
      });

      // Prepare short answers
      Map<String, String> saAnswers = {};
      for (int i = 0; i < shortAnswerControllers.length; i++) {
        saAnswers['sa${i + 1}'] = shortAnswerControllers[i].text;
      }

      // Prepare essay answers
      Map<String, String> essayAnswers = {};
      for (int i = 0; i < essayControllers.length; i++) {
        essayAnswers['essay${i + 1}'] = essayControllers[i].text;
      }

      // Calculate score (simplified - in reality would use answer key)
      // For this example, just count non-empty answers as a basic scoring method
      int totalAnswered = 0;
      multipleChoiceAnswers.values.forEach((answer) {
        if (answer != null) totalAnswered++;
      });

      for (var controller in shortAnswerControllers) {
        if (controller.text.isNotEmpty) totalAnswered++;
      }

      for (var controller in essayControllers) {
        if (controller.text.isNotEmpty) totalAnswered++;
      }

      // Simple score calculation (just for demonstration)
      double totalScore = (totalAnswered / 18) * 100;

      // Submit to Google Sheets
      final success = await SheetsService.submitKuis(
        name: name,
        group: group,
        multipleChoiceAnswers: mcAnswers,
        shortAnswers: saAnswers,
        essayAnswers: essayAnswers,
        totalScore: totalScore,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Soal berhasil dikerjakan')),
        );

        // Update kuis status
        setState(() {
          kuis = Kuis(
            id: kuis.id,
            title: kuis.title,
            category: kuis.category,
            createdAt: kuis.createdAt,
            description: kuis.description,
            questionCount: kuis.questionCount,
            timeInMinutes: kuis.timeInMinutes,
            questions: kuis.questions,
            isCompleted: true,
            score: totalScore.toInt(),
            completedAt: DateTime.now(),
          );
        });

        // Navigate back after successful submission
        Navigator.of(context).pop(kuis);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal mengerjakan soal')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(kuis.title)),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quiz description
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kuis.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(kuis.description),
                        const SizedBox(height: 8),
                        Text('Waktu: ${kuis.timeInMinutes} menit'),
                        Text('Jumlah Soal: ${kuis.questionCount}'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Student Information
                  const Text(
                    'Informasi Siswa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: groupController,
                    decoration: const InputDecoration(
                      labelText: 'Kelompok (Opsional)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Multiple Choice Questions
                  const Text(
                    'Soal Pilihan Ganda',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Question 1
                  _buildMultipleChoiceQuestion(
                    index: 0,
                    question:
                        '1. Organ yang berperan dalam proses pencernaan mekanik pertama kali adalah...',
                    options: ['Mulut', 'Kerongkongan', 'Lambung', 'Usus Halus'],
                  ),

                  // Question 2
                  _buildMultipleChoiceQuestion(
                    index: 1,
                    question:
                        '2. Enzim yang berperan dalam mencerna karbohidrat di mulut adalah...',
                    options: ['Amilase', 'Pepsin', 'Lipase', 'Tripsin'],
                  ),

                  // Question 3
                  _buildMultipleChoiceQuestion(
                    index: 2,
                    question:
                        '3. Usus halus memiliki lipatan-lipatan yang disebut...',
                    options: ['Vili', 'Jonjot', 'Plika', 'Rugae'],
                  ),

                  // Question 4
                  _buildMultipleChoiceQuestion(
                    index: 3,
                    question:
                        '4. Pencernaan kimiawi lemak terutama terjadi di...',
                    options: ['Usus halus', 'Lambung', 'Mulut', 'Kerongkongan'],
                  ),

                  // Question 5 (with asset image)
                  _buildMultipleChoiceQuestion(
                    index: 4,
                    question:
                        '5. Perhatikan gambar sistem pencernaan berikut ini.\n{image}\nBagian yang ditandai dengan X adalah organ dimana proses penyerapan air terutama terjadi. Organ tersebut adalah...',
                    options: [
                      'Usus besar',
                      'Usus halus',
                      'Lambung',
                      'Kerongkongan',
                    ],
                    imageAsset: 'assets/images/soal-1.png',
                    // imageCaption: 'Gambar 1. Sistem pencernaan manusia.',
                  ),

                  // Question 6
                  _buildMultipleChoiceQuestion(
                    index: 5,
                    question:
                        '6. Makanan yang dicerna di mulut akan masuk ke lambung melalui...',
                    options: [
                      'Kerongkongan',
                      'Tenggorokan',
                      'Usus halus',
                      'Kardiak',
                    ],
                  ),

                  // Question 7
                  _buildMultipleChoiceQuestion(
                    index: 6,
                    question:
                        '7. Bagian akhir dari sistem pencernaan adalah...',
                    options: ['Anus', 'Rektum', 'Usus besar', 'Usus halus'],
                  ),

                  // Question 8 (with image)
                  _buildMultipleChoiceQuestion(
                    index: 7,
                    question:
                        'Perhatikan gambar sistem pencernaan berikut ini.\n{image}\nJika bagian yang ditandai dengan huruf A rusak atau tidak berfungsi, apa akibatnya bagi keseluruhan proses pencernaan?',
                    options: [
                      'Pencernaan lemak terganggu karena cairan empedu tidak dapat diproduksi',
                      'Penyerapan air terganggu sehingga terjadi diare',
                      'Pencernaan karbohidrat tidak bisa dimulai karena tidak ada enzim amilase',
                      'Makanan tidak dapat masuk ke lambung',
                    ],
                    imageUrl:
                        'https://sistem.bio/wp-content/uploads/2019/12/sistem-pencernaan-manusia.png',
                    imageCaption:
                        'Gambar 2. Organ hati (A) dalam sistem pencernaan manusia.',
                  ),

                  // Question 9
                  _buildMultipleChoiceQuestion(
                    index: 8,
                    question:
                        '9. Gangguan pencernaan berupa peradangan pada dinding lambung disebut...',
                    options: ['Gastritis', 'Diare', 'Konstipasi', 'Maag'],
                  ),

                  // Question 10
                  _buildMultipleChoiceQuestion(
                    index: 9,
                    question:
                        '10. Vitamin yang diserap di usus halus dengan bantuan empedu adalah...',
                    options: [
                      'Vitamin A',
                      'Vitamin C',
                      'Vitamin B',
                      'Vitamin B12',
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Short Answer Questions
                  const Text(
                    'Soal Isian Singkat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Short Answer 1
                  _buildShortAnswerQuestion(
                    index: 0,
                    question:
                        '1. Sebutkan urutan organ pencernaan manusia dari mulut hingga anus!',
                  ),

                  // Short Answer 2
                  _buildShortAnswerQuestion(
                    index: 1,
                    question: '2. Jelaskan fungsi utama dari lambung!',
                  ),

                  // Short Answer 3
                  _buildShortAnswerQuestion(
                    index: 2,
                    question:
                        '3. Apa fungsi utama dari usus halus dalam proses pencernaan?',
                  ),

                  // Short Answer 4
                  _buildShortAnswerQuestion(
                    index: 3,
                    question: '4. Sebutkan 2 enzim pencernaan dan fungsinya!',
                  ),

                  // Short Answer 5
                  _buildShortAnswerQuestion(
                    index: 4,
                    question:
                        '5. Apa perbedaan antara pencernaan mekanik dan kimiawi?',
                  ),

                  const SizedBox(height: 24),

                  // Essay Questions
                  const Text(
                    'Soal Esai',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  // Essay 1
                  _buildEssayQuestion(
                    index: 0,
                    question:
                        '1. Bagaimana proses pencernaan karbohidrat terjadi dari awal hingga akhir? Jelaskan enzim yang terlibat!',
                  ),

                  // Essay 2
                  _buildEssayQuestion(
                    index: 1,
                    question:
                        '2. Jelaskan hubungan antara pola makan sehat dengan kesehatan sistem pencernaan!',
                  ),

                  // Essay 3
                  _buildEssayQuestion(
                    index: 2,
                    question:
                        '3. Mengapa mengonsumsi makanan yang terkontaminasi bakteri dapat menyebabkan diare? Jelaskan mekanismenya!',
                  ),

                  const SizedBox(height: 24),

                  // Submit button
                  Center(
                    child: CustomButton(
                      label: _isSubmitting ? 'Menyimpan...' : 'Kirim Jawaban',
                      onPressed: _isSubmitting ? () {} : () => _submitQuiz(),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          if (_showBackToTop)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.arrow_upward),
              ),
            ),
        ],
      ),
    );
  }

  // Widget untuk soal pilihan ganda
  Widget _buildMultipleChoiceQuestion({
    required int index,
    required String question,
    required List<String> options,
    String? imageUrl,
    String? imageAsset,
    String? imageCaption,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question text might be before image
          if (!question.contains("{image}"))
            Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),

          // If there's an image (either from URL or assets), add it
          if (imageUrl != null || imageAsset != null) ...[
            const SizedBox(height: 12),
            // If question contains {image} placeholder, split and insert image at that point
            if (question.contains("{image}")) ...[
              Text(
                question.split("{image}")[0].trim(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
            ],

            // Image with container for better visual
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageAsset != null
                    ? Image.asset(
                        imageAsset,
                        fit: BoxFit.contain,
                        height: 200,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(height: 8),
                                Text(
                                  'Gambar tidak ditemukan: $imageAsset',
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Image.network(
                        imageUrl!,
                        fit: BoxFit.contain,
                        height: 200,
                        width: double.infinity,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                const SizedBox(height: 8),
                                Text(
                                  'Gambar tidak dapat dimuat: ${error.toString()}',
                                  style: const TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            // Image caption if provided
            if (imageCaption != null) ...[
              const SizedBox(height: 8),
              Text(
                imageCaption,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // If question contains {image} placeholder, show the rest of the text after the image
            if (question.contains("{image}")) ...[
              const SizedBox(height: 12),
              Text(
                question.split("{image}")[1].trim(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ],

          const SizedBox(height: 12),
          ...List.generate(options.length, (optionIndex) {
            return RadioListTile<int>(
              title: Text(options[optionIndex]),
              value: optionIndex,
              groupValue: multipleChoiceAnswers[index],
              onChanged: (value) {
                setState(() {
                  multipleChoiceAnswers[index] = value;
                });
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }

  // Widget untuk soal isian singkat
  Widget _buildShortAnswerQuestion({
    required int index,
    required String question,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          TextField(
            controller: shortAnswerControllers[index],
            decoration: const InputDecoration(
              hintText: 'Jawaban Anda',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  // Widget untuk soal esai
  Widget _buildEssayQuestion({required int index, required String question}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          TextField(
            controller: essayControllers[index],
            decoration: const InputDecoration(
              hintText: 'Jawaban Anda',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
