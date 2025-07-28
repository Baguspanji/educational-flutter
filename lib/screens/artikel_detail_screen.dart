import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';

class ArtikelDetailScreen extends StatefulWidget {
  final Artikel artikel;

  const ArtikelDetailScreen({super.key, required this.artikel});

  @override
  State<ArtikelDetailScreen> createState() => _ArtikelDetailScreenState();
}

class _ArtikelDetailScreenState extends State<ArtikelDetailScreen> {
  // Using local state to track bookmark and completion status
  // since we can't modify final fields in the model
  late bool _isBookmarked;
  late bool _isCompleted;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _isBookmarked = widget.artikel.isBookmarked;
    _isCompleted = widget.artikel.isCompleted;

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
        title: Text(widget.artikel.category),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: _isBookmarked ? Colors.amber : Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isBookmarked = !_isBookmarked;
                // Note: In a real app, we would update this in a database or state management system
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isBookmarked
                        ? 'Artikel ditambahkan ke bookmark'
                        : 'Artikel dihapus dari bookmark',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
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
                  widget.artikel.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Metadata Row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey.shade300,
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.artikel.author,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${widget.artikel.createdAt.day}/${widget.artikel.createdAt.month}/${widget.artikel.createdAt.year}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.watch_later_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.artikel.readTimeMinutes} menit membaca',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Description (as subtitle/intro)
                Text(
                  widget.artikel.description,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 16),

                // Content
                Text(
                  widget.artikel.content,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
                const SizedBox(height: 32),

                // Mark as completed button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: _isCompleted
                        ? 'Selesai Dibaca'
                        : 'Tandai Selesai Membaca',
                    onPressed: () {
                      setState(() {
                        _isCompleted = !_isCompleted;
                        // Note: In a real app, we would update this in a database or state management system
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isCompleted
                                ? 'Artikel ditandai sebagai selesai'
                                : 'Artikel ditandai sebagai belum selesai',
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

                // Related articles section (placeholder)
                Text(
                  'Artikel Terkait',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRelatedArticles(),
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
    );
  }

  Widget _buildRelatedArticles() {
    // Get related articles based on category
    final relatedArticles = ArtikelRepository.instance
        .getArtikelsByCategory(widget.artikel.category)
        .where((a) => a.id != widget.artikel.id)
        .toList();

    if (relatedArticles.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(child: Text('Tidak ada artikel terkait')),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: relatedArticles.length > 3 ? 3 : relatedArticles.length,
      itemBuilder: (context, index) {
        final artikel = relatedArticles[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            artikel.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            artikel.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ArtikelDetailScreen(artikel: artikel),
              ),
            );
          },
        );
      },
    );
  }
}
