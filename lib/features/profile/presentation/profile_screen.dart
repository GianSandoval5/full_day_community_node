import 'package:flutter/material.dart';

import '../domain/profile.dart';
import '../domain/profile_repository.dart';
import 'widgets/profile_form.dart';
import 'widgets/profile_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({required this.repository, super.key});

  final ProfileRepository repository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Profile?>(
      stream: repository.watchProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _ProfileError(error: snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = snapshot.data;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ProfileHeader(profile: profile),
              const SizedBox(height: 16),
              ProfileForm(
                userId: repository.userId,
                profile: profile,
                onSave: repository.saveProfile,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileError extends StatelessWidget {
  const _ProfileError({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Could not load your profile.\n$error',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
