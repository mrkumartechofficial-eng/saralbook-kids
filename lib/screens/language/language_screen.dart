import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/localization/language_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gigi_mascot.dart';
import '../home/home_screen.dart';

/// Shown only on first launch. Shows both languages at once on purpose,
/// because the child/parent has not chosen yet.
class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  Future<void> _pick(BuildContext context, String code) async {
    final lang = context.read<LanguageProvider>();
    final nav = Navigator.of(context);
    await lang.setLanguage(code);
    nav.pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.sky, AppColors.cream],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const GigiMascot(size: 140),
                  const SizedBox(height: 16),
                  const Text(
                    'Choose your language',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'अपनी भाषा चुनें',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _LanguageButton(
                    label: 'English',
                    sample: 'A B C',
                    color: AppColors.yellow,
                    onTap: () => _pick(context, 'en'),
                  ),
                  const SizedBox(height: 16),
                  _LanguageButton(
                    label: 'हिंदी',
                    sample: 'अ आ इ',
                    color: AppColors.pink,
                    onTap: () => _pick(context, 'hi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageButton extends StatelessWidget {
  const _LanguageButton({
    required this.label,
    required this.sample,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String sample;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          borderRadius: BorderRadius.circular(32),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                Text(
                  sample,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
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
