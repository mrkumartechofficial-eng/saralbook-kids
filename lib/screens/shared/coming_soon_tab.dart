import 'package:flutter/material.dart';

import '../../core/localization/generated/app_localizations.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/gigi_mascot.dart';

/// Temporary page for tabs that are built in later batches.
class ComingSoonTab extends StatelessWidget {
  const ComingSoonTab({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GigiMascot(size: 110),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(l.comingSoon, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
