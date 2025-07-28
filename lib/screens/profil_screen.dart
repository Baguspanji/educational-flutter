import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

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
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(context, '12', 'Materi Selesai'),
            _buildDivider(),
            _buildStatItem(context, '8', 'Kuis Selesai'),
            _buildDivider(),
            _buildStatItem(context, '85%', 'Nilai Rata-rata'),
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
            MaterialPageRoute(builder: (context) => const EditProfileScreen()),
          );
        },
      },
      {
        'icon': Icons.school,
        'title': 'Progress Pembelajaran',
        'subtitle': 'Lihat kemajuan belajar anda',
        'action': () {
          // TODO: Implement learning progress navigation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Fitur Progress Pembelajaran belum tersedia'),
            ),
          );
        },
      },
      {
        'icon': Icons.star,
        'title': 'Prestasi',
        'subtitle': 'Lihat prestasi yang telah dicapai',
        'action': () {
          // TODO: Implement achievements navigation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur Prestasi belum tersedia')),
          );
        },
      },
      {
        'icon': Icons.settings,
        'title': 'Pengaturan',
        'subtitle': 'Atur preferensi aplikasi',
        'action': () {
          // TODO: Implement settings navigation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur Pengaturan belum tersedia')),
          );
        },
      },
      {
        'icon': Icons.help_outline,
        'title': 'Bantuan',
        'subtitle': 'Pusat bantuan dan dukungan',
        'action': () {
          // TODO: Implement help center navigation
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur Bantuan belum tersedia')),
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
}
