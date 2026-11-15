import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/audio/speech_service.dart';
import '../../core/localization/generated/app_localizations.dart';
import '../../core/localization/language_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gigi_mascot.dart';
import '../../models/game_id.dart';
import '../shared/coming_soon_tab.dart';

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
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _tab,
          children: [
            const _HomeTab(),
            ComingSoonTab(title: l.navRewards),
            ComingSoonTab(title: l.navProgress),
            ComingSoonTab(title: l.navParent),
          ],
        ),
      ),
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

class _HomeTab extends StatelessWidget {
  const _HomeTab();

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 4
            : (constraints.maxWidth >= 600 ? 3 : 2);
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const GigiMascot(size: 72),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.appTitle,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.ink,
                                ),
                              ),
                              Text(
                                l.tagline,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: () => lang.toggle(),
                          icon: const Icon(Icons.translate_rounded),
                          label: Text(l.switchLanguage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.star_rounded,
                              color: AppColors.orange),
                          label: Text(l.starsCount(0)),
                          backgroundColor: AppColors.yellow,
                        ),
                        FilledButton.icon(
                          onPressed: () => _hearGigi(context),
                          icon: const Icon(Icons.volume_up_rounded),
                          label: Text(l.hearGigi),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l.welcomeMessage,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.05,
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

  void _open(BuildContext context) {
    // The real games are added in later batches.
    final l = AppLocalizations.of(context);
    final code = context.read<LanguageProvider>().code;
    context.read<SpeechService>().speak(l.comingSoon, code);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l.comingSoon)));
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Material(
      color: game.color,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: () => _open(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.white70,
                child: Icon(game.icon, size: 32, color: AppColors.ink),
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  game.title(l),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
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
                  l.levelLabel(1),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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
