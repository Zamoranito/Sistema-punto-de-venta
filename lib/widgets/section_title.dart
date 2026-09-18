import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  // Acción mediante texto
  final String? actionText;
  final VoidCallback? onAction;

  // Acción mediante widget personalizado
  final Widget? action;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    Widget? actionWidget;

    if (action != null) {
      actionWidget = action;
    } else if (actionText != null && onAction != null) {
      actionWidget = TextButton(
        onPressed: onAction,
        child: Text(actionText!),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
              ],
            ],
          ),
        ),
        if (actionWidget != null) ...[
          const SizedBox(width: 12),
          actionWidget,
        ],
      ],
    );
  }
}