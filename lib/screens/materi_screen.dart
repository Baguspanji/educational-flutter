import 'package:flutter/material.dart';
import 'package:gastrofun/utils/utils.dart';
import '../models/content_models.dart';
import '../models/chapter_content_model.dart';
import '../data/digestive_system_content.dart';
import '../widgets/custom_button.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
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
    materi = Materi(
      id: 'bio-001',
      title: 'Sistem Pencernaan',
      category: 'Biologi',
      createdAt: DateTime(2025, 7, 10),
      description: 'Memahami Sistem Pencernaan Manusia dan Fungsinya',
      chapters: [
        'Cover Materi - Sistem Pencernaan',
        'Apa itu Sistem Pencernaan?',
        'Jenis-Jenis Pencernaan',
        'Organ-Organ dalam Sistem Pencernaan',
        'Gangguan pada Sistem Pencernaan',
        'Menjaga Kesehatan Sistem Pencernaan',
        'Kesimpulan',
        'Daftar Pustaka',
      ],
    );
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
      return const Center(child: CircularProgressIndicator());
    }

    if (materi == null) {
      return const Center(child: Text('Materi tidak ditemukan'));
    }

    return Column(
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
                const SizedBox(height: 16),

                // Chapter navigation
                _buildChapterNav(context),
                const SizedBox(height: 16),

                // Chapter content
                _buildChapterContent(context),
              ],
            ),
          ),
        ),

        // Bottom navigation
        _buildBottomNav(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              Icons.library_books,
              '${materi!.chapters.length} Bagian',
            ),
            const SizedBox(width: 16),
            _buildMetadataItem(
              context,
              Icons.calendar_today,
              Utils.formatDate(materi!.createdAt),
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
              'Bagian ${currentChapterIndex + 1} dari ${materi!.chapters.length}',
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
              tooltip: 'Daftar Bagian',
            ),
          ],
        ),
        // const SizedBox(height: 8),

        // Current chapter title
        // Container(
        //   padding: const EdgeInsets.all(12),
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(8),
        //   ),
        //   child: Text(
        //     materi!.chapters[currentChapterIndex],
        //     style: Theme.of(
        //       context,
        //     ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        //   ),
        // ),
      ],
    );
  }

  void _showChaptersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Daftar Bagian',
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
                      controller: scrollController,
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
      },
    );
  }

  Widget _buildChapterContent(BuildContext context) {
    // Get the actual content for this chapter from our data model
    final chapterContent = DigestiveSystemContent.chapters[currentChapterIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          chapterContent.title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 20),

        // Loop through all sections in this chapter
        ...chapterContent.sections.map((section) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section subtitle if available
              if (section.subtitle != null) ...[
                const SizedBox(height: 16),
                Text(
                  section.subtitle!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
              ],

              // Loop through all content blocks in this section
              ...section.blocks.map((block) {
                switch (block.type) {
                  case BlockType.bulletPoint:
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 8),
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                block.text,
                                style: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.copyWith(height: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                  case BlockType.numberPoint:
                    // Handle numbered points
                    return Container();

                  case BlockType.heading:
                    return Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                      child: Text(
                        block.text,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    );

                  case BlockType.subheading:
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 6.0),
                      child: Text(
                        block.text,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    );

                  case BlockType.note:
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 12.0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              block.text,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    );

                  case BlockType.image:
                    // Display the image using the path stored in the text field
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              block.text,
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ),
                    );

                  case BlockType.paragraph:
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        block.text,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.6),
                      ),
                    );
                }
              }).toList(),

              // Add some spacing between sections
              const SizedBox(height: 16),
            ],
          );
        }).toList(),

        // PDF Material Section - only show on last chapter
        // if (currentChapterIndex == materi!.chapters.length - 1) ...[
        //   const SizedBox(height: 24),
        //   _buildPdfMaterialSection(context),
        // ],
        // const SizedBox(height: 32),
        // Add some space at the bottom for better scrolling
        const SizedBox(height: 60),
      ],
    );
  }

  Widget _buildPdfMaterialSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_file_rounded,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Materi Tambahan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.red.shade700,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Materi Ajar Sistem Pencernaan.pdf',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dokumen PDF tentang sistem pencernaan manusia',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '2.4 MB',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: '👁️ Lihat PDF',
                  onPressed: () {
                    _openPdfViewer(context);
                  },
                  backgroundColor: Colors.white,
                  textColor: Theme.of(context).colorScheme.secondary,
                  borderRadius: 8,
                  small: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  label: '⬇️ Unduh PDF',
                  onPressed: () {
                    _downloadPdf(context);
                  },
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  textColor: Colors.white,
                  borderRadius: 8,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openPdfViewer(BuildContext context) {
    // Show a dialog indicating this would open a PDF viewer in a real app
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buka PDF Viewer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.picture_as_pdf, size: 48, color: Colors.red.shade700),
            const SizedBox(height: 16),
            const Text(
              'Di aplikasi sebenarnya, ini akan membuka PDF viewer untuk menampilkan file "Materi Ajar Sistem Pencernaan.pdf" yang tersimpan di assets/files/',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _downloadPdf(BuildContext context) {
    // Show a dialog indicating this would download the PDF in a real app
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unduh PDF'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.download_done_rounded,
              size: 48,
              color: Colors.green.shade600,
            ),
            const SizedBox(height: 16),
            const Text(
              'Di aplikasi sebenarnya, ini akan mengunduh file "Materi Ajar Sistem Pencernaan.pdf" ke perangkat pengguna.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Tutup'),
          ),
        ],
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
                  // Mark as completed and show completion message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Selamat! Anda telah menyelesaikan materi ini.',
                      ),
                    ),
                  );
                  // Reset to first chapter instead of popping navigation
                  setState(() {
                    currentChapterIndex = 0;
                  });
                }
              },
              borderRadius: 8,
            ),
          ),
        ],
      ),
    );
  }
}
