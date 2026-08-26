import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pixel_icon.dart';
import 'pixel_tokens.dart';

class PixelPageHeader extends StatelessWidget {
  const PixelPageHeader({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final tokens = PixelTokens.of(context);
    return SizedBox(
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            top: 4,
            width: 48,
            height: 48,
            child: Semantics(
              container: true,
              button: true,
              label: 'Back',
              onTap: onBack,
              child: ExcludeSemantics(
                child: FocusableActionDetector(
                  shortcuts: const {
                    SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
                    SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
                  },
                  actions: {
                    ActivateIntent: CallbackAction<ActivateIntent>(
                      onInvoke: (_) => onBack(),
                    ),
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onBack,
                    child: const Center(
                      child: PixelIcon(kind: PixelIconKind.back, size: 30),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Text(title, style: tokens.heading(fontSize: 26)),
        ],
      ),
    );
  }
}
