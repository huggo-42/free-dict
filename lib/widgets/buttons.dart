import 'package:flutter/material.dart';

class FilledButtonWidget extends StatelessWidget {
  const FilledButtonWidget({
    super.key,
    required this.onPressed,
    required this.isLoading,
    required this.label,
    this.child,
  });

  final VoidCallback onPressed;
  final bool isLoading;
  final String label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _child,
    );
  }

  Widget get _child {
    return !isLoading
        ? Text(label)
        : const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          );
  }
}
