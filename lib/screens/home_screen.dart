import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../repositories/repositories.dart';
import '../models/content_models.dart';
import 'materi_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeContentScreen(),
    const MateriScreen(),
    const _PlaceholderScreen(title: 'Video'),
    const _PlaceholderScreen(title: 'Artikel'),
    const _PlaceholderScreen(title: 'Profil'),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle),
            label: 'Video',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Artikel'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_currentIndex) {
      case 0:
        return 'EduKita';
      case 1:
        return 'Materi Belajar';
      case 2:
        return 'Video Pembelajaran';
      case 3:
        return 'Artikel Terkait';
      case 4:
        return 'Profil';
      default:
        return 'EduKita';
    }
  }
}

// New class for home content
class HomeContentScreen extends StatelessWidget {
  const HomeContentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome section
          Text(
            'Selamat Datang di EduKita',
            style: Theme.of(
              context,
            ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Platform belajar interaktif untuk semua kalangan',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),

          // Content Overview Cards
          _buildContentOverview(context),
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
        // Handle navigation to content-specific screen
        if (type == 'Materi') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MateriScreen()),
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
            // Change to the appropriate tab instead of pushing a new screen
            if (type == 'Materi') {
              // Find the closest HomeScreen ancestor
              final HomeScreen? homeScreen = context
                  .findAncestorWidgetOfExactType<HomeScreen>();
              if (homeScreen != null) {
                // Change the tab index to Materi (index 1) using the Navigator
                final navigator = Navigator.of(context);
                // Find the HomeScreen and update it
                final scaffoldMessenger = ScaffoldMessenger.of(context);

                // Use this approach to find the parent HomeScreen and update its state
                final HomeScreen? homeScreen = context
                    .findAncestorWidgetOfExactType<HomeScreen>();
                if (homeScreen != null) {
                  // Use the Navigator to pop back to the HomeScreen and then update it
                  navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                      settings: const RouteSettings(name: 'MateriTab'),
                    ),
                    (route) => false,
                  );
                } else {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Cannot navigate to Materi tab'),
                    ),
                  );
                }
              }
            }
            // For other types, we'd add similar tab switching logic
          },
          small: true,
        ),
      ),
    ],
  );
}

// Create a simple placeholder screen for other tabs
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getIconForTitle(),
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            '$title Screen',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTitle() {
    switch (title) {
      case 'Video':
        return Icons.play_circle_outline;
      case 'Artikel':
        return Icons.article_outlined;
      case 'Profil':
        return Icons.person_outline;
      default:
        return Icons.question_mark;
    }
  }
}
