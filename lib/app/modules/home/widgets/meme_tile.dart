import 'package:flutter/material.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';

class MemeTile extends StatelessWidget {
  final MemeModel meme;
  const MemeTile({super.key, required this.meme});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(meme.imageUrl ?? ''),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(meme.title ?? '', style: const TextStyle(fontSize: 16)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
            child: Row(
              children: [
                Icon(Icons.favorite_border),
                const SizedBox(width: 4),
                Text('${meme.likeCount}'),
                const Spacer(),
                Icon(Icons.comment),
                const SizedBox(width: 4),
                Text('Comment'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
