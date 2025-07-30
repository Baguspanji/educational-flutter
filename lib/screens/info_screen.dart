import 'package:flutter/material.dart';
import 'help_support_screen.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Logo and Version
          _buildAppHeader(context),
          const SizedBox(height: 24),

          // About GastroFun Section
          _buildAboutSection(context),
          const SizedBox(height: 24),

          // Developer Information
          _buildDeveloperInfo(context),
          const SizedBox(height: 24),

          // References Section
          // _buildReferencesSection(context),
          // const SizedBox(height: 24),

          // Help and Support Card
          // _buildHelpSupportCard(context),
          // const SizedBox(height: 32),

          // Copyright and Credits
          _buildFooter(context),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                'assets/images/logo.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            'GastroFun',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Center(
          child: Text(
            'Versi 1.0.0',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Chip(
            label: const Text('Aplikasi Pembelajaran Sistem Pencernaan'),
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.1),
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context) {
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
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tentang GastroFun',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'GastroFun adalah aplikasi pembelajaran interaktif yang dirancang untuk membantu siswa memahami sistem pencernaan manusia dengan cara yang menarik dan mudah dipahami.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Aplikasi ini menyediakan materi pembelajaran, lembar kerja peserta didik (LKPD), dan soal evaluasi untuk mendukung proses pembelajaran tentang sistem pencernaan manusia.',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 12),
            const Text(
              'Dikembangkan sebagai bagian dari penelitian untuk meningkatkan efektivitas pembelajaran IPAS, khususnya pada topik sistem pencernaan manusia.',
              style: TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeveloperInfo(BuildContext context) {
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
                  Icons.person_outline,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pengembang',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Developer Photo and Name
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 80,
                    height: 100,
                    child: Image.asset(
                      'assets/images/lisa-profile.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lisa Meidya, S. Pd.',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mahasiswa Program Magister Pendidikan Dasar',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Universitas Negeri Semarang',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Advisor info
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Dosen Pembimbing:',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildAdvisorInfo(
              context,
              'Prof. Dr. Sri Haryani, M.Si.',
              'Pembimbing I',
            ),
            const SizedBox(height: 12),
            _buildAdvisorInfo(
              context,
              'Prof. Dr. Nanik Wijayati, M.Si.',
              'Pembimbing II',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisorInfo(BuildContext context, String name, String role) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.school, size: 20, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(
                role,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.copyright, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '2025 GastroFun',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Dikembangkan sebagai bagian dari penelitian tesis',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
          Text(
            'Program Magister Pendidikan Dasar Universitas Negeri Semarang',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
