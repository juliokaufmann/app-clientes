import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CindapaLogo extends StatelessWidget {
  final double? height;
  final double? width;

  const CindapaLogo({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppTheme.logoPath,
      height: height ?? 40,
      width: width,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Log do erro para debug
        debugPrint('Erro ao carregar logo: $error');

        return Container(
          height: height ?? 40,
          width: width ?? 40,
          decoration: BoxDecoration(
            color: AppTheme.mediumGray,
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.business,
            color: AppTheme.accentBlue,
            size: 24,
          ),
        );
      },
    );
  }
}
