import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_routes.dart';
import 'package:startup_app/core/theme/theme_cubit.dart';
import 'package:startup_app/core/widgets/app_button.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:startup_app/features/organization/domain/entities/organization.dart';
import 'package:startup_app/features/organization/presentation/bloc/organization_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _onLogout(BuildContext context) {
    try {
      context.read<OrganizationBloc>().add(const ClearOrganizationEvent());
    } catch (_) {}
    context.read<AuthBloc>().add(const LogoutRequestedEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Organization? selectedOrg;
    try {
      selectedOrg =
          context.watch<OrganizationBloc>().state.selectedOrganization;
    } catch (_) {
      selectedOrg = null;
    }

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          context.go('/login');
        }
      },
      builder: (context, state) {
        final user = state.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Bosh sahifa'),
            actions: [
              IconButton(
                key: const Key('home_profile_button'),
                tooltip: 'Profil',
                icon: const Icon(Icons.person_outline),
                onPressed: () {
                  context.push(AppRoutes.profile);
                },
              ),
              IconButton(
                tooltip: 'Mavzuni almashtirish',
                icon: const Icon(Icons.brightness_6),
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
              ),
              IconButton(
                tooltip: 'Chiqish',
                icon: const Icon(Icons.logout),
                onPressed: () => _onLogout(context),
              ),
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Muvaffaqiyatli kirdingiz!',
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? 'Foydalanuvchi',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  if (selectedOrg != null) ...[
                    Chip(
                      avatar: const Icon(Icons.business, size: 18),
                      label: Text(selectedOrg.name),
                    ),
                    const SizedBox(height: 8),
                  ],
                  TextButton.icon(
                    key: const Key('switch_organization_button'),
                    onPressed: () {
                      context.push(AppRoutes.organization);
                    },
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(
                      selectedOrg != null
                          ? 'Tashkilotni almashtirish'
                          : 'Tashkilot tanlash',
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    text: 'Chiqish',
                    isOutlined: true,
                    onPressed: () => _onLogout(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
