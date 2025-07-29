import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/content_models.dart';
import '../widgets/custom_button.dart';

class VideoDetailScreen extends StatefulWidget {
  final Video video;

  const VideoDetailScreen({super.key, required this.video});

  @override
  State<VideoDetailScreen> createState() => _VideoDetailScreenState();
}

class _VideoDetailScreenState extends State<VideoDetailScreen> {
  late bool _isCompleted;
  final ScrollController _scrollController = ScrollController();
  bool _showBackToTop = false;

  // Variables for video playback
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  bool _isYoutubeVideo = false;
  bool _isNetworkVideo = false;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.video.isCompleted;
    _initializeVideoPlayer();

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

  void _initializeVideoPlayer() {
    final videoUrl = widget.video.videoUrl;

    // Check if it's a YouTube video
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      String? videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            disableDragSeek: false,
            loop: false,
            enableCaption: true,
            showLiveFullscreenButton: false,
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
          autoPlay: true,
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

        // Listen for video completion
        _videoPlayerController!.addListener(_onVideoPositionChanged);

        setState(() {
          _isVideoInitialized = true;
          _isNetworkVideo = true;
        });
      });
    }
  }

  void _onVideoPositionChanged() {
    if (_videoPlayerController != null &&
        _videoPlayerController!.value.isInitialized &&
        _videoPlayerController!.value.position >=
            _videoPlayerController!.value.duration -
                const Duration(seconds: 1)) {
      // The video has reached the end
      if (!_isCompleted) {
        setState(() {
          _isCompleted = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video ditandai sebagai selesai'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (_isVideoInitialized) {
      if (_isYoutubeVideo && _youtubeController != null) {
        _youtubeController!.dispose();
      }
      if (_isNetworkVideo) {
        _videoPlayerController?.removeListener(_onVideoPositionChanged);
        _chewieController?.dispose();
        _videoPlayerController?.dispose();
      }
    }
    super.dispose();
  }

  Widget _buildVideoPlayer() {
    if (!_isVideoInitialized) {
      // Show thumbnail with play button if video is not initialized
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Thumbnail
            widget.video.thumbnailUrl.startsWith('http')
                ? CachedNetworkImage(
                    imageUrl: widget.video.thumbnailUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.black,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black,
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.white54),
                      ),
                    ),
                  )
                : Container(
                    color: Colors.black,
                    child: const Center(
                      child: Icon(
                        Icons.videocam_off,
                        size: 48,
                        color: Colors.white54,
                      ),
                    ),
                  ),
            // Play button overlay
            IconButton(
              icon: const Icon(
                Icons.play_circle_fill,
                size: 72,
                color: Colors.white,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Format video tidak didukung')),
                );
              },
            ),
          ],
        ),
      );
    }

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
        onReady: () {
          // Player is ready
        },
        onEnded: (metaData) {
          // Auto-mark as completed when video ends
          if (!_isCompleted) {
            setState(() {
              _isCompleted = true;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Video ditandai sebagai selesai'),
                duration: Duration(seconds: 2),
              ),
            );
          }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.video.category),
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
                // Video player
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildVideoPlayer(),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  widget.video.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Video metadata
                Row(
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.video.category,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.video.durationInMinutes} menit',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.video.createdAt.day}/${widget.video.createdAt.month}/${widget.video.createdAt.year}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                Text(
                  'Deskripsi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.video.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.5),
                ),
                const SizedBox(height: 24),

                // Mark as completed button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    label: _isCompleted
                        ? 'Selesai Ditonton'
                        : 'Tandai Selesai Ditonton',
                    onPressed: () {
                      setState(() {
                        _isCompleted = !_isCompleted;
                        // Note: In a real app, we would update this in a database
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isCompleted
                                ? 'Video ditandai sebagai selesai'
                                : 'Video ditandai sebagai belum selesai',
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
}
