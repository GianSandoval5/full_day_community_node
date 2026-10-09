import 'package:flutter/material.dart';

import '../../domain/community_message.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({required this.message, super.key});

  final CommunityMessage message;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey(message.id),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 19,
                  child: Text(_initials(message.authorName)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.authorName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${message.authorRole} · ${message.authorCommunity}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: Colors.white54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              message.text,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(height: 1.35),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    return name
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();
  }
}
