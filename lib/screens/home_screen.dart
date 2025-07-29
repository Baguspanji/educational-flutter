import 'package:gastrofun/screens/materi_single_screen.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../repositories/repositories.dart';
import '../models/content_models.dart';
import 'materi_screen.dart';
import 'profil_screen.dart';
import 'artikel_screen.dart';
import 'video_screen.dart';
import 'lkpd_screen.dart';
import 'lkpd_single_screen.dart';
import 'kuis_screen.dart';
import 'kuis_single_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialTab;

  const HomeScreen({super.key, this.initialTab = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
  }

  final List<Widget> _screens = [
    const HomeContentScreen(),
    // const MateriScreen(),
    const MateriSingleScreen(),
    // const VideoScreen(),
    const LkpdSingleScreen(),
    const KuisSingleScreen(),
    const ProfilScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Materi'),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.play_circle),
          //   label: 'Video',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_document),
            label: 'LKPD',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: 'Soal',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Info'),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'GastroFun';
      case 1:
        return 'Materi Belajar';
      case 2:
        return 'Lembaga Kegiatan Pembelajaran Digital';
      case 3:
        return 'Soal Evaluasi';
      case 4:
        return 'Info Pengembangan';
      default:
        return 'GastroFun';
    }
  }
}

// New class for home content
class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  // Helper method to build the section cards
  Widget _buildSectionCard(
    BuildContext context,
    String title,
    String subtitle,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    title == 'Tujuan Pembelajaran'
                        ? Container(
                            margin: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${index + 1}. ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.check_circle_outline,
                            color: color,
                            size: 18,
                          ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Welcome section
          // Text(
          //   'Selamat Datang di GastroFun',
          //   style: Theme.of(
          //     context,
          //   ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 8),
          // Text(
          //   'Platform belajar interaktif untuk semua kalangan',
          //   style: Theme.of(context).textTheme.bodyLarge,
          // ),
          // const SizedBox(height: 24),
          // Logo section
          Center(
            child: Image.asset(
              'assets/images/logo-unnes-horizontal.png',
              width: 200,
              height: 48,
              fit: BoxFit.fitWidth,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Sistem Pencernaan',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          // const SizedBox(height: 4),
          // Text(
          //   'Materi tentang sistem pencernaan manusia',
          //   style: Theme.of(context).textTheme.bodyLarge,
          // ),
          const SizedBox(height: 16),

          // Content Image Overview
          Image.asset(
            'assets/images/sistem-pencernaan-siluet.png',
            width: MediaQuery.of(context).size.width - 100,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(height: 24),

          // Capaian Pembelajaran Section
          _buildSectionCard(
            context,
            'Capaian Pembelajaran',
            'Setelah mempelajari materi ini, siswa dapat:',
            [
              'Merefleksikan sistem organ tubuh manusia yang dikaitkan dengan cara menjaga kesehatan tubuhnya.',
            ],
            Icons.stars,
            Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 20),

          // Tujuan Pembelajaran Section
          _buildSectionCard(
            context,
            'Tujuan Pembelajaran',
            'Pembelajaran ini bertujuan untuk:',
            [
              'Mengurutkan organ dan proses sistem pencernaan.',
              'Menjelaskan fungsi organ sistem pencernaan.',
              'Menganalisis proses pencernaan.',
              'Menyelesaikan masalah gangguan pencernaan.',
              'Mengaitkan gaya hidup dengan kesehatan pencernaan.',
              'Membuat diagram/infografis digital tentang proses pencernaan.',
            ],
            Icons.assignment_turned_in,
            Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 24),

          // Content Overview Cards
          // _buildContentOverview(context),
        ],
      ),
    );
  }
}

