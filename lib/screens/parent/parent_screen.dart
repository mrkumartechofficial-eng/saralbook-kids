import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/audio/speech_service.dart';
import '../../core/localization/language_provider.dart';
import '../../core/localization/ui_text.dart';
import '../../core/theme/app_theme.dart';
import '../../models/game_id.dart';
import '../../services/progress_service.dart';

/// Parent Zone: protected by a multiplication question a young child cannot
/// answer. Contains learning stats and settings. No personal data is stored.
class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  final TextEditingController _ctrl = TextEditingController();
  final Random _rnd = Random();
  late int _a;
  late int _b;
  bool _open = false;
  bool _wrong = false;

  @override
  void initState() {
    super.initState();
    _newQuestion();
  }

  void _newQuestion() {
    _a = 4 + _rnd.nextInt(6);
    _b = 4 + _rnd.nextInt(6);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _check() {
    if (int.tryParse(_ctrl.text.trim()) == _a * _b) {
      setState(() {
        _open = true;
        _wrong = false;
      });
    } else {
      setState(() {
        _wrong = true;
        _newQuestion();
        _ctrl.clear();
      });
    }
  }

  Future<void> _confirmReset(BuildContext context, String code) async {
    final progress = context.read<ProgressService>();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(UiText.resetAsk.of(code)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(UiText.cancel.of(code)),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(UiText.erase.of(code)),
          ),
        ],
      ),
    );
    if (ok == true) await progress.resetAll();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final code = lang.code;
    if (!_open) return _gate(code);
    return _dashboard(context, lang, code);
  }

  Widget _gate(String code) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_rounded, size: 64, color: AppColors.purple),
              const SizedBox(height: 8),
              Text(
                UiText.forGrownUps.of(code),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink),
              ),
              const SizedBox(height: 16),
              Text(UiText.solveToEnter.of(code),
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(
                '$_a × $_b = ?',
                style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: AppColors.ink),
              ),
              const SizedBox(height: 12),
              TextField(
                key: const ValueKey('gate_field'),
                controller: _ctrl,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 28),
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onSubmitted: (_) => _check(),
              ),
              if (_wrong)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(UiText.wrongAnswer.of(code),
                      style: const TextStyle(color: Colors.deepOrange)),
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  key: const ValueKey('gate_button'),
                  onPressed: _check,
                  child: Text(UiText.check.of(code)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dashboard(BuildContext context, LanguageProvider lang, String code) {
    final p = context.watch<ProgressService>();
    final speech = context.watch<SpeechService>();
    const heading = TextStyle(
        fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.ink);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(UiText.language.of(code), style: heading),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('English')),
                selected: !lang.isHindi,
                onSelected: (_) => lang.setLanguage('en'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('हिंदी')),
                selected: lang.isHindi,
                onSelected: (_) => lang.setLanguage('hi'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: Text(UiText.sound.of(code), style: heading),
          value: speech.enabled,
          onChanged: (v) => speech.setEnabled(v),
        ),
        const Divider(),
        Text(UiText.learning.of(code), style: heading),
        const SizedBox(height: 4),
        Text('⭐ ${UiText.stars(p.totalStars).of(code)}',
            style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        for (final g in GameId.values)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: [
                Text(g.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(child: Text(g.nameBi.of(code))),
                Text(
                  '${UiText.level(p.highestUnlocked(g)).of(code)} • ★${p.starsInGame(g)} • ${p.accuracy(g)}%',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _confirmReset(context, code),
          icon: const Icon(Icons.delete_outline_rounded),
          label: Text(UiText.resetProgress.of(code)),
        ),
        const Divider(height: 32),
        Text(UiText.about.of(code), style: heading),
        const SizedBox(height: 4),
        Text(UiText.aboutText.of(code)),
        const SizedBox(height: 16),
        Text(UiText.privacy.of(code), style: heading),
        const SizedBox(height: 4),
        Text(UiText.privacyText.of(code)),
        const SizedBox(height: 16),
      ],
    );
  }
}
