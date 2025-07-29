import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoSection extends StatefulWidget {
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;

  const VideoSection({
    Key? key,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
  }) : super(key: key);

  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  // Variables for video playback
  YoutubePlayerController? _youtubeController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isVideoInitialized = false;
  bool _isYoutubeVideo = false;
  bool _isNetworkVideo = false;
  bool _showVideo = false;

  @override
  void dispose() {
    // Clean up video controllers
    if (_isYoutubeVideo && _youtubeController != null) {
      _youtubeController!.dispose();
    }
    if (_isNetworkVideo) {
      _chewieController?.dispose();
      _videoPlayerController?.dispose();
    }
    super.dispose();
  }

  void _initializeYoutubePlayer(String videoUrl) {
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
        _showVideo = true;
      });
    }
  }

  void _initializeVideoPlayer(String videoUrl) {
    if (videoUrl.startsWith('http') &&
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

        setState(() {
          _isVideoInitialized = true;
          _isNetworkVideo = true;
          _showVideo = true;
        });
      });
    }
  }

  Widget _buildVideoPlayer() {
    if (_isYoutubeVideo && _youtubeController != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: YoutubePlayer(
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
        ),
      );
    } else if (_isNetworkVideo && _chewieController != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(controller: _chewieController!),
        ),
      );
    }

    // Fallback
    return const Center(child: Text('Video tidak dapat diputar'));
  }

  @override
  Widget build(BuildContext context) {
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
                  Icons.video_library,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Video Referensi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Video content
            _showVideo
                ? _buildVideoPlayer()
                : GestureDetector(
                    onTap: () {
                      // showDialog(
                      //   context: context,
                      //   builder: (context) => AlertDialog(
                      //     title: const Text('Tonton Video'),
                      //     content: const Text('Pilih cara menonton video'),
                      //     actions: [
                      //       TextButton(
                      //         onPressed: () {
                      //           Navigator.pop(context);
                      //           // Open YouTube app or browser
                      //           ScaffoldMessenger.of(context).showSnackBar(
                      //             const SnackBar(
                      //               content: Text('Membuka YouTube...'),
                      //             ),
                      //           );
                      //         },
                      //         child: const Text('YouTube'),
                      //       ),
                      //       TextButton(
                      //         onPressed: () {
                      //           Navigator.pop(context);
                      //           // Initialize the in-app video player
                      //           _initializeYoutubePlayer(widget.videoUrl);
                      //         },
                      //         child: const Text('Dalam Aplikasi'),
                      //       ),
                      //     ],
                      //   ),
                      // );
                      _initializeYoutubePlayer(widget.videoUrl);
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Video thumbnail with YouTube preview
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: widget.thumbnailUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            ),
                          ),
                        ),
                        // Play button overlay
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 12),
            Text(
              widget.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
