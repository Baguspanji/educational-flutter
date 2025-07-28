import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';
import 'kuis_detail_screen.dart';

class KuisScreen extends StatefulWidget {
  const KuisScreen({super.key});

  @override
  State<KuisScreen> createState() => _KuisScreenState();
}

class _KuisScreenState extends State<KuisScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  String _selectedDifficulty = 'Semua';
  bool _showOnlyCompleted = false;
  List<Kuis> _filteredKuises = [];

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

  // Define difficulty levels
  final List<String> _difficulties = ['Semua', 'Mudah', 'Menengah', 'Sulit'];

  @override
  void initState() {
    super.initState();
    _filteredKuises = KuisRepository.instance.getAllKuises();
    _searchController.addListener(_filterKuises);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterKuises);
    _searchController.dispose();
    super.dispose();
  }

  void _filterKuises() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      final allKuises = KuisRepository.instance.getAllKuises();

      _filteredKuises = allKuises.where((kuis) {
        // Apply category filter
        final matchesCategory =
            _selectedCategory == 'Semua' || kuis.category == _selectedCategory;

        // Apply difficulty filter
        bool matchesDifficulty = true;
        if (_selectedDifficulty != 'Semua') {
          final timePerQuestion = kuis.timeInMinutes / kuis.questionCount;
          if (_selectedDifficulty == 'Mudah') {
            matchesDifficulty = timePerQuestion < 1.0;
          } else if (_selectedDifficulty == 'Menengah') {
            matchesDifficulty = timePerQuestion >= 1.0 && timePerQuestion < 2.0;
          } else if (_selectedDifficulty == 'Sulit') {
            matchesDifficulty = timePerQuestion >= 2.0;
          }
        }

        // Apply completed filter
        final matchesCompleted = !_showOnlyCompleted || kuis.isCompleted;

        // Apply search filter
        final matchesSearch =
            query.isEmpty ||
            kuis.title.toLowerCase().contains(query) ||
            kuis.description.toLowerCase().contains(query);

        return matchesCategory &&
            matchesDifficulty &&
            matchesCompleted &&
            matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kuis'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
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
                    hintText: 'Cari Kuis...',
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
                                    _filterKuises();
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
                          _filterKuises();
                        });
                      },
                      backgroundColor: Colors.grey.shade200,
                      selectedColor: Colors.green.withOpacity(0.2),
                      checkmarkColor: Colors.green,
                      avatar: Icon(
                        Icons.check_circle,
                        color: _showOnlyCompleted ? Colors.green : Colors.grey,
                        size: 18,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Difficulty Filters
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _difficulties.map((difficulty) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(difficulty),
                          selected: _selectedDifficulty == difficulty,
                          onSelected: (selected) {
                            setState(() {
                              _selectedDifficulty = difficulty;
                              _filterKuises();
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.secondary.withOpacity(0.2),
                          checkmarkColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Kuis List
          Expanded(
            child: _filteredKuises.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredKuises.length,
                    itemBuilder: (context, index) {
                      return _buildKuisCard(context, _filteredKuises[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Tidak ada Kuis ditemukan',
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
                _selectedDifficulty = 'Semua';
                _showOnlyCompleted = false;
                _filteredKuises = KuisRepository.instance.getAllKuises();
              });
            },
            small: true,
          ),
        ],
      ),
    );
  }

  Widget _buildKuisCard(BuildContext context, Kuis kuis) {
    String scoreText = kuis.score != null
        ? '${kuis.score}%'
        : 'Belum dikerjakan';
    Color scoreColor = kuis.score == null
        ? Colors.grey
        : kuis.score! >= 80
        ? Colors.green
        : kuis.score! >= 60
        ? Colors.orange
        : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => KuisDetailScreen(kuis: kuis),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and Status
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
                      kuis.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (kuis.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: scoreColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        scoreText,
                        style: TextStyle(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                kuis.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                kuis.description,
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
                  const Icon(
                    Icons.question_answer,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${kuis.questionCount} Soal',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.timer, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${kuis.timeInMinutes} Menit',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const Spacer(),
                  if (kuis.completedAt != null) ...[
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(kuis.completedAt!),
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),

              // Button
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  label: kuis.isCompleted ? 'Lihat Hasil' : 'Mulai Kuis',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KuisDetailScreen(kuis: kuis),
                      ),
                    );
                  },
                  small: true,
                  backgroundColor: kuis.isCompleted
                      ? Colors.teal
                      : Theme.of(context).colorScheme.primary,
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
