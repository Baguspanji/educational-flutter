import 'package:flutter/material.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';
import 'artikel_detail_screen.dart';

class ArtikelScreen extends StatefulWidget {
  const ArtikelScreen({super.key});

  @override
  State<ArtikelScreen> createState() => _ArtikelScreenState();
}

class _ArtikelScreenState extends State<ArtikelScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  List<Artikel> _filteredArtikels = [];
  bool _showOnlyBookmarked = false;

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
    _filteredArtikels = ArtikelRepository.instance.getAllArtikels();
    _searchController.addListener(_filterArtikels);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterArtikels);
    _searchController.dispose();
    super.dispose();
  }

  void _filterArtikels() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      final allArtikels = ArtikelRepository.instance.getAllArtikels();

      _filteredArtikels = allArtikels.where((artikel) {
        // Apply category filter
        final matchesCategory =
            _selectedCategory == 'Semua' ||
            artikel.category == _selectedCategory;

        // Apply bookmark filter
        final matchesBookmark = !_showOnlyBookmarked || artikel.isBookmarked;

        // Apply search filter
        final matchesSearch =
            query.isEmpty ||
            artikel.title.toLowerCase().contains(query) ||
            artikel.description.toLowerCase().contains(query) ||
            artikel.author.toLowerCase().contains(query);

        return matchesCategory && matchesBookmark && matchesSearch;
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
                  hintText: 'Cari artikel...',
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
                                  _filterArtikels();
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

                  // Bookmark filter
                  FilterChip(
                    label: const Text('Bookmark'),
                    selected: _showOnlyBookmarked,
                    onSelected: (selected) {
                      setState(() {
                        _showOnlyBookmarked = selected;
                        _filterArtikels();
                      });
                    },
                    backgroundColor: Colors.grey.shade200,
                    selectedColor: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.secondary,
                    avatar: Icon(
                      Icons.bookmark,
                      color: _showOnlyBookmarked
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

        // Articles List
        Expanded(
          child: _filteredArtikels.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _filteredArtikels.length,
                  itemBuilder: (context, index) {
                    return _buildArtikelCard(_filteredArtikels[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Tidak ada artikel ditemukan',
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
                _showOnlyBookmarked = false;
                _filteredArtikels = ArtikelRepository.instance.getAllArtikels();
              });
            },
            small: true,
          ),
        ],
      ),
    );
  }

  Widget _buildArtikelCard(Artikel artikel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtikelDetailScreen(artikel: artikel),
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
                      artikel.category,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${artikel.createdAt.day}/${artikel.createdAt.month}/${artikel.createdAt.year}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                  const Spacer(),
                  if (artikel.isCompleted)
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.bookmark,
                    color: artikel.isBookmarked
                        ? Colors.amber
                        : Colors.grey.shade300,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                artikel.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                artikel.description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),

              // Author and Read Time
              Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    artikel.author,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.watch_later_outlined,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${artikel.readTimeMinutes} menit membaca',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
