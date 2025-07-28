import 'package:flutter/material.dart';
import '../repositories/repositories.dart';
import 'profile_edit_screen.dart';
import 'help_support_screen.dart';

enum ContentType { materi, kuis, lkpd }

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  // Calculate statistics from repositories
  int _getCompletedMateriCount() {
    return MateriRepository.instance.getCompletedMateri().length;
  }

  int _getCompletedKuisCount() {
    return KuisRepository.instance.getCompletedKuises().length;
  }

  int _getCompletedLkpdCount() {
    return LkpdRepository.instance.getCompletedLkpd().length;
  }

  Color _getScoreColor(int score) {
    if (score >= 80) {
      return Colors.green;
    } else if (score >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  double _calculateAverageScore() {
    final completedKuises = KuisRepository.instance.getCompletedKuises();
    final completedLkpds = LkpdRepository.instance.getCompletedLkpd();

    int totalScores = 0;
    int totalItems = 0;

    // Calculate for kuises
    for (final kuis in completedKuises) {
      if (kuis.score != null) {
        totalScores += kuis.score!;
        totalItems++;
      }
    }

    // Calculate for LKPDs
    for (final lkpd in completedLkpds) {
      if (lkpd.score != null) {
        totalScores += lkpd.score!;
        totalItems++;
      }
    }

    if (totalItems == 0) return 0;
    return totalScores / totalItems;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                Icons.person,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            // User Name
            Text(
              'Siswa EduKita',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'siswa@example.com',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Stats Card
            _buildStatsCard(context),
            const SizedBox(height: 24),

            // Menu Items
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context) {
    // Calculate real statistics
    final materiCount = _getCompletedMateriCount();
    final kuisCount = _getCompletedKuisCount() + _getCompletedLkpdCount();
    final averageScore = _calculateAverageScore();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(context, '$materiCount', 'Materi Selesai'),
            _buildDivider(),
            _buildStatItem(context, '$kuisCount', 'Kuis & LKPD Selesai'),
            _buildDivider(),
            _buildStatItem(
              context,
              averageScore > 0 ? '${averageScore.toStringAsFixed(0)}%' : '-',
              'Nilai Rata-rata',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.grey.shade300);
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.edit,
        'title': 'Edit Profil',
        'subtitle': 'Ubah data profil anda',
        'action': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
          );
        },
      },
      {
        'icon': Icons.school,
        'title': 'Progress Pembelajaran',
        'subtitle': 'Lihat kemajuan belajar anda',
        'action': () {
          _showProgressDialog(context);
        },
      },
      {
        'icon': Icons.star,
        'title': 'Prestasi',
        'subtitle': 'Lihat prestasi yang telah dicapai',
        'action': () {
          _showAchievementsDialog(context);
        },
      },
      // {
      //   'icon': Icons.settings,
      //   'title': 'Pengaturan',
      //   'subtitle': 'Atur preferensi aplikasi',
      //   'action': () {
      //     // TODO: Implement settings navigation
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Fitur Pengaturan belum tersedia')),
      //     );
      //   },
      // },
      {
        'icon': Icons.help_outline,
        'title': 'Bantuan',
        'subtitle': 'Pusat bantuan dan dukungan',
        'action': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
          );
        },
      },
    ];

    return Column(
      children: menuItems.map((item) {
        return _buildMenuItem(
          context,
          item['icon'] as IconData,
          item['title'] as String,
          item['subtitle'] as String,
          item['action'] as Function(),
        );
      }).toList(),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Function() onTap,
  ) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _showProgressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Progress Pembelajaran'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProgressSection(
                context,
                'Materi',
                _getCompletedByCategory(ContentType.materi),
              ),
              const Divider(),
              _buildProgressSection(
                context,
                'Kuis',
                _getCompletedByCategory(ContentType.kuis),
              ),
              const Divider(),
              _buildProgressSection(
                context,
                'LKPD',
                _getCompletedByCategory(ContentType.lkpd),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(
    BuildContext context,
    String title,
    Map<String, int> categoryData,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...categoryData.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(entry.key),
                Text(
                  '${entry.value}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }),
        if (categoryData.isEmpty) const Text('Belum ada yang diselesaikan'),
      ],
    );
  }

  Map<String, int> _getCompletedByCategory(ContentType type) {
    Map<String, int> result = {};

    switch (type) {
      case ContentType.materi:
        final completed = MateriRepository.instance.getCompletedMateri();
        for (final materi in completed) {
          result[materi.category] = (result[materi.category] ?? 0) + 1;
        }
        break;
      case ContentType.kuis:
        final completed = KuisRepository.instance.getCompletedKuises();
        for (final kuis in completed) {
          result[kuis.category] = (result[kuis.category] ?? 0) + 1;
        }
        break;
      case ContentType.lkpd:
        final completed = LkpdRepository.instance.getCompletedLkpd();
        for (final lkpd in completed) {
          result[lkpd.category] = (result[lkpd.category] ?? 0) + 1;
        }
        break;
    }

    return result;
  }

  void _showAchievementsDialog(BuildContext context) {
    // Get scores by category
    final categoryScores = _getScoresByCategory();
    final highestCategory = _getHighestScoreCategory(categoryScores);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Prestasi'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nilai Per Kategori',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...categoryScores.entries.map((entry) {
                return _buildScoreBar(
                  context,
                  entry.key,
                  entry.value,
                  entry.key == highestCategory,
                );
              }),
              if (categoryScores.isEmpty)
                const Text('Belum ada nilai yang tercatat'),

              const SizedBox(height: 24),

              if (highestCategory.isNotEmpty) ...[
                Text(
                  'Pencapaian',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildAchievementItem(
                  context,
                  'Kategori Terbaik',
                  highestCategory,
                  'Kategori dengan nilai rata-rata tertinggi',
                  Icons.emoji_events,
                  Colors.amber,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBar(
    BuildContext context,
    String category,
    double score,
    bool isHighest,
  ) {
    final color = _getScoreColor(score.round());

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: TextStyle(
                  fontWeight: isHighest ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                '${score.toStringAsFixed(0)}%',
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
    BuildContext context,
    String title,
    String value,
    String description,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 24,
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(
                    description,
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

  Map<String, double> _getScoresByCategory() {
    final Map<String, List<int>> scoresByCategory = {};

    // Get kuis scores by category
    final completedKuises = KuisRepository.instance.getCompletedKuises();
    for (final kuis in completedKuises) {
      if (kuis.score != null) {
        if (!scoresByCategory.containsKey(kuis.category)) {
          scoresByCategory[kuis.category] = [];
        }
        scoresByCategory[kuis.category]!.add(kuis.score!);
      }
    }

    // Get LKPD scores by category
    final completedLkpds = LkpdRepository.instance.getCompletedLkpd();
    for (final lkpd in completedLkpds) {
      if (lkpd.score != null) {
        if (!scoresByCategory.containsKey(lkpd.category)) {
          scoresByCategory[lkpd.category] = [];
        }
        scoresByCategory[lkpd.category]!.add(lkpd.score!);
      }
    }

    // Calculate average score for each category
    final Map<String, double> result = {};
    scoresByCategory.forEach((category, scores) {
      final sum = scores.fold(0, (sum, score) => sum + score);
      result[category] = sum / scores.length;
    });

    return result;
  }

  String _getHighestScoreCategory(Map<String, double> categoryScores) {
    if (categoryScores.isEmpty) return '';

    String highestCategory = categoryScores.keys.first;
    double highestScore = categoryScores.values.first;

    categoryScores.forEach((category, score) {
      if (score > highestScore) {
        highestCategory = category;
        highestScore = score;
      }
    });

    return highestCategory;
  }
}
