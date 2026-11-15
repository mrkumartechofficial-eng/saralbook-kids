import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/audio/speech_service.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/localization/language_provider.dart';
import '../../core/localization/ui_text.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/game_id_ui.dart';
import '../../core/widgets/gigi_mascot.dart';
import '../../models/game_id.dart';
import '../../services/progress_service.dart';
import '../levels/level_map_screen.dart';
import '../parent/parent_screen.dart';
import '../play/game_screen.dart';
import '../progress/progress_screen.dart';
import '../rewards/rewards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final Widget body = switch (_tab) {
      0 => const HomeTab(),
      1 => const RewardsScreen(),
      2 => const ProgressScreen(),
      _ => const ParentScreen(),
    };
    return Scaffold(
      body: SafeArea(child: body),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home_rounded), label: l.navHome),
          NavigationDestination(
              icon: const Icon(Icons.emoji_events_rounded),
              label: l.navRewards),
          NavigationDestination(
              icon: const Icon(Icons.bar_chart_rounded), label: l.navProgress),
          NavigationDestination(
              icon: const Icon(Icons.lock_rounded), label: l.navParent),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  Future<void> _hearGigi(BuildContext context) async {
    final l = AppLocalizations.of(context);
    final code = context.read<LanguageProvider>().code;
    final speech = context.read<SpeechService>();
    final messenger = ScaffoldMessenger.of(context);
    final available = await speech.isLanguageAvailable(code);
    if (!available) {
      messenger.showSnackBar(SnackBar(content: Text(l.voiceMissingHint)));
      return;
    }
    await speech.speak(l.welcomeMessage, code);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = context.watch<LanguageProvider>();
    final progress = context.watch<ProgressService>();
    final code = lang.code;
    final cont = progress.lastPlayed ?? GameId.alphabet;
    final contLevel = progress.highestUnlocked(cont);

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 4
            : (constraints.maxWidth >= 600 ? 3 : 2);
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const GigiMascot(size: 64),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            UiText.tapToPlay.of(code),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.tonalIcon(
                          onPressed: () => lang.toggle(),
                          icon: const Icon(Icons.translate_rounded),
                          label: Text(l.switchLanguage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.star_rounded,
                              color: AppColors.orange),
                          label: Text(l.starsCount(progress.totalStars)),
                          backgroundColor: AppColors.yellow,
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () => _hearGigi(context),
                          icon: const Icon(Icons.volume_up_rounded),
                          label: Text(l.hearGigi),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Material(
                      color: cont.color,
                      borderRadius: BorderRadius.circular(24),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                GameScreen(game: cont, level: contLevel),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Text(cont.emoji,
                                  style: const TextStyle(fontSize: 40)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      UiText.continuePlaying.of(code),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    Text(
                                      '${cont.nameBi.of(code)} • ${UiText.level(contLevel).of(code)}',
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.play_circle_fill_rounded,
                                  size: 48, color: AppColors.ink),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.0,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _GameCard(game: GameId.values[i]),
                  childCount: GameId.values.length,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});

  final GameId game;

  @override
  Widget build(BuildContext context) {
    final code = context.watch<LanguageProvider>().code;
    final progress = context.watch<ProgressService>();
    final level = progress.highestUnlocked(game);
    final stars = progress.starsInGame(game);
    return Material(
      color: game.color,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => LevelMapScreen(game: game)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: Colors.white70,
                child: Text(game.emoji, style: const TextStyle(fontSize: 36)),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  game.nameBi.of(code),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${UiText.level(level).of(code)}  ★$stars',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
