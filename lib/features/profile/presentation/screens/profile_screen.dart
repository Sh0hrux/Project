import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:startup_app/core/widgets/app_button.dart';
import 'package:startup_app/core/widgets/app_text_field.dart';
import 'package:startup_app/core/widgets/error_view.dart';
import 'package:startup_app/core/widgets/loading_indicator.dart';
import 'package:startup_app/features/profile/presentation/bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProfileBloc>();
    if (bloc.state.profile == null) {
      bloc.add(const LoadProfileEvent());
    } else {
      _nameController.text = bloc.state.profile!.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggleEdit(String currentName) {
    setState(() {
      _isEditing = !_isEditing;
      if (_isEditing) {
        _nameController.text = currentName;
      }
    });
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ProfileBloc>().add(
            UpdateProfileEvent(name: _nameController.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.profile == null) return const SizedBox.shrink();
              return IconButton(
                key: const Key('profile_edit_toggle_button'),
                tooltip: _isEditing ? 'Bekor qilish' : 'Tahrirlash',
                icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined),
                onPressed: () => _toggleEdit(state.profile!.name),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.loaded && _isEditing) {
            setState(() {
              _isEditing = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profil muvaffaqiyatli saqlandi')),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading && state.profile == null) {
            return const LoadingIndicator(message: 'Profil yuklanmoqda...');
          }

          if (state.status == ProfileStatus.failure && state.profile == null) {
            return ErrorView(
              message: state.errorMessage ?? 'Xatolik yuz berdi',
              onRetry: () =>
                  context.read<ProfileBloc>().add(const LoadProfileEvent()),
            );
          }

          final profile = state.profile;
          if (profile == null) {
            return const SizedBox.shrink();
          }

          final isUpdating = state.status == ProfileStatus.updating;
          final initialLetter = profile.name.isNotEmpty
              ? profile.name[0].toUpperCase()
              : (profile.email.isNotEmpty ? profile.email[0].toUpperCase() : '?');

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 48,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      backgroundImage: profile.avatarUrl != null &&
                              profile.avatarUrl!.isNotEmpty
                          ? NetworkImage(profile.avatarUrl!)
                          : null,
                      child: (profile.avatarUrl == null ||
                              profile.avatarUrl!.isEmpty)
                          ? Text(
                              initialLetter,
                              style: theme.textTheme.headlineLarge?.copyWith(
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state.status == ProfileStatus.failure &&
                      state.errorMessage != null) ...[
                    ErrorView(
                      message: state.errorMessage!,
                      onRetry: _isEditing ? _onSave : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_isEditing)
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          AppTextField(
                            key: const Key('profile_name_input'),
                            controller: _nameController,
                            label: 'Ism',
                            prefixIcon: const Icon(Icons.person_outline),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Ism kiriting';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          AppButton(
                            key: const Key('profile_save_button'),
                            text: 'Saqlash',
                            isLoading: isUpdating,
                            onPressed: isUpdating ? null : _onSave,
                          ),
                        ],
                      ),
                    )
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ism',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.name,
                              key: const Key('profile_name_text'),
                              style: theme.textTheme.titleMedium,
                            ),
                            const Divider(height: 24),
                            Text(
                              'Email',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              profile.email,
                              key: const Key('profile_email_text'),
                              style: theme.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
