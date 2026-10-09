import 'package:flutter/material.dart';

import '../../../../core/validation/field_validators.dart';
import '../../domain/profile.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    required this.userId,
    required this.profile,
    required this.onSave,
    super.key,
  });

  final String userId;
  final Profile? profile;
  final Future<void> Function(Profile profile) onSave;

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _role;
  late final TextEditingController _community;
  late final TextEditingController _bio;
  bool _saving = false;
  late bool _editing;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile?.name);
    _role = TextEditingController(text: widget.profile?.role);
    _community = TextEditingController(text: widget.profile?.community);
    _bio = TextEditingController(text: widget.profile?.bio);
    _editing = widget.profile == null;
  }

  @override
  void didUpdateWidget(covariant ProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    final profile = widget.profile;
    final profileChanged = oldWidget.profile != profile;
    if (profile != null &&
        profileChanged &&
        (!_editing || oldWidget.profile == null)) {
      _syncControllers(profile);
      _editing = false;
    }
  }

  void _syncControllers(Profile profile) {
    _name.text = profile.name;
    _role.text = profile.role;
    _community.text = profile.community;
    _bio.text = profile.bio;
  }

  @override
  void dispose() {
    _name.dispose();
    _role.dispose();
    _community.dispose();
    _bio.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _saving = true);
    try {
      await widget.onSave(
        Profile(
          uid: widget.userId,
          name: _name.text.trim(),
          role: _role.text.trim(),
          community: _community.text.trim(),
          bio: _bio.text.trim(),
          createdAt: widget.profile?.createdAt,
          updatedAt: widget.profile?.updatedAt,
        ),
      );
      if (!mounted) return;
      setState(() => _editing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your node profile is synced.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not save: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _enableEditing() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _editing = true);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MY SPACE',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _editing ? 'Build your identity' : 'Profile saved',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (!_editing) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Use the pencil to edit your profile.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (!_editing)
                    IconButton.filledTonal(
                      key: const Key('profile-edit-button'),
                      tooltip: 'Edit profile',
                      onPressed: _enableEditing,
                      icon: const Icon(Icons.edit_rounded),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('profile-name-field'),
                controller: _name,
                readOnly: !_editing,
                enabled: !_saving,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) =>
                    FieldValidators.requiredText(value, label: 'Name'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: const Key('profile-role-field'),
                controller: _role,
                readOnly: !_editing,
                enabled: !_saving,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Role',
                  prefixIcon: Icon(Icons.code_rounded),
                ),
                validator: (value) =>
                    FieldValidators.requiredText(value, label: 'Role'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: const Key('profile-community-field'),
                controller: _community,
                readOnly: !_editing,
                enabled: !_saving,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Community',
                  prefixIcon: Icon(Icons.groups_outlined),
                ),
                validator: (value) =>
                    FieldValidators.requiredText(value, label: 'Community'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                key: const Key('profile-bio-field'),
                controller: _bio,
                readOnly: !_editing,
                enabled: !_saving,
                maxLength: 240,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  prefixIcon: Icon(Icons.notes_rounded),
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    FieldValidators.optionalText(value, label: 'Bio'),
              ),
              const SizedBox(height: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _editing
                    ? FilledButton.icon(
                        key: const Key('profile-save-button'),
                        onPressed: _saving ? null : _save,
                        icon: _saving
                            ? const SizedBox.square(
                                dimension: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.cloud_upload_outlined),
                        label: Text(_saving ? 'Saving...' : 'Save profile'),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