Widget _buildContentOverview(BuildContext context) {
  // Define the content types and their icons
  final contentTypes = [
    {
      'type': 'Materi',
      'icon': Icons.book_outlined,
      'color': Colors.blue.shade700,
      'description':
          'Materi pembelajaran terstruktur untuk berbagai mata pelajaran',
      'count': MateriRepository.instance.getAllMateri().length,
    },
    {
      'type': 'LKPD',
      'icon': Icons.edit_document,
      'color': Colors.green.shade600,
      'description': 'Latihan interaktif untuk mengaplikasikan pengetahuan',
      'count': LkpdRepository.instance.getAllLkpd().length,
    },
    {
      'type': 'Video',
      'icon': Icons.play_circle_outline,
      'color': Colors.red.shade600,
      'description': 'Video penjelasan untuk memperkuat pemahaman konsep',
      'count': VideoRepository.instance.getAllVideos().length,
    },
    {
      'type': 'Artikel',
      'icon': Icons.article_outlined,
      'color': Colors.purple.shade600,
      'description': 'Artikel terkini dan relevan untuk memperluas wawasan',
      'count': ArtikelRepository.instance.getAllArtikels().length,
    },
    {
      'type': 'Kuis',
      'icon': Icons.quiz_outlined,
      'color': Colors.orange.shade700,
      'description': 'Kuis interaktif untuk menguji pemahaman materi',
      'count': KuisRepository.instance.getAllKuises().length,
    },
  ];

  return ListView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: contentTypes.length,
    itemBuilder: (context, index) {
      final item = contentTypes[index];
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: _buildContentTypeCard(
          context,
          item['type'] as String,
          item['icon'] as IconData,
          item['color'] as Color,
          item['description'] as String,
          item['count'] as int,
        ),
      );
    },
  );
}

Widget _buildContentTypeCard(
  BuildContext context,
  String type,
  IconData icon,
  Color color,
  String description,
  int count,
) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: InkWell(
      onTap: () {
        // Use Navigator to reset the app with a specific tab selected
        if (type == 'Materi') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen(initialTab: 1), // Materi tab
            ),
            (route) => false,
          );
        } else if (type == 'LKPD') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LkpdScreen()),
          );
        } else if (type == 'Video') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen(initialTab: 2), // Video tab
            ),
            (route) => false,
          );
        } else if (type == 'Artikel') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen(initialTab: 3), // Artikel tab
            ),
            (route) => false,
          );
        } else if (type == 'Kuis') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const KuisScreen()),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withOpacity(0.2),
                  radius: 24,
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '$count item tersedia',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            const SizedBox(height: 12),
            Text(description, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            _buildLatestContentPreview(context, type),
          ],
        ),
      ),
    ),
  );
}

Widget _buildLatestContentPreview(BuildContext context, String type) {
  // Get the appropriate list items from repositories based on type
  List<Content> contentItems = [];

  switch (type) {
    case 'Materi':
      contentItems = MateriRepository.instance.getAllMateri();
      break;
    case 'LKPD':
      contentItems = LkpdRepository.instance.getAllLkpd();
      break;
    case 'Video':
      contentItems = VideoRepository.instance.getAllVideos();
      break;
    case 'Artikel':
      contentItems = ArtikelRepository.instance.getAllArtikels();
      break;
    case 'Kuis':
      contentItems = KuisRepository.instance.getAllKuises();
      break;
    default:
      break;
  }

  // Show only the first 2 latest items
  contentItems = contentItems.take(2).toList();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Terbaru:',
        style: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      ...contentItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Icon(Icons.circle, size: 8, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerRight,
        child: CustomButton(
          label: 'Lihat Semua',
          onPressed: () {
            if (type == 'LKPD') {
              // Use push for LKPD instead of tab switching
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LkpdScreen()),
              );
            } else if (type == 'Kuis') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const KuisScreen()),
              );
            } else {
              // For other types, change to the appropriate tab
              int targetTab = 0;
              if (type == 'Materi') {
                targetTab = 1;
              } else if (type == 'Video') {
                targetTab = 2;
              } else if (type == 'Artikel') {
                targetTab = 3;
              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(initialTab: targetTab),
                ),
                (route) => false,
              );
            }
            // For other types, we'd add similar tab switching logic
          },
          small: true,
        ),
      ),
    ],
  );
}
