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
    return Container(
      width: double.infinity,
      height: 71,
      padding: const EdgeInsets.symmetric(horizontal: 22),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x59000000), width: 2)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: -10,
            top: 11.5,
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
                      child: PixelIcon(
                        kind: PixelIconKind.settingsBack,
                        color: Color(0xFFFFFDF7),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          IgnorePointer(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                title,
                style: tokens
                    .heading(fontSize: 31)
                    .copyWith(
                      color: const Color(0xFFFFFDF7),
                      height: 1,
                      letterSpacing: -0.62,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
