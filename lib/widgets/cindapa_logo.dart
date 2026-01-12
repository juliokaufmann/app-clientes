import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CindapaLogo extends StatelessWidget {
  final double? height;
  final double? width;

  const CindapaLogo({super.key, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: AppTheme.logoUrl,
      height: height ?? 40,
      width: width,
      fit: BoxFit.contain,
      httpHeaders: const {'Accept': 'image/webp,image/*,*/*'},
      placeholder: (context, url) => SizedBox(
        height: height ?? 40,
        width: width ?? 40,
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppTheme.accentBlue,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        // Log do erro para debug
        debugPrint('Erro ao carregar logo: $error');
        debugPrint('URL: $url');

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
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );
  }
}
