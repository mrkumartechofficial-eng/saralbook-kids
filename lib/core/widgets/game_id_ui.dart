import 'package:flutter/material.dart';

import '../../models/game_id.dart';
import '../theme/app_theme.dart';

extension GameIdUi on GameId {
  Color get color => const [
        AppColors.sky,
        AppColors.yellow,
        AppColors.pink,
        AppColors.mint,
        AppColors.orange,
        AppColors.purple,
      ][index % 6];
}
