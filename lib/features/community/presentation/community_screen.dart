import 'package:flutter/material.dart';

import '../../profile/domain/profile.dart';
import '../domain/community_message.dart';
import '../domain/community_repository.dart';
import 'widgets/community_header.dart';
import 'widgets/empty_community_state.dart';
import 'widgets/message_card.dart';
import 'widgets/message_composer.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({
    required this.profile,
    required this.repository,
    super.key,
  });

  final Profile profile;
  final CommunityRepository repository;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late Future<void> _joinFuture;

  @override
  void initState() {
    super.initState();
    _joinFuture = widget.repository.join(widget.profile);
  }

  @override
  void didUpdateWidget(covariant CommunityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile != widget.profile) {
      _joinFuture = widget.repository.join(widget.profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _joinFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _JoinError(
            error: snapshot.error.toString(),
            onRetry: () => setState(() {
              _joinFuture = widget.repository.join(widget.profile);
            }),
          );
        }
        if (snapshot.connectionState != ConnectionState.done) {
          return const _JoiningState();
        }
        return _ConnectedCommunity(repository: widget.repository);
      },
    );
  }
}

class _ConnectedCommunity extends StatelessWidget {
  const _ConnectedCommunity({required this.repository});

  final CommunityRepository repository;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          StreamBuilder<int>(
            stream: repository.watchParticipantsCount(),
            builder: (context, snapshot) {
              return CommunityHeader(participantsCount: snapshot.data ?? 0);
            },
          ),
          const SizedBox(height: 14),
          Expanded(
            child: StreamBuilder<List<CommunityMessage>>(
              stream: repository.watchMessages(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Could not load messages.\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final messages = snapshot.data!;
                if (messages.isEmpty) return const EmptyCommunityState();
                return ListView.builder(
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) =>
                      MessageCard(message: messages[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          MessageComposer(onSend: repository.sendMessage),
        ],
      ),
    );
  }
}

class _JoiningState extends StatelessWidget {
  const _JoiningState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 18),
          Text('Joining the Community Hub...'),
          SizedBox(height: 6),
          Text('Creating your second Firebase session.'),
        ],
      ),
    );
  }
}

class _JoinError extends StatelessWidget {
  const _JoinError({required this.error, required this.onRetry});

  final String error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 52),
            const SizedBox(height: 14),
            Text(
              'Could not join the Community Hub',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 18),
            FilledButton.tonal(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}
