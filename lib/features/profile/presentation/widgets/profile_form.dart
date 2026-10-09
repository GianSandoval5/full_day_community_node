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

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile?.name);
    _role = TextEditingController(text: widget.profile?.role);
    _community = TextEditingController(text: widget.profile?.community);
    _bio = TextEditingController(text: widget.profile?.bio);
  }

  @override
  void didUpdateWidget(covariant ProfileForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile == null && widget.profile != null) {
      _name.text = widget.profile!.name;
      _role.text = widget.profile!.role;
      _community.text = widget.profile!.community;
      _bio.text = widget.profile!.bio;
    }
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
              Text('MY SPACE', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              Text(
                'Build your identity',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
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
                controller: _role,
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
                controller: _community,
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
                controller: _bio,
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
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cloud_upload_outlined),
                label: Text(_saving ? 'Saving...' : 'Save profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
