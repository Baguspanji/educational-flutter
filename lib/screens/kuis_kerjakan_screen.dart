import 'dart:async';
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
  bool _submitAttempted = false;
  bool _isNameEmpty = false;

  // Timer properties
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isTimeExpired = false;

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
    // Initialize short answer controllers for 10 questions
    shortAnswerControllers = List.generate(10, (_) => TextEditingController());

    // Initialize essay controllers for 5 questions
    essayControllers = List.generate(5, (_) => TextEditingController());

    // Initialize multiple choice answers
    multipleChoiceAnswers = {};
  }

  // Method untuk menyimpan jawaban kuis
  Future<void> _submitQuiz() async {
    // Set flag that submission was attempted (for showing red borders)
    setState(() {
      _submitAttempted = true;
    });

    final name = nameController.text.trim();
    final group = groupController.text.trim();

    // Check if name is empty
    bool isNameEmpty = name.isEmpty;
    if (isNameEmpty) {
      setState(() {
        _isNameEmpty = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Count empty questions by type
    int emptyMultipleChoiceCount = 0;
    int emptyShortAnswerCount = 0;
    int emptyEssayCount = 0;

    // Check multiple choice answers
    for (int i = 0; i < 15; i++) {
      if (multipleChoiceAnswers[i] == null) {
        emptyMultipleChoiceCount++;
      }
    }

    // Check short answer questions
    for (var controller in shortAnswerControllers) {
      if (controller.text.trim().isEmpty) {
        emptyShortAnswerCount++;
      }
    }

    // Check essay questions
    for (var controller in essayControllers) {
      if (controller.text.trim().isEmpty) {
        emptyEssayCount++;
      }
    }

    // Total empty questions
    int totalEmptyQuestions =
        emptyMultipleChoiceCount + emptyShortAnswerCount + emptyEssayCount;

    // If there are empty questions, show confirmation dialog
    if (totalEmptyQuestions > 0) {
      bool? confirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi Pengiriman'),
            content: Text(
              'Apakah anda yakin mengirim Jawaban?\n\n'
              'Terdapat $emptyMultipleChoiceCount pilihan ganda, '
              '$emptyShortAnswerCount isian singkat, dan '
              '$emptyEssayCount esai masih belum diisi!',
              style: const TextStyle(height: 1.5),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Kirim'),
              ),
            ],
          );
        },
      );

      // If user cancels, stop submission
      if (confirm != true) {
        return;
      }
    }

    // If we reach here, proceed with submission
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Prepare multiple choice answers
      Map<String, String> mcAnswers = {};
      multipleChoiceAnswers.forEach((index, answer) {
        // Convert numeric answers to letters: 0=A, 1=B, 2=C, 3=D
        String letterAnswer = '';
        if (answer != null) {
          letterAnswer = String.fromCharCode('A'.codeUnitAt(0) + answer);
        }
        mcAnswers['mc${index + 1}'] = letterAnswer;
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
      double totalScore =
          (totalAnswered / 30) * 100; // 15 MC + 10 short answers + 5 essays

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
                  const SizedBox(height: 4),
                  Text(
                    '* Nama wajib diisi',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    onChanged: (value) {
                      // Reset error state when user starts typing
                      if (_isNameEmpty && value.trim().isNotEmpty) {
                        setState(() {
                          _isNameEmpty = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _isNameEmpty
                              ? Colors.red
                              : Colors.grey.shade400,
                          width: _isNameEmpty ? 2.0 : 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: _isNameEmpty
                              ? Colors.red
                              : Theme.of(context).primaryColor,
                          width: 2.0,
                        ),
                      ),
                      errorText: _isNameEmpty
                          ? 'Nama tidak boleh kosong'
                          : null,
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
                        '1. Saat mengikuti praktik IPA, Sari menggambar urutan sistem pencernaan. Namun, ia menggambar lambung sebelum kerongkongan. Jika kamu membantunya mengurutkan kembali organ dengan benar dari awal makanan masuk hingga keluar, urutan yang tepat adalah...',
                    options: [
                      'Mulut – Lambung – Kerongkongan – Usus Halus – Usus Besar – Anus',
                      'Mulut – Kerongkongan – Lambung – Usus Halus – Usus Besar – Anus',
                      'Kerongkongan – Mulut – Usus Halus – Lambung – Anus',
                      'Mulut – Usus Halus – Lambung – Usus Besar – Anus',
                    ],
                  ),

                  // Question 2
                  _buildMultipleChoiceQuestion(
                    index: 1,
                    question:
                        '2. Seorang siswa menggambarkan sistem pencernaan dengan urutan: Mulut → Lambung → Usus Halus → Usus Besar → Anus. Ia lupa satu organ penting dalam proses tersebut. Organ yang hilang dalam urutan tersebut adalah...',
                    options: ['Hati', 'Pankreas', 'Kerongkongan', 'Ginjal'],
                  ),

                  // Question 3
                  _buildMultipleChoiceQuestion(
                    index: 2,
                    question:
                        '3. Saat kita mengunyah makanan, air liur dikeluarkan dan bercampur dengan makanan untuk memulai proses kimiawi. Apa fungsi utama mulut dalam proses pencernaan?',
                    options: [
                      'Menghasilkan energi',
                      'Menyerap nutrisi',
                      'Menghancurkan makanan dan mencampurnya dengan enzim',
                      'Mengolah makanan menjadi feses',
                    ],
                  ),

                  // Question 4
                  _buildMultipleChoiceQuestion(
                    index: 3,
                    question:
                        '4. Dalam lambung, makanan dicerna secara kimiawi dengan bantuan enzim dan asam lambung. Fungsi utama lambung adalah...',
                    options: [
                      'Menyerap vitamin',
                      'Mengubah air menjadi energi',
                      'Menguraikan makanan menggunakan zat kimia',
                      'Menyimpan air',
                    ],
                  ),

                  // Question 5
                  _buildMultipleChoiceQuestion(
                    index: 4,
                    question:
                        '5. Setelah makanan melalui lambung, zat gizi mulai diserap oleh tubuh. Organ yang paling banyak menyerap nutrisi tersebut adalah...',
                    options: ['Kerongkongan', 'Usus halus', 'Mulut', 'Hati'],
                  ),

                  // Question 6
                  _buildMultipleChoiceQuestion(
                    index: 5,
                    question:
                        '6. Roti terasa manis saat dikunyah dalam waktu lama. Hal ini terjadi karena...',
                    options: [
                      'Enzim di usus mengubah tepung menjadi garam',
                      'Proses mekanik menghancurkan gula',
                      'Air liur mengubah zat tepung menjadi gula sederhana',
                      'Lambung menghasilkan rasa manis',
                    ],
                  ),

                  // Question 7
                  _buildMultipleChoiceQuestion(
                    index: 6,
                    question:
                        '7. Jika tubuh tidak memproduksi enzim di lambung dan usus halus, maka...',
                    options: [
                      'Proses pembuangan akan terganggu',
                      'Zat gizi tidak akan terserap dengan baik',
                      'Air tidak dapat masuk ke dalam tubuh',
                      'Makanan langsung berubah menjadi energi',
                    ],
                  ),

                  // Question 8
                  _buildMultipleChoiceQuestion(
                    index: 7,
                    question:
                        '8. Air liur dan asam lambung memiliki fungsi berbeda. Apa perbedaan utama proses pencernaan yang terjadi di mulut dan di lambung?',
                    options: [
                      'Di mulut makanan hanya ditelan, di lambung dikunyah',
                      'Di mulut terjadi pencernaan mekanik saja, di lambung tidak',
                      'Di mulut ada proses mekanik dan kimiawi awal, di lambung terjadi pencernaan kimiawi lanjutan',
                      'Di mulut zat gizi diserap, di lambung zat dibuang',
                    ],
                  ),

                  // Question 9
                  _buildMultipleChoiceQuestion(
                    index: 8,
                    question:
                        '9. Seorang anak mengalami diare setelah jajan sembarangan di depan sekolah. Menurut analisismu, penyebab dari gangguan tersebut kemungkinan besar adalah...',
                    options: [
                      'Makanan berserat tinggi',
                      'Konsumsi sayur segar',
                      'Kebersihan makanan yang buruk dan masuknya bakteri',
                      'Porsi makan yang terlalu kecil',
                    ],
                  ),

                  // Question 10
                  _buildMultipleChoiceQuestion(
                    index: 9,
                    question:
                        '10. Andi mengalami perut kembung dan sulit buang air besar. Setelah dianalisis, kebiasaannya adalah makan cepat dan tidak suka minum air. Solusi yang tepat untuk masalah Andi adalah...',
                    options: [
                      'Menghindari aktivitas fisik',
                      'Mengurangi waktu makan',
                      'Menambahkan porsi daging',
                      'Memperbanyak sayur, air, dan makan perlahan',
                    ],
                  ),

                  // Question 11
                  _buildMultipleChoiceQuestion(
                    index: 10,
                    question:
                        '11. Siska sangat menyukai makanan cepat saji, jarang mengonsumsi sayur, dan hampir tidak pernah minum air putih. Jika kebiasaan ini dibiarkan terus, apa risiko jangka panjang terhadap sistem pencernaannya?',
                    options: [
                      'Sistem pencernaan akan menjadi lebih cepat bekerja',
                      'Pencernaan jadi lebih kuat terhadap infeksi',
                      'Siska bisa mengalami gangguan seperti sembelit dan radang lambung',
                      'Tubuh akan menyerap lebih banyak vitamin',
                    ],
                  ),

                  // Question 12
                  _buildMultipleChoiceQuestion(
                    index: 11,
                    question:
                        '12. Bayangkan kamu memiliki dua teman: satu rajin makan buah dan sayur, satu lagi hanya makan mie instan. Dari sisi pencernaan, perbedaan paling mencolok antara keduanya adalah...',
                    options: [
                      'Teman yang makan buah akan sering sakit',
                      'Teman yang makan mie instan akan punya pencernaan lebih kuat',
                      'Teman yang makan sehat akan memiliki sistem pencernaan lebih lancar',
                      'Tidak ada perbedaan yang berarti',
                    ],
                  ),

                  // Question 13 (with asset image)
                  _buildMultipleChoiceQuestion(
                    index: 12,
                    question:
                        '13. Perhatikan gambar sistem pencernaan berikut ini.\n{image}\nJika bagian yang ditandai rusak atau tidak berfungsi, apa akibatnya bagi keseluruhan proses pencernaan?',
                    options: [
                      'Pencernaan makanan tetap normal',
                      'Penyerapan nutrisi menjadi lebih cepat',
                      'Makanan tidak dapat dicerna secara kimiawi dan berisiko membusuk',
                      'Organ lain akan menghasilkan feses langsung',
                    ],
                    imageAsset: 'assets/images/soal-1.png',
                  ),

                  // Question 14
                  _buildMultipleChoiceQuestion(
                    index: 13,
                    question:
                        '14. Kamu melihat poster sistem pencernaan yang tidak mencantumkan usus besar. Informasi penting apa yang hilang dari poster tersebut?',
                    options: [
                      'Fungsi pencernaan karbohidrat',
                      'Proses penghancuran lemak',
                      'Penyerapan air dan pembentukan feses',
                      'Proses mengunyah makanan',
                    ],
                  ),

                  // Question 15
                  _buildMultipleChoiceQuestion(
                    index: 14,
                    question:
                        '15. Sebuah infografis menampilkan urutan sistem pencernaan dengan salah posisi: Usus besar ditempatkan sebelum usus halus. Bagaimana kamu memperbaiki urutan tersebut agar sesuai fungsi tiap organ?',
                    options: [
                      'Tempatkan anus di awal karena buang sisa makanan',
                      'Letakkan usus halus setelah lambung dan sebelum usus besar',
                      'Pindahkan lambung ke akhir sistem',
                      'Tambahkan ginjal ke dalam urutan pencernaan',
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
                        '1. Seorang dokter kecil menjelaskan bahwa makanan akan melalui serangkaian organ sebelum keluar dari tubuh. Jika proses pencernaan terganggu di salah satu organ tersebut, seluruh sistem bisa terpengaruh. Tulislah urutan organ yang dilalui makanan mulai dari saat dikunyah hingga dikeluarkan dari tubuh.',
                  ),

                  // Short Answer 2
                  _buildShortAnswerQuestion(
                    index: 1,
                    question:
                        '2. Bayangkan kamu sedang mengikuti lomba menggambar sistem pencernaan. Namun, gambar temanmu tidak mencantumkan bagian usus besar. Apa fungsi bagian yang hilang tersebut dalam proses pencernaan?',
                  ),

                  // Short Answer 3
                  _buildShortAnswerQuestion(
                    index: 2,
                    question:
                        '3. Setelah mengonsumsi makanan cepat saji selama beberapa hari berturut-turut, Riko mulai merasa perutnya tidak nyaman dan susah buang air besar. Menurutmu, apa penyebab dari gangguan tersebut dan bagaimana cara mengatasinya?',
                  ),

                  // Short Answer 4 (with image)
                  _buildShortAnswerQuestion(
                    index: 3,
                    question:
                        '4. Amati gambar sistem pencernaan manusia berikut:\n{image}\nBerdasarkan gambar tersebut, tuliskan dua organ yang berperan penting dalam penyerapan zat gizi dan jelaskan alasannya.',
                    imageAsset: 'assets/images/soal-2.png',
                  ),

                  // Short Answer 5
                  _buildShortAnswerQuestion(
                    index: 4,
                    question:
                        '5. Selama pelajaran IPAS, guru menjelaskan bahwa gaya hidup sangat memengaruhi sistem pencernaan. Tulis satu contoh kebiasaan sehari-hari yang dapat merusak sistem pencernaan dan jelaskan mengapa hal itu berbahaya bagi kesehatan.',
                  ),

                  // Short Answer 6
                  _buildShortAnswerQuestion(
                    index: 5,
                    question:
                        '6. Banyak orang menganggap bahwa makanan langsung menjadi energi setelah dimakan. Jelaskan mengapa anggapan tersebut tidak sepenuhnya benar dengan mengaitkan proses pencernaan!',
                  ),

                  // Short Answer 7
                  _buildShortAnswerQuestion(
                    index: 6,
                    question:
                        '7. Dalam perjalanan makanan dari mulut hingga anus, setiap organ memiliki peran berbeda. Tulislah satu contoh dampak yang bisa terjadi jika lambung tidak berfungsi sebagaimana mestinya.',
                  ),

                  // Short Answer 8
                  _buildShortAnswerQuestion(
                    index: 7,
                    question:
                        '8. Kamu ditugaskan untuk membuat infografis tentang sistem pencernaan. Informasi apa saja yang wajib kamu cantumkan agar infografismu mudah dipahami dan akurat?',
                  ),

                  // Short Answer 9
                  _buildShortAnswerQuestion(
                    index: 8,
                    question:
                        '9. Saat kamu sakit perut karena jajan sembarangan, tubuh memberikan sinyal berupa rasa tidak nyaman. Mengapa penting bagi kita untuk memperhatikan sinyal dari tubuh seperti itu?',
                  ),

                  // Short Answer 10
                  _buildShortAnswerQuestion(
                    index: 9,
                    question:
                        '10. Seorang peneliti menemukan bahwa banyak siswa tidak tahu perbedaan antara usus halus dan usus besar. Tuliskan satu perbedaan utama antara keduanya dan mengapa itu penting dipahami sejak dini.',
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
                        '1. Jelaskan peran penting mulut, lambung, dan usus halus dalam proses pencernaan makanan. Buatlah narasi yang menggambarkan bagaimana makanan berubah mulai dari saat masuk ke mulut hingga zat gizinya diserap oleh tubuh.',
                  ),

                  // Essay 2 (with image)
                  _buildEssayQuestion(
                    index: 1,
                    question:
                        '2. Perhatikan gambar sistem pencernaan di bawah ini:\n{image}\nJika salah satu organ yang ditunjukkan pada gambar mengalami gangguan, bagaimana dampaknya terhadap keseluruhan proses pencernaan dan kesehatan tubuh?',
                    imageAsset: 'assets/images/soal-3.png',
                  ),

                  // Essay 3
                  _buildEssayQuestion(
                    index: 2,
                    question:
                        '3. Seorang anak memiliki kebiasaan makan sambil bermain gadget dan menunda buang air besar meskipun sudah merasa ingin. Berdasarkan kebiasaan tersebut, analisis dampaknya terhadap sistem pencernaan dan berikan saran perbaikannya.',
                  ),

                  // Essay 4
                  _buildEssayQuestion(
                    index: 3,
                    question:
                        '4. Dalam kegiatan Proyek P5, kamu diminta menyusun kampanye hidup sehat bertema "Cintai Sistem Pencernaanmu!". Tulislah rencana kampanye yang berisi pesan-pesan edukatif, kebiasaan baik, dan cara menyampaikan pesan tersebut kepada teman-teman sekolahmu.',
                  ),

                  // Essay 5
                  _buildEssayQuestion(
                    index: 4,
                    question:
                        '5. Buatlah sebuah infografis sederhana atau uraian berbentuk paragraf tentang proses pencernaan manusia, mulai dari makanan masuk ke mulut hingga keluar melalui anus. Jelaskan fungsi masing-masing organ serta keterkaitan antara satu organ dengan lainnya secara sistematis.',
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
    // Check if this question is unanswered
    bool isUnanswered =
        _submitAttempted && (multipleChoiceAnswers[index] == null);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: isUnanswered ? 2.0 : 1.0,
        ),
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
              activeColor: Theme.of(context).primaryColor,
            );
          }),

          // Add a hint if question is unanswered after submission attempt
          if (isUnanswered)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Soal belum dijawab',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Widget untuk soal isian singkat
  Widget _buildShortAnswerQuestion({
    required int index,
    required String question,
    String? imageUrl,
    String? imageAsset,
    String? imageCaption,
  }) {
    // Check if this question is unanswered
    bool isUnanswered =
        _submitAttempted && shortAnswerControllers[index].text.trim().isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: isUnanswered ? 2.0 : 1.0,
        ),
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
          TextField(
            controller: shortAnswerControllers[index],
            decoration: InputDecoration(
              hintText: 'Jawaban Anda',
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      _submitAttempted &&
                          shortAnswerControllers[index].text.trim().isEmpty
                      ? Colors.red.withOpacity(0.7)
                      : Colors.grey.shade400,
                  width:
                      _submitAttempted &&
                          shortAnswerControllers[index].text.trim().isEmpty
                      ? 2.0
                      : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      _submitAttempted &&
                          shortAnswerControllers[index].text.trim().isEmpty
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            maxLines: 3,
            onChanged: (value) {
              // Force rebuild if user fixes an empty field
              if (_submitAttempted && value.trim().isNotEmpty) {
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk soal esai
  Widget _buildEssayQuestion({
    required int index,
    required String question,
    String? imageUrl,
    String? imageAsset,
    String? imageCaption,
  }) {
    // Check if this question is unanswered
    bool isUnanswered =
        _submitAttempted && essayControllers[index].text.trim().isEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300,
          width: isUnanswered ? 2.0 : 1.0,
        ),
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
          TextField(
            controller: essayControllers[index],
            decoration: InputDecoration(
              hintText: 'Jawaban Anda',
              border: OutlineInputBorder(),
              counterText: '',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      _submitAttempted &&
                          essayControllers[index].text.trim().isEmpty
                      ? Colors.red.withOpacity(0.7)
                      : Colors.grey.shade400,
                  width:
                      _submitAttempted &&
                          essayControllers[index].text.trim().isEmpty
                      ? 2.0
                      : 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color:
                      _submitAttempted &&
                          essayControllers[index].text.trim().isEmpty
                      ? Colors.red
                      : Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
            ),
            maxLines: 8,
            maxLength: 2000,
            onChanged: (value) {
              // Force rebuild if user fixes an empty field
              if (_submitAttempted && value.trim().isNotEmpty) {
                setState(() {});
              }
            },
          ),
        ],
      ),
    );
  }
}
