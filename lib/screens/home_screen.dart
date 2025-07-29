import 'package:gastrofun/screens/materi_single_screen.dart';
import 'package:flutter/material.dart';
import 'lkpd_single_screen.dart';
import 'kuis_single_screen.dart';
import 'info_screen.dart';

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
    const MateriSingleScreen(),
    const LkpdSingleScreen(),
    const KuisSingleScreen(),
    const InfoScreen(),
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
        return 'Lembar Kerja Peserta Didik';
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
        ],
      ),
    );
  }
}
