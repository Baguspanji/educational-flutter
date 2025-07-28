import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';
import 'materi_detail_screen.dart';

class MateriScreen extends StatefulWidget {
  const MateriScreen({super.key});

  @override
  State<MateriScreen> createState() => _MateriScreenState();
}

class _MateriScreenState extends State<MateriScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  List<Materi> _filteredMateris = [];
  bool _showOnlyCompleted = false;

  // Define all categories
  final List<String> _categories = [
    'Semua',
    'Matematika',
    'Fisika',
    'Kimia',
    'Biologi',
    'Bahasa',
    'Sosial',
  ];

  @override
  void initState() {
    super.initState();
    _filteredMateris = MateriRepository.instance.getAllMateri();
    _searchController.addListener(_filterMateris);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMateris);
    _searchController.dispose();
    super.dispose();
  }

  void _filterMateris() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      final allMateris = MateriRepository.instance.getAllMateri();

      _filteredMateris = allMateris.where((materi) {
        // Apply category filter
        final matchesCategory =
            _selectedCategory == 'Semua' ||
            materi.category == _selectedCategory;

        // Apply completed filter
        final matchesCompleted = !_showOnlyCompleted || materi.isCompleted;

        // Apply search filter
        final matchesSearch =
            query.isEmpty ||
            materi.title.toLowerCase().contains(query) ||
            materi.description.toLowerCase().contains(query);

        return matchesCategory && matchesCompleted && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search and Filter Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari materi...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Category and Filter Tabs
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: _selectedCategory == category,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategory = category;
                                  _filterMateris();
                                });
                              },
                              backgroundColor: Colors.grey.shade200,
                              selectedColor: Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.2),
                              checkmarkColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Completed filter
                  FilterChip(
                    label: const Text('Selesai'),
                    selected: _showOnlyCompleted,
                    onSelected: (selected) {
                      setState(() {
                        _showOnlyCompleted = selected;
                        _filterMateris();
                      });
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.secondary,
                    avatar: Icon(
                      Icons.check_circle,
                      color: _showOnlyCompleted
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Materials List
        Expanded(
          child: _filteredMateris.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _filteredMateris.length,
                  itemBuilder: (context, index) {
                    return _buildMateriCard(context, _filteredMateris[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Tidak ada materi ditemukan',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Coba dengan kata kunci atau filter lain',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          CustomButton(
            label: 'Reset Filter',
            onPressed: () {
              setState(() {
                _searchController.clear();
                _selectedCategory = 'Semua';
                _showOnlyCompleted = false;
                _filteredMateris = MateriRepository.instance.getAllMateri();
              });
            },
            small: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMateriCard(BuildContext context, Materi materi) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
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
              // Category and Date
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      materi.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(materi.createdAt),
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const Spacer(),
                  if (materi.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                materi.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                materi.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Info row
              Row(
                children: [
                  const Icon(Icons.library_books, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${materi.chapters.length} Bab',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.signal_cellular_alt,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    materi.difficultyLevel,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Button
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
