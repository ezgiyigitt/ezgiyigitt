import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../models/level_data.dart';
import '../../services/ad_service.dart';
import '../../viewmodels/game_viewmodel.dart';
import '../widgets/blueprint_preview_card.dart';
import '../widgets/game_button.dart';
import '../widgets/glass_container.dart';

class LevelSelectScreen extends StatefulWidget {
  const LevelSelectScreen({super.key});

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _bannerAd = AdService.instance.createBanner();
    }
  }

  @override
  void dispose() {
    AdService.instance.disposeBanner();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<GameViewModel>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF42A5F5),
              Color(0xFFFFCC80),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    GlassContainer(
                      padding: const EdgeInsets.all(8.0),
                      borderRadius: 14.0,
                      onTap: vm.goToHome,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18.0,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(width: 14.0),
                    const Text(
                      'SELECT LEVEL',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),

              // Vertical scrollable level cards
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemCount: LevelDefinition.allLevels.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14.0),
                  itemBuilder: (context, index) {
                    final level = LevelDefinition.allLevels[index];
                    final isUnlocked = vm.isLevelUnlocked(level.id);

                    return _PortraitLevelCard(
                      level: level,
                      isUnlocked: isUnlocked,
                      onTap: () => vm.startLevel(level.id),
                    );
                  },
                ),
              ),

              // ── BANNER AD — bottom of screen ─────────────────────────────
              if (!kIsWeb && _bannerAd != null)
                Container(
                  color: Colors.white,
                  width: double.infinity,
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortraitLevelCard extends StatelessWidget {
  final LevelDefinition level;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _PortraitLevelCard({
    required this.level,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onTap : null,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
        borderRadius: 22.0,
        backgroundColor: const Color(0xF7FFFFFF), // 97% frosted white
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left Info Column
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge & Icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7.0, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7A00),
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: Text(
                          level.title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6.0),
                      Icon(
                        level.icon,
                        size: 18.0,
                        color: const Color(0xFFFF7A00),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),

                  // Subtitle
                  Text(
                    level.subtitle,
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 3.0),

                  // Story
                  Text(
                    level.story,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10.5,
                      color: Color(0xFF64748B),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 6.0),

                  // Specs
                  Row(
                    children: [
                      Icon(
                        level.wind.baseStrength > 0 ? Icons.air_rounded : Icons.check_circle_outline_rounded,
                        size: 13.0,
                        color: level.wind.baseStrength > 0 ? const Color(0xFF0288D1) : const Color(0xFF2E7D32),
                      ),
                      const SizedBox(width: 4.0),
                      Expanded(
                        child: Text(
                          level.wind.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w700,
                            color: level.wind.baseStrength > 0 ? const Color(0xFF0288D1) : const Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Goal: ${level.targetHeight.toStringAsFixed(1)}m',
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF334155),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),

            // Right Blueprint & Start Button Column
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Standalone mini blueprint preview
                BlueprintPreviewCard(
                  level: level,
                  showHeader: false,
                  width: 80.0,
                  height: 92.0,
                ),
                const SizedBox(height: 8.0),

                // Juicy Start Button
                GameButton.green(
                  text: isUnlocked ? 'PLAY' : 'LOCKED',
                  icon: isUnlocked ? Icons.play_arrow_rounded : Icons.lock_rounded,
                  width: 105.0, // Increased width to comfortably fit the text
                  height: 38.0,
                  fontSize: 12.0, // Slightly reduced font size to fit better
                  onPressed: isUnlocked ? onTap : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
