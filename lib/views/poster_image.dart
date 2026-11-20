import 'package:flutter/material.dart';

/// Imagem de pôster reutilizável: mostra um carregando enquanto baixa
/// e um ícone se a imagem falhar (em vez de quebrar a tela).
class PosterImage extends StatelessWidget {
  final String url;
  final double? height;
  final double? width;

  const PosterImage({super.key, required this.url, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      height: height,
      width: width,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progresso) {
        if (progresso == null) return child;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
      errorBuilder: (context, erro, stackTrace) {
        return Container(
          color: Colors.grey.shade800,
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white54),
          ),
        );
      },
    );
  }
}