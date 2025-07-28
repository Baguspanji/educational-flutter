import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';
import 'lkpd_detail_screen.dart';

class LkpdScreen extends StatefulWidget {
  const LkpdScreen({super.key});

  @override
  State<LkpdScreen> createState() => _LkpdScreenState();
}

class _LkpdScreenState extends State<LkpdScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  String _selectedType = 'Semua';
  List<LKPD> _filteredLkpds = [];
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

  // Define all LKPD types
  final List<String> _types = [
    'Semua',
    'Pilihan Ganda',
    'Essay',
    'Praktikum',
    'Isian',
    'Observasi & Laporan',
    'Isian & Pilihan Ganda',
  ];

  @override
  void initState() {
    super.initState();
    _filteredLkpds = LkpdRepository.instance.getAllLkpd();
    _searchController.addListener(_filterLkpds);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterLkpds);
    _searchController.dispose();
    super.dispose();
  }

  void _filterLkpds() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      final allLkpds = LkpdRepository.instance.getAllLkpd();

      _filteredLkpds = allLkpds.where((lkpd) {
        // Apply category filter
        final matchesCategory =
            _selectedCategory == 'Semua' || lkpd.category == _selectedCategory;

        // Apply type filter
        final matchesType =
            _selectedType == 'Semua' || lkpd.type == _selectedType;

        // Apply completed filter
        final matchesCompleted = !_showOnlyCompleted || lkpd.isCompleted;

        // Apply search filter
        final matchesSearch =
            query.isEmpty ||
            lkpd.title.toLowerCase().contains(query) ||
            lkpd.description.toLowerCase().contains(query);

        return matchesCategory &&
            matchesType &&
            matchesCompleted &&
            matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LKPD'),
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
                    hintText: 'Cari LKPD...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),

                // Category Filter Header
                const Text(
                  'Kategori',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Category Filter Chips
                SingleChildScrollView(
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
                              _filterLkpds();
                            });
                          },
                          backgroundColor: Colors.grey.shade200,
                          selectedColor: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          checkmarkColor: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Type Filter Header
                const Text(
                  'Jenis',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Type Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ..._types.map((type) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(type),
                            selected: _selectedType == type,
                            onSelected: (selected) {
                              setState(() {
                                _selectedType = type;
                                _filterLkpds();
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

                      // Completed filter
                      FilterChip(
                        label: const Text('Selesai'),
                        selected: _showOnlyCompleted,
                        onSelected: (selected) {
                          setState(() {
                            _showOnlyCompleted = selected;
                            _filterLkpds();
                          });
                        },
                        backgroundColor: Colors.grey.shade200,
                        selectedColor: Colors.green.withOpacity(0.2),
                        checkmarkColor: Colors.green,
                        avatar: Icon(
                          Icons.check_circle,
                          color: _showOnlyCompleted
                              ? Colors.green
                              : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // LKPD List
          Expanded(
            child: _filteredLkpds.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredLkpds.length,
                    itemBuilder: (context, index) {
                      return _buildLkpdCard(_filteredLkpds[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_document, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Tidak ada LKPD ditemukan',
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
                _selectedType = 'Semua';
                _showOnlyCompleted = false;
                _filteredLkpds = LkpdRepository.instance.getAllLkpd();
              });
            },
            small: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLkpdCard(LKPD lkpd) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LkpdDetailScreen(lkpd: lkpd),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category and Type
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
                      lkpd.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      lkpd.type,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (lkpd.isCompleted)
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
                lkpd.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                lkpd.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Details Row
              Row(
                children: [
                  _buildIconWithText(
                    Icons.question_answer,
                    '${lkpd.questionCount} soal',
                  ),
                  const SizedBox(width: 16),
                  _buildIconWithText(
                    Icons.timer,
                    '${lkpd.estimatedTimeMinutes} menit',
                  ),
                  const Spacer(),
                  CustomButton(
                    label: 'Kerjakan',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LkpdDetailScreen(lkpd: lkpd),
                        ),
                      );
                    },
                    small: true,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWithText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }
}
