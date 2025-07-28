import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/content_models.dart';
import '../repositories/repositories.dart';
import '../widgets/custom_button.dart';
import 'video_detail_screen.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  List<Video> _filteredVideos = [];
  bool _showOnlyCompleted = false;

  // Variables for the featured video preview
  Video? _featuredVideo;
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  bool _isYoutubeVideo = false;
  bool _isNetworkVideo = false;
  bool _isPreviewVisible = false;

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
    _filteredVideos = VideoRepository.instance.getAllVideos();
    _searchController.addListener(_filterVideos);

    // Set up featured video
    if (_filteredVideos.isNotEmpty) {
      _setupFeaturedVideo(_filteredVideos[0]);
    }
  }

  void _setupFeaturedVideo(Video video) {
    // Clean up previous controllers
    if (_youtubeController != null) {
      _youtubeController!.dispose();
      _youtubeController = null;
    }

    if (_videoPlayerController != null) {
      _videoPlayerController!.dispose();
      _videoPlayerController = null;
    }

    if (_chewieController != null) {
      _chewieController!.dispose();
      _chewieController = null;
    }

    setState(() {
      _featuredVideo = video;
      _isVideoInitialized = false;
      _isYoutubeVideo = false;
      _isNetworkVideo = false;
      _isPreviewVisible = false;
    });

    final videoUrl = video.videoUrl;

    // Check if it's a YouTube video
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      String? videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            disableDragSeek: true,
            loop: false,
            enableCaption: true,
          ),
        );
        setState(() {
          _isVideoInitialized = true;
          _isYoutubeVideo = true;
        });
      }
    }
    // Check if it's a network video (MP4, etc.)
    else if (videoUrl.startsWith('http') &&
        (videoUrl.endsWith('.mp4') ||
            videoUrl.endsWith('.mov') ||
            videoUrl.endsWith('.avi') ||
            videoUrl.endsWith('.mkv'))) {
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(videoUrl),
      );
      _videoPlayerController!.initialize().then((_) {
        // After initialization, create the Chewie controller
        _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoPlay: false,
          looping: false,
          allowFullScreen: true,
          showControlsOnInitialize: false,
          allowMuting: true,
          placeholder: Container(
            color: Colors.black,
            child: const Center(child: CircularProgressIndicator()),
          ),
          materialProgressColors: ChewieProgressColors(
            playedColor: Theme.of(context).colorScheme.primary,
            handleColor: Theme.of(context).colorScheme.primary,
            backgroundColor: Colors.grey,
            bufferedColor: Theme.of(
              context,
            ).colorScheme.primary.withOpacity(0.5),
          ),
        );

        setState(() {
          _isVideoInitialized = true;
          _isNetworkVideo = true;
        });
      });
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterVideos);
    _searchController.dispose();
    _youtubeController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _filterVideos() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      final allVideos = VideoRepository.instance.getAllVideos();

      _filteredVideos = allVideos.where((video) {
        // Apply category filter
        final matchesCategory =
            _selectedCategory == 'Semua' || video.category == _selectedCategory;

        // Apply completed filter
        final matchesCompleted = !_showOnlyCompleted || video.isCompleted;

        // Apply search filter
        final matchesSearch =
            query.isEmpty ||
            video.title.toLowerCase().contains(query) ||
            video.description.toLowerCase().contains(query);

        return matchesCategory && matchesCompleted && matchesSearch;
      }).toList();

      // Update featured video if needed
      if (_filteredVideos.isNotEmpty &&
          (_featuredVideo == null ||
              !_filteredVideos.contains(_featuredVideo))) {
        _setupFeaturedVideo(_filteredVideos[0]);
      }
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
                  hintText: 'Cari video...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 16),

              // Featured video section
              // if (_featuredVideo != null) _buildFeaturedVideoSection(),
              // const SizedBox(height: 16),

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
                                  _filterVideos();
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
                        _filterVideos();
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

        // Videos List
        Expanded(
          child: _filteredVideos.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _filteredVideos.length,
                  itemBuilder: (context, index) {
                    return _buildVideoCard(_filteredVideos[index]);
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
          Icon(Icons.videocam_off, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Tidak ada video ditemukan',
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
                _filteredVideos = VideoRepository.instance.getAllVideos();
                if (_filteredVideos.isNotEmpty) {
                  _setupFeaturedVideo(_filteredVideos[0]);
                }
              });
            },
            small: true,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedVideoSection() {
    if (_featuredVideo == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Video Unggulan',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Video thumbnail or player
                    _isPreviewVisible && _isVideoInitialized
                        ? _buildVideoPlayer()
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPreviewVisible = true;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child:
                                      _featuredVideo!.thumbnailUrl.startsWith(
                                        'http',
                                      )
                                      ? CachedNetworkImage(
                                          imageUrl:
                                              _featuredVideo!.thumbnailUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Container(
                                                color: Colors.grey.shade300,
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                              ),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                                color: Colors.grey.shade200,
                                                child: const Center(
                                                  child: Icon(Icons.error),
                                                ),
                                              ),
                                        )
                                      : Image.asset(
                                          _featuredVideo!.thumbnailUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Container(
                                                    color: Colors.grey.shade200,
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons.image,
                                                        size: 48,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                        ),
                                ),
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow,
                                    size: 40,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _featuredVideo!.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _featuredVideo!.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${_featuredVideo!.durationInMinutes} menit',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
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
                              _featuredVideo!.category,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VideoDetailScreen(video: _featuredVideo!),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            child: const Text('Tonton'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer() {
    // Show YouTube player
    if (_isYoutubeVideo && _youtubeController != null) {
      return YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Theme.of(context).colorScheme.primary,
        progressColors: ProgressBarColors(
          playedColor: Theme.of(context).colorScheme.primary,
          handleColor: Theme.of(context).colorScheme.primary,
        ),
        onEnded: (metadata) {
          setState(() {
            _isPreviewVisible = false;
          });
        },
      );
    }

    // Show Chewie/VideoPlayer for other video formats
    if (_isNetworkVideo && _chewieController != null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Chewie(controller: _chewieController!),
      );
    }

    // Fallback - should not reach here
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            'Format video tidak didukung',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoCard(Video video) {
    bool isFeatured = _featuredVideo != null && _featuredVideo!.id == video.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VideoDetailScreen(video: video),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with play button overlay
            Stack(
              alignment: Alignment.center,
              children: [
                // Video thumbnail
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: video.thumbnailUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: video.thumbnailUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(child: Icon(Icons.error)),
                            ),
                          )
                        : Image.asset(
                            video.thumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(
                                      Icons.image,
                                      size: 48,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                          ),
                  ),
                ),
                // Play button overlay
                // const Icon(
                //   Icons.play_circle_fill,
                //   size: 62,
                //   color: Colors.white,
                // ),
                // Duration badge
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${video.durationInMinutes} menit',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Category badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isFeatured
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isFeatured ? 'Unggulan' : video.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Completed badge if applicable
                if (video.isCompleted)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),

            // Video info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    video.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Description
                  Text(
                    video.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Date and metadata
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${video.createdAt.day}/${video.createdAt.month}/${video.createdAt.year}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      // "Set as Featured" button for non-featured videos
                      if (!isFeatured)
                        TextButton.icon(
                          onPressed: () {
                            _setupFeaturedVideo(video);
                          },
                          icon: const Icon(Icons.star_outline, size: 16),
                          label: const Text('Set Unggulan'),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: const Size(0, 32),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
