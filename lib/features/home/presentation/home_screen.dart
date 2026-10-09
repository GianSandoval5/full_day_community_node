import 'package:flutter/material.dart';

import '../../community/domain/community_repository.dart';
import '../../community/presentation/community_screen.dart';
import '../../profile/domain/profile.dart';
import '../../profile/domain/profile_repository.dart';
import '../../profile/presentation/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    required this.profileRepository,
    required this.communityRepository,
    super.key,
  });

  final ProfileRepository profileRepository;
  final CommunityRepository communityRepository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 800;
        final content = _selectedIndex == 0
            ? ProfileScreen(repository: widget.profileRepository)
            : _CommunityDestination(
                profileRepository: widget.profileRepository,
                communityRepository: widget.communityRepository,
              );

        return Scaffold(
          appBar: AppBar(
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MY COMMUNITY NODE',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
                Text(
                  'Build your node · Join the network',
                  style: TextStyle(fontSize: 11, color: Colors.white54),
                ),
              ],
            ),
          ),
          body: desktop
              ? Row(
                  children: [
                    NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (index) {
                        setState(() => _selectedIndex = index);
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.person_outline),
                          selectedIcon: Icon(Icons.person_rounded),
                          label: Text('My Space'),
                        ),
                        NavigationRailDestination(
                          icon: Icon(Icons.public_outlined),
                          selectedIcon: Icon(Icons.public_rounded),
                          label: Text('Community'),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(child: content),
                  ],
                )
              : content,
          bottomNavigationBar: desktop
              ? null
              : NavigationBar(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person_rounded),
                      label: 'My Space',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.public_outlined),
                      selectedIcon: Icon(Icons.public_rounded),
                      label: 'Community',
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _CommunityDestination extends StatelessWidget {
  const _CommunityDestination({
    required this.profileRepository,
    required this.communityRepository,
  });

  final ProfileRepository profileRepository;
  final CommunityRepository communityRepository;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Profile?>(
      stream: profileRepository.watchProfile(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Could not read your profile: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return const _ProfileRequired();
        }
        return CommunityScreen(
          profile: snapshot.data!,
          repository: communityRepository,
        );
      },
    );
  }
}

class _ProfileRequired extends StatelessWidget {
  const _ProfileRequired();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_add_alt_1_outlined, size: 50),
                  const SizedBox(height: 16),
                  Text(
                    'Build My Space first',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Your name, role, and community will become your identity in the shared network.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
