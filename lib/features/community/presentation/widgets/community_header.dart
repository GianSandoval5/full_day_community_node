import 'package:flutter/material.dart';

import '../../../../app/theme/node_theme.dart';

class CommunityHeader extends StatelessWidget {
  const CommunityHeader({required this.participantsCount, super.key});

  final int participantsCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: NodeColors.success.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.hub_rounded, color: NodeColors.success),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COMMUNITY LIVE',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '$participantsCount registered ${participantsCount == 1 ? 'node' : 'nodes'}',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: Colors.white54),
                  ),
                ],
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                color: NodeColors.success,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: NodeColors.success, blurRadius: 8),
                ],
              ),
              child: SizedBox.square(dimension: 9),
            ),
          ],
        ),
      ),
    );
  }
}
