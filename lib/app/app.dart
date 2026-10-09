import 'package:flutter/material.dart';

import '../core/firebase/community_firebase.dart';
import '../core/firebase/personal_firebase.dart';
import '../features/community/data/firebase_community_repository.dart';
import '../features/community/domain/community_repository.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/profile/domain/profile_repository.dart';
import 'theme/node_theme.dart';

class CommunityNodeApp extends StatefulWidget {
  const CommunityNodeApp({
    super.key,
    this.profileRepository,
    this.communityRepository,
  });

  final ProfileRepository? profileRepository;
  final CommunityRepository? communityRepository;

  @override
  State<CommunityNodeApp> createState() => _CommunityNodeAppState();
}

class _CommunityNodeAppState extends State<CommunityNodeApp> {
  late final Future<_NodeDependencies> _dependencies = _createDependencies();

  Future<_NodeDependencies> _createDependencies() async {
    final profileRepository =
        widget.profileRepository ?? await PersonalFirebase.connect();
    final communityRepository =
        widget.communityRepository ??
        FirebaseCommunityRepository(CommunityFirebase());
    return _NodeDependencies(
      profileRepository: profileRepository,
      communityRepository: communityRepository,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Community Node',
      debugShowCheckedModeBanner: false,
      theme: NodeTheme.dark(),
      home: FutureBuilder<_NodeDependencies>(
        future: _dependencies,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return _PersonalSetupError(error: snapshot.error.toString());
          }
          if (!snapshot.hasData) return const _NodeSplash();
          return HomeScreen(
            profileRepository: snapshot.data!.profileRepository,
            communityRepository: snapshot.data!.communityRepository,
          );
        },
      ),
    );
  }
}

class _NodeDependencies {
  const _NodeDependencies({
    required this.profileRepository,
    required this.communityRepository,
  });

  final ProfileRepository profileRepository;
  final CommunityRepository communityRepository;
}

class _NodeSplash extends StatelessWidget {
  const _NodeSplash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.hub_outlined, size: 72, color: NodeColors.cyan),
            SizedBox(height: 22),
            Text(
              'MY COMMUNITY NODE',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text('Flutter + Firebase'),
            SizedBox(height: 4),
            Text(
              'Build your node. Join the network.',
              style: TextStyle(color: Colors.white54),
            ),
            SizedBox(height: 26),
            SizedBox.square(
              dimension: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonalSetupError extends StatelessWidget {
  const _PersonalSetupError({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.settings_suggest_outlined, size: 52),
                    const SizedBox(height: 16),
                    Text(
                      'Personal Firebase setup required',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Enable Anonymous Authentication and create Cloud Firestore for the [DEFAULT] Firebase project.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    Text(
                      error,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
