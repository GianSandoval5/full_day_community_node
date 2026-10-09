import 'package:flutter/material.dart';

import '../../../../app/theme/node_theme.dart';

class EmptyCommunityState extends StatelessWidget {
  const EmptyCommunityState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.forum_outlined, size: 52, color: NodeColors.cyan),
            const SizedBox(height: 16),
            Text(
              'The network is ready.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 7),
            const Text(
              'Be the first node to say hello.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }
}
