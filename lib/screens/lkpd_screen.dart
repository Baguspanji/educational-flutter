import 'package:flutter/material.dart';
import 'package:gastrofun/utils/utils.dart';
import '../models/content_models.dart';
import '../widgets/custom_button.dart';
import '../widgets/lkpd/video_section.dart';
import '../widgets/lkpd/article_section.dart';

class LkpdScreen extends StatefulWidget {
  const LkpdScreen({super.key});

  @override
  State<LkpdScreen> createState() => _LkpdScreenState();
}

class _LkpdScreenState extends State<LkpdScreen> {
  late LKPD? lkpd;
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  // Text controllers for name and group inputs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _groupController = TextEditingController();

  // Text controllers for question inputs
  final TextEditingController _question1Controller = TextEditingController();
  final TextEditingController _question2Controller = TextEditingController();
  final TextEditingController _question3Controller = TextEditingController();
  final TextEditingController _question4Controller = TextEditingController();
  final TextEditingController _question5Controller = TextEditingController();
  final TextEditingController _question6Controller = TextEditingController();
  final TextEditingController _question8Controller = TextEditingController();
  final TextEditingController _question9Controller = TextEditingController();
  final TextEditingController _question10Controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Load the LKPD data
    _loadLkpd();

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
    _nameController.dispose();
    _groupController.dispose();

    // Dispose question controllers
    _question1Controller.dispose();
    _question2Controller.dispose();
    _question3Controller.dispose();
    _question4Controller.dispose();
    _question5Controller.dispose();
    _question6Controller.dispose();
    _question8Controller.dispose();
    _question9Controller.dispose();
    _question10Controller.dispose();

