import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/widgets/app_button.dart';
import 'package:startup_app/core/widgets/app_text_field.dart';
import 'package:startup_app/core/widgets/error_view.dart';
import 'package:startup_app/features/auth/presentation/bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            LoginRequestedEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.go('/home');
          } else if (state.status == AuthStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: theme.colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state.status == AuthStatus.loading;
          final hasError =
              state.status == AuthStatus.failure && state.errorMessage != null;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Xush kelibsiz',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Akkauntingizga kiring',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      if (hasError) ...[
                        ErrorView(
                          message: state.errorMessage!,
                          onRetry: _onLogin,
                        ),
                        const SizedBox(height: 16),
                      ],
                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        hint: 'example@domain.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email kiriting';
                          }
                          if (!value.contains('@')) {
                            return 'Yaroqli email kiriting';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Parol',
                        isPassword: true,
                        prefixIcon: const Icon(Icons.lock_outline),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Parol kiriting';
                          }
                          if (value.length < 6) {
                            return 'Parol kamida 6 belgidan iborat bo\'lishi kerak';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        text: 'Kirish',
                        isLoading: isLoading,
                        onPressed: _onLogin,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
