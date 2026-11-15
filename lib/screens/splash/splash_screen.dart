import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/localization/language_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gigi_mascot.dart';
import '../home/home_screen.dart';
import '../language/language_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2600), _next);
  }

  void _next() {
    if (!mounted) return;
    final chosen = context.read<LanguageProvider>().hasChosen;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => chosen ? const HomeScreen() : const LanguageScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    const blockLetters = ['A', 'अ', '1'];
    const blockColors = [AppColors.yellow, AppColors.pink, AppColors.mint];
    const starColors = [AppColors.yellow, Colors.white, AppColors.pink];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.sky, AppColors.cream],
          ),
        ),
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) {
            return Stack(
              fit: StackFit.expand,
              children: [
                for (var i = 0; i < 14; i++)
                  Align(
                    alignment: Alignment(
                      ((i * 37) % 100) / 50 - 1,
                      1 - 2 * ((_c.value + i / 14) % 1),
                    ),
                    child: Icon(
                      Icons.star_rounded,
                      size: 14.0 + (i % 4) * 6,
                      color: starColors[i % 3].withValues(alpha: 0.7),
                    ),
                  ),
                Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < 3; i++)
                              Transform.translate(
                                offset: Offset(
                                  0,
                                  -10 *
                                      (0.5 +
                                          0.5 *
                                              math.sin(_c.value * 2 * math.pi +
                                                  i * 1.2)),
                                ),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  margin: const EdgeInsets.all(6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: blockColors[i],
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    blockLetters[i],
                                    style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const GigiMascot(size: 160),
                        const SizedBox(height: 16),
                        Text(
                          l.appTitle,
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          l.appSubtitle,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l.tagline,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