    super.dispose();
  }

  void _loadLkpd() {
    // In a real app, this would be an async operation
    lkpd = LKPD(
      id: 'lkpd-001',
      title: 'LKPD - Sistem Pencernaan Manusia',
      category: 'Biologi',
      createdAt: DateTime(2025, 7, 10),
      description:
          'Lembar Kerja untuk memahami sistem pencernaan manusia dan fungsinya',
      isCompleted: false,
      estimatedTimeMinutes: 45,
      questionCount: 10,
      type: 'Penerapan Konsep',
      objectives: [
        'Mengurutkan organ dan proses sistem pencernaan.',
        'Menjelaskan fungsi organ sistem pencernaan.',
        'Menganalisis proses pencernaan.',
        'Menyelesaikan masalah gangguan pencernaan.',
        'Mengaitkan gaya hidup dengan kesehatan pencernaan.',
        'Membuat diagram/infografis digital tentang proses pencernaan.',
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

    if (lkpd == null) {
      return const Center(child: Text('LKPD tidak ditemukan'));
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
                    _buildInstructionsCard(),
                    const SizedBox(height: 24),

                    // Student information inputs
                    _buildStudentInfoInputs(),
                    const SizedBox(height: 24),

                    // Section "Orientasi Masalah (Kasus Nyata)"
                    _buildSectionHeader(
                      'Langkah 1 – Orientasi Masalah (Kasus Nyata)',
                      context,
                    ),
                    const SizedBox(height: 16),

                    // Video Section
                    _buildVideoSection(),
                    const SizedBox(height: 24),

                    // Article Section
                    _buildArticleSection(),
                    const SizedBox(height: 24),

                    // HOTS Section
                    _buildHotsSection(),
                    const SizedBox(height: 24),

                    // Section "Orientasi Masalah (Kasus Nyata)"
                    _buildSectionHeader(
                      'Langkah 2 – Mengorganisasi Informasi',
                      context,
                    ),
                    const SizedBox(height: 16),

                    // Organisasi Informasi Content
                    _buildOrganisasiInformasiSection(),
                    const SizedBox(height: 24),

                    // Section "Orientasi Masalah (Kasus Nyata)"
                    _buildSectionHeader(
                      'Langkah 3 – Investigasi Mandiri / Kelompok',
                      context,
                    ),
                    const SizedBox(height: 16),

                    // Investigasi Mandiri / Kelompok Content
                    _buildInvestigasiSection(),
                    const SizedBox(height: 24),

                    // Section "Orientasi Masalah (Kasus Nyata)"
                    _buildSectionHeader(
                      'Langkah 4 – Membuat Produk (Infografis)',
                      context,
                    ),
                    const SizedBox(height: 16),

                    _buildProdukSection(),
                    const SizedBox(height: 24),

                    // Section "Orientasi Masalah (Kasus Nyata)"
                    _buildSectionHeader('Langkah 5 – Refleksi', context),
                    const SizedBox(height: 16),

                    // Refleksi Content
                    _buildRefleksiSection(),
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
        // Title and description
        Text(
          lkpd!.title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(lkpd!.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),

        // Metadata row
        Row(
          children: [
            _buildMetadataItem(
              context,
              Icons.access_time,
              '${lkpd!.estimatedTimeMinutes} menit',
            ),
            const SizedBox(width: 16),
            _buildMetadataItem(
              context,
              Icons.timer,
              '${lkpd!.questionCount} soal',
            ),
            const SizedBox(width: 16),
            _buildMetadataItem(
              context,
              Icons.calendar_today,
              Utils.formatDate(lkpd!.createdAt),
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

  // Helper method to build answer text field with controller
  Widget _buildAnswerTextField(
    TextEditingController controller, {
    int maxLines = 4,
    String hintText = 'Ketik jawaban Anda di sini...',
    EdgeInsets contentPadding = const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: contentPadding,
        ),
      ),
    );
  }

  Widget _buildOrganisasiInformasiSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tugas 1: Urutkan Organ Sistem Pencernaan
            Text(
              'Tugas 1: Urutkan Organ Sistem Pencernaan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Table for organ ordering
            Table(
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: [
                    _buildTableCell('No', isHeader: true),
                    _buildTableCell('Organ Pencernaan', isHeader: true),
                    _buildTableCell('Urutan (1–7)', isHeader: true),
                  ],
                ),
                // Data rows
                _buildOrganRow('a', 'Lambung'),
                _buildOrganRow('b', 'Usus Halus'),
                _buildOrganRow('c', 'Rongga Mulut'),
                _buildOrganRow('d', 'Rektum'),
                _buildOrganRow('e', 'Kerongkongan'),
                _buildOrganRow('f', 'Usus Besar'),
                _buildOrganRow('g', 'Anus'),
              ],
            ),

            const SizedBox(height: 24),

            // Tugas 2: Fungsi Tiap Organ
            Text(
              'Tugas 2: Fungsi Tiap Organ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),

            // Table for organ functions
            Table(
              border: TableBorder.all(color: Colors.grey.shade300, width: 1),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(4),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header row
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: [
                    _buildTableCell('Organ', isHeader: true),
                    _buildTableCell('Fungsi', isHeader: true),
                  ],
                ),
                // Data rows
                _buildFunctionRow('Rongga Mulut'),
                _buildFunctionRow('Kerongkongan'),
                _buildFunctionRow('Lambung'),
                _buildFunctionRow('Usus Halus'),
                _buildFunctionRow('Usus Besar'),
                _buildFunctionRow('Rektum'),
                _buildFunctionRow('Anus'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods for table cells
  Widget _buildTableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: isHeader ? TextAlign.center : TextAlign.left,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  TableRow _buildOrganRow(String number, String organName) {
    return TableRow(
      children: [
        _buildTableCell(number),
        _buildTableCell(organName),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildFunctionRow(String organName) {
    return TableRow(
      children: [
        _buildTableCell(organName),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInstructionsCard() {
    return Padding(
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
            '1. Pelajari Orientasi Masalah (Kasus Nyata) yang telah disediakan.',
            style: TextStyle(height: 1.5),
          ),
          const Text(
            '2. Jawablah pertanyaan sesuai dengan pemahaman Anda.',
            style: TextStyle(height: 1.5),
          ),
          const Text(
            '3. Waktu pengerjaan sesuai dengan yang telah ditentukan.',
            style: TextStyle(height: 1.5),
          ),
          const Text(
            '4. Kerjakan secara mandiri untuk hasil yang optimal.',
            style: TextStyle(height: 1.5),
          ),

          const SizedBox(height: 16),
          Text(
            'Tujuan Pembelajaran:',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...lkpd!.objectives.map((objective) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(objective, style: const TextStyle(height: 1.5)),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHotsSection() {
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
                  Icons.psychology,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pertanyaan HOTS – Pemahaman & Analisis Awal',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Question 1
            Text(
              '1. Jelaskan secara mendalam apa persamaan dan perbedaan kedua kasus tersebut, terutama dari sisi penyebab, dampak, dan penanganannya.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnswerTextField(_question1Controller),
            const SizedBox(height: 16),

            // Question 2
            Text(
              '2. Apakah menurutmu sumber video dan artikel berita tersebut bisa dipercaya? Jelaskan bagaimana kamu menilai keakuratan dan kebenaran informasi dari media digital.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnswerTextField(_question2Controller),
            const SizedBox(height: 16),

            // Question 3
            Text(
              '3. Buatlah daftar kemungkinan kesalahan manusia dalam dua kasus tersebut yang menyebabkan keracunan makanan. Tambahkan solusi pencegahan untuk tiap penyebab.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnswerTextField(_question3Controller),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleSection() {
    return ArticleSection(
      title: 'Keracunan Makan Bergizi Gratis di PALI, 173 Siswa Terkena',
      source: 'Kompas.id',
      description:
          'Baca artikel ini untuk memahami kasus keracunan makanan yang terjadi karena tempe dan air terkontaminasi bakteri.',
      articleUrl:
          'https://www.kompas.id/artikel/jadikan-pelajaran-keracunan-mbg-di-pali-karena-tempe-dan-air-terkontaminasi-bakteri',
    );
  }

  Widget _buildVideoSection() {
    return VideoSection(
      title: 'Belasan Siswa Keracunan Makanan di Bogor',
      description:
          'Video ini menjelaskan kasus keracunan makanan yang terjadi di Bogor, yang relevan dengan materi sistem pencernaan manusia.',
      thumbnailUrl: 'https://img.youtube.com/vi/vHRWgpjzpPo/0.jpg',
      videoUrl: 'https://www.youtube.com/watch?v=vHRWgpjzpPo',
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
          // Expanded(
          //   child: CustomButton(
          //     label: 'Bagikan',
          //     onPressed: () {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(content: Text('Membagikan LKPD...')),
          //       );
          //     },
          //     backgroundColor: Colors.white,
          //     textColor: Theme.of(context).colorScheme.secondary,
          //     borderRadius: 8,
          //   ),
          // ),
          // const SizedBox(width: 16),
          Expanded(
            child: CustomButton(
              label: lkpd!.isCompleted ? 'Kerjakan Lagi' : 'Kerjakan',
              onPressed: () {
                // Navigate to LKPD kerjakan screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mengerjakan LKPD...')),
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

  // Section header method
  Widget _buildSectionHeader(String title, BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 2),
        ),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  // Let's create the _buildInvestigasiSection method for Step 3
  Widget _buildInvestigasiSection() {
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
                  Icons.search,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Investigasi Mandiri / Kelompok',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Question 4
            Text(
              '4. Tentukan dan jelaskan bagian sistem pencernaan yang pertama terganggu saat seseorang mengalami keracunan makanan. Jelaskan alasanmu menggunakan informasi digital.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnswerTextField(_question4Controller),
            const SizedBox(height: 16),

            // Question 5
            Text(
              '5. Buatlah rancangan penelitian sederhana untuk menguji kualitas makanan yang aman.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnswerTextField(_question5Controller),
            const SizedBox(height: 16),

            // Question 6
            Text(
              '6. Bagaimana kebiasaan digital sehari-hari, seperti membeli makanan online atau jajan sambil main gadget, dapat berpengaruh pada kesehatan sistem pencernaan?',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnswerTextField(_question6Controller),
          ],
        ),
      ),
    );
  }

  // Now let's create the _buildProdukSection method for Step 4
  Widget _buildProdukSection() {
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
                Icon(Icons.brush, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Membuat Produk (Infografis)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Question 7
            Text(
              '7. Rancang infografis digital yang tidak hanya menunjukkan urutan organ pencernaan, tetapi juga menunjukkan risiko gangguan akibat gaya hidup buruk. Sertakan data dan ajakan.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.apps, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  const Text(
                    'Gunakan aplikasi: Canva',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              height: 120,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.upload_file,
                    size: 32,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unggah infografis Anda di sini',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Format: JPG, PNG atau PDF (maks. 5MB)',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build student info inputs (Nama and Kelompok)
  Widget _buildStudentInfoInputs() {
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
                  Icons.person,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Identitas Siswa',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Nama input field
            Text(
              'Nama',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama lengkap',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Kelompok input field (optional)
            Text(
              'Kelompok (Opsional)',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _groupController,
              decoration: InputDecoration(
                hintText: 'Masukkan nama kelompok jika ada',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Finally, let's create the _buildRefleksiSection method for Step 5
  Widget _buildRefleksiSection() {
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
                  Icons.psychology_alt,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Refleksi',
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

            // Question 8
            Text(
              '8. Apa pelajaran paling penting yang kamu dapat dari mempelajari dua kasus ini dan kaitannya dengan sistem pencernaan?',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnswerTextField(_question8Controller),
            const SizedBox(height: 16),

            // Question 9
            Text(
              '9. Bagaimana seharusnya kamu bersikap saat menerima informasi kesehatan dari internet? Berikan satu contoh nyata.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnswerTextField(_question9Controller),
            const SizedBox(height: 16),

            // Question 10
            Text(
              '10. Jika kamu ditugaskan untuk membuat sekolah lebih sehat, apa tiga langkah nyata yang akan kamu usulkan agar kasus seperti ini tidak terjadi di sekolahmu?',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAnswerTextField(_question10Controller),
          ],
        ),
      ),
    );
  }
}
