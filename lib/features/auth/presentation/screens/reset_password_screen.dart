import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_routes.dart';
import 'package:startup_app/core/utils/validators.dart';
import 'package:startup_app/core/widgets/app_button.dart';
import 'package:startup_app/core/widgets/app_text_field.dart';
import 'package:startup_app/core/widgets/error_view.dart';
import 'package:startup_app/features/auth/presentation/bloc/forgot_password_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onReset() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordBloc>().add(
            ResetPasswordSubmittedEvent(
              newPassword: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Yangi parol')),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success &&
              state.step == ForgotPasswordStep.completed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Parol muvaffaqiyatli yangilandi!'),
              ),
            );
            context.go(AppRoutes.login);
          }
        },
        builder: (context, state) {
          final isLoading = state.status == ForgotPasswordStatus.loading;
          final hasError = state.status == ForgotPasswordStatus.failure &&
              state.errorMessage != null;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Yangi parol o\'rnating',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Parol kamida 6 belgidan iborat bo\'lishi kerak',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    if (hasError) ...[
                      ErrorView(
                        message: state.errorMessage!,
                        onRetry: _onReset,
                      ),
                      const SizedBox(height: 16),
                    ],
                    AppTextField(
                      key: const Key('reset_new_password_input'),
                      controller: _passwordController,
                      label: 'Yangi parol',
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: Validators.validatePassword,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      key: const Key('reset_confirm_password_input'),
                      controller: _confirmPasswordController,
                      label: 'Parolni tasdiqlang',
                      isPassword: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (val) => Validators.validateConfirmPassword(
                        val,
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      key: const Key('reset_password_submit_button'),
                      text: 'Parolni saqlash',
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _onReset,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
