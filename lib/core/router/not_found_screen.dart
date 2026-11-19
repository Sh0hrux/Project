import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:startup_app/core/router/app_routes.dart';
import 'package:startup_app/core/widgets/error_view.dart';

class NotFoundScreen extends StatelessWidget {
  final String uri;

  const NotFoundScreen({super.key, required this.uri});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('404 - Sahifa topilmadi'),
      ),
      body: ErrorView(
        message: 'Kechirasiz, "$uri" manzili bo\'yicha sahifa topilmadi.',
        onRetry: () => context.go(AppRoutes.home),
      ),
    );
  }
}
