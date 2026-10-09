import 'package:flutter/material.dart';

import '../../../../app/theme/node_theme.dart';
import '../../domain/profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({required this.profile, super.key});

  final Profile? profile;

  @override
  Widget build(BuildContext context) {
    final ready = profile != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: NodeColors.flutterBlue.withValues(alpha: 0.18),
              child: Text(
                ready ? _initials(profile!.name) : '?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: NodeColors.cyan,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ready ? profile!.name : 'Configure your node',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ready
                        ? '${profile!.role} · ${profile!.community}'
                        : 'Your identity starts in your personal Firebase.',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: Colors.white60),
                  ),
                ],
              ),
            ),
            Icon(
              ready ? Icons.verified_rounded : Icons.person_outline_rounded,
              color: ready ? NodeColors.success : Colors.white38,
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
