import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_routes.dart';
import 'package:startup_app/core/utils/validators.dart';
import 'package:startup_app/core/widgets/app_button.dart';
import 'package:startup_app/core/widgets/app_text_field.dart';
import 'package:startup_app/core/widgets/error_view.dart';
import 'package:startup_app/features/auth/presentation/bloc/forgot_password_bloc.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onVerify() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<ForgotPasswordBloc>().add(
            VerifyResetCodeEvent(code: _codeController.text.trim()),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Kodni tasdiqlash')),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state.status == ForgotPasswordStatus.success &&
              state.step == ForgotPasswordStep.resetPassword) {
            context.go(AppRoutes.resetPassword);
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
                      'Tasdiqlash kodini kiriting',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.email} manziliga yuborilgan 6 xonali kodni kiriting (Mock: 123456)',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    if (hasError) ...[
                      ErrorView(
                        message: state.errorMessage!,
                        onRetry: _onVerify,
                      ),
                      const SizedBox(height: 16),
                    ],
                    AppTextField(
                      key: const Key('verify_code_input'),
                      controller: _codeController,
                      label: 'Tasdiqlash kodi',
                      hint: '123456',
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.pin_outlined),
                      validator: Validators.validateResetCode,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      key: const Key('verify_code_button'),
                      text: 'Tasdiqlash',
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _onVerify,
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
