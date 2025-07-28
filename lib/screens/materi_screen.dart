import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';
import 'materi_detail_screen.dart';

class MateriScreen extends StatelessWidget {
  const MateriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final materis = MateriRepository.instance.getAllMateri();
    final categories = _getUniqueCategories(materis);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            _buildSearchBar(context),
            const SizedBox(height: 24),

            // Categories filter
            Text(
              'Kategori',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCategoryFilter(context, categories),
            const SizedBox(height: 24),

            // Materials list
            Text(
              'Semua Materi',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...materis.map((materi) => _buildMateriCard(context, materi)),
          ],
        ),
      ),
    );
  }

  List<String> _getUniqueCategories(List<Materi> materis) {
    final categories = materis
        .map((materi) => materi.category)
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari materi...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onChanged: (value) {
        // TODO: Implement search functionality
      },
    );
  }

  Widget _buildCategoryFilter(BuildContext context, List<String> categories) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildCategoryChip(context, 'Semua', isSelected: true),
          ...categories.map(
            (category) => _buildCategoryChip(context, category),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String category, {
    bool isSelected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        selected: isSelected,
        label: Text(category),
        onSelected: (selected) {
          // TODO: Implement category filtering
        },
        showCheckmark: false,
        backgroundColor: Colors.grey.shade200,
        selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildMateriCard(BuildContext context, Materi materi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navigate to detail screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MateriDetailScreen(materiId: materi.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and completion badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(
                        materi.category,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      materi.category,
                      style: TextStyle(
                        color: _getCategoryColor(materi.category),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (materi.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 14,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Selesai',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Title and description
              Text(
                materi.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                materi.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),

              // Chapter count and difficulty level
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.library_books,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${materi.chapters.length} Bab',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.signal_cellular_alt,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        materi.difficultyLevel,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(materi.createdAt),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Start/Continue button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  label: materi.isCompleted
                      ? 'Review Kembali'
                      : 'Mulai Belajar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MateriDetailScreen(materiId: materi.id),
                      ),
                    );
                  },
                  small: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Matematika':
        return Colors.blue.shade700;
      case 'Fisika':
        return Colors.purple.shade700;
      case 'Bahasa':
        return Colors.green.shade700;
      case 'Sosial':
        return Colors.orange.shade700;
      case 'Kimia':
        return Colors.red.shade700;
      case 'Biologi':
        return Colors.teal.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
