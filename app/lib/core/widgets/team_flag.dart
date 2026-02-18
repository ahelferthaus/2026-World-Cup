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
    return Image.network(
      logoUrl,
      width: size,
      height: size,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return SizedBox(
          width: size,
          height: size,
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.flag,
          size: size,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
        );
      },
    );
  }
}
