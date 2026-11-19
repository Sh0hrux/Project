import 'package:flutter/material.dart';
import 'package:startup_app/core/widgets/loading_indicator.dart';

class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Colors.black45,
              child: Center(
                child: SingleChildScrollView(
                  child: LoadingIndicator(message: message),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
