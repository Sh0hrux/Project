import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_routes.dart';
import 'package:startup_app/core/utils/validators.dart';
import 'package:startup_app/core/widgets/app_button.dart';
import 'package:startup_app/core/widgets/app_text_field.dart';
import 'package:startup_app/core/widgets/error_view.dart';
import 'package:startup_app/features/auth/presentation/bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordBloc>().add(
            SendResetCodeEvent(email: _emailController.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Parolni tiklash')),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success &&
              state.step == ForgotPasswordStep.verifyCode) {
            context.go(AppRoutes.verifyCode);
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
                      'Email manzilingizni kiriting',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tasdiqlash kodi emailingizga yuboriladi',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    if (hasError) ...[
                      ErrorView(
                        message: state.errorMessage!,
                        onRetry: _onSubmit,
                      ),
                      const SizedBox(height: 16),
                    ],
                    AppTextField(
                      key: const Key('forgot_email_input'),
                      controller: _emailController,
                      label: 'Email',
                      hint: 'example@domain.com',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      key: const Key('forgot_send_code_button'),
                      text: 'Kod yuborish',
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _onSubmit,
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
