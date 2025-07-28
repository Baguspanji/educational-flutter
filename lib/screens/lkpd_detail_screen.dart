import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';
import 'kerjakan_screen.dart';

class LkpdDetailScreen extends StatefulWidget {
  final LKPD lkpd;

  const LkpdDetailScreen({super.key, required this.lkpd});

  @override
  State<LkpdDetailScreen> createState() => _LkpdDetailScreenState();
}

class _LkpdDetailScreenState extends State<LkpdDetailScreen> {
  late bool _isCompleted;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.lkpd.isCompleted;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lkpd.category),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Fitur berbagi belum tersedia')),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  widget.lkpd.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Metadata Row
                Row(
                  children: [
                    _buildMetadataPill(
                      context,
                      widget.lkpd.type,
                      Icons.format_list_bulleted,
                      Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    _buildMetadataPill(
                      context,
                      '${widget.lkpd.estimatedTimeMinutes} menit',
                      Icons.timer,
                      Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    _buildMetadataPill(
                      context,
                      '${widget.lkpd.questionCount} soal',
                      Icons.question_answer,
                      Colors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description
                Text(
                  'Deskripsi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.lkpd.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),

                // Content Card
                _buildLkpdContentCard(),
                const SizedBox(height: 24),

                // Mark as completed button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: _isCompleted
                        ? 'Selesai Dikerjakan'
                        : 'Tandai Selesai Dikerjakan',
                    onPressed: () {
                      setState(() {
                        _isCompleted = !_isCompleted;
                        // Note: In a real app, we would update this in a database
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isCompleted
                                ? 'LKPD ditandai sebagai selesai'
                                : 'LKPD ditandai sebagai belum selesai',
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    backgroundColor: _isCompleted
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 24),

                // Related LKPD section
                Text(
                  'LKPD Terkait',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRelatedLkpd(),
              ],
            ),
          ),

          // Back to top button
          if (_showBackToTop)
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.arrow_upward),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KerjakanScreen(lkpd: widget.lkpd),
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label: const Text('Kerjakan'),
        icon: const Icon(Icons.edit_document),
      ),
    );
  }

  Widget _buildMetadataPill(
    BuildContext context,
    String text,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLkpdContentCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Informasi LKPD',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Jenis', widget.lkpd.type),
            const Divider(),
            _buildInfoRow('Jumlah Soal', '${widget.lkpd.questionCount} soal'),
            const Divider(),
            _buildInfoRow('Waktu', '${widget.lkpd.estimatedTimeMinutes} menit'),
            const Divider(),
            _buildInfoRow(
              'Tanggal Dibuat',
              '${widget.lkpd.createdAt.day}/${widget.lkpd.createdAt.month}/${widget.lkpd.createdAt.year}',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.orange),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Pastikan untuk membaca petunjuk pengerjaan sebelum mulai',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildRelatedLkpd() {
    // Get related LKPD based on category
    final relatedLkpds = LkpdRepository.instance
        .getLkpdByCategory(widget.lkpd.category)
        .where((l) => l.id != widget.lkpd.id)
        .toList();

    if (relatedLkpds.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text('Tidak ada LKPD terkait')),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: relatedLkpds.length > 3 ? 3 : relatedLkpds.length,
      itemBuilder: (context, index) {
        final lkpd = relatedLkpds[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 4,
            ),
            title: Text(
              lkpd.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Row(
              children: [
                Icon(
                  Icons.format_list_bulleted,
                  size: 12,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  lkpd.type,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(width: 8),
                Icon(Icons.timer, size: 12, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '${lkpd.estimatedTimeMinutes} min',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LkpdDetailScreen(lkpd: lkpd),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
