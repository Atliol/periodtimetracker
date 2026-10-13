import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/widgets/custom_app_bar.dart';

class MusicPlayerPage extends StatefulWidget {
  const MusicPlayerPage({super.key});

  @override
  State<MusicPlayerPage> createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _currentSong = 'သက်သာစေမည့် သဘာဝရေသံနှင့် တေးဂီတ';

  // နမူနာ သီချင်းစာရင်း (Sample Audio URLs)
  final List<Map<String, String>> _playlist = [
    {
      'title': 'Calm Rain & Nature Sounds',
      'duration': '3:45',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    },
    {
      'title': 'Relaxing Period Relief Melody',
      'duration': '4:20',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    },
    {
      'title': 'Deep Sleep & Healing Tones',
      'duration': '5:10',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
    },
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSong(String url, String title) async {
    try {
      if (_isPlaying) {
        await _audioPlayer.stop();
      }
      await _audioPlayer.play(UrlSource(url));
      setState(() {
        _isPlaying = true;
        _currentSong = title;
      });
    } catch (e) {
      debugPrint("Error playing audio: $e");
    }
  }

  void _pauseOrResume() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() => _isPlaying = false);
    } else {
      await _audioPlayer.resume();
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFD47A83),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFFD47A83),
          appBar: const CustomAppBar(
            title: 'Relaxing Music Player',
            showBackButton: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // 🌟 အလယ်တွင် ပြသမည့် Music Player Card ကြီး
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF758C), Color(0xFFFF416C)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.music_note_rounded, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        _currentSong,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Period Pain Relief & Relaxation',
                        style: TextStyle(color: Colors.white70, fontSize: 12.5),
                      ),
                      const SizedBox(height: 24),
                      // Play / Pause ခလုတ်
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(_isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                                color: Colors.white, size: 64),
                            onPressed: _pauseOrResume,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'သီချင်းများစာရင်း (Playlist)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 12),

                // သီချင်းစာရင်း ListView
                Expanded(
                  child: ListView.builder(
                    itemCount: _playlist.length,
                    itemBuilder: (context, index) {
                      final song = _playlist[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.headset_rounded, color: Color(0xFFFF416C), size: 22),
                          ),
                          title: Text(
                            song['title']!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.5, color: Colors.black87),
                          ),
                          subtitle: Text(
                            song['duration']!,
                            style: const TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                          trailing: const Icon(Icons.play_arrow_rounded, color: Color(0xFFFF416C)),
                          onTap: () => _playSong(song['url']!, song['title']!),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}