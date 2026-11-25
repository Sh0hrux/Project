import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_routes.dart';
import 'package:startup_app/core/theme/theme_cubit.dart';
import 'package:startup_app/core/widgets/app_button.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                onPressed: () {
                  context.read<AuthBloc>().add(const LogoutRequestedEvent());
                },
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
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Chiqish',
                    isOutlined: true,
                    onPressed: () {
                      context.read<AuthBloc>().add(const LogoutRequestedEvent());
                    },
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
