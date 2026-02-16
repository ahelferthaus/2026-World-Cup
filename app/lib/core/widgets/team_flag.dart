import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class TeamFlag extends StatelessWidget {
  const TeamFlag({
    super.key,
    required this.logoUrl,
    this.size = 32,
  });

  final String logoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: logoUrl,
      width: size,
      height: size,
      placeholder: (_, __) => SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (_, __, ___) => Icon(
        Icons.flag,
        size: size,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
      ),
    );
  }
}
