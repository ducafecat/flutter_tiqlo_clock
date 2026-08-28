import 'package:flutter/material.dart';

import '../adaptive_page_frame.dart';
import '../pixel/pixel_ui.dart';
import '../standard/standard_ui.dart';
import 'app_ui_style.dart';

typedef AppPageBodyBuilder =
    Widget Function(BuildContext context, AdaptivePageLayout layout);

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.onBack,
    required this.portraitMaxWidth,
    required this.builder,
  });

  final String title;
  final VoidCallback onBack;
  final double portraitMaxWidth;
  final AppPageBodyBuilder builder;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelPageScaffold(
        title: title,
        onBack: onBack,
        portraitMaxWidth: portraitMaxWidth,
        builder: builder,
      );
    }
    return StandardPageScaffold(
      title: title,
      onBack: onBack,
      portraitMaxWidth: portraitMaxWidth,
      builder: builder,
    );
  }
}

class AppPageList extends StatelessWidget {
  const AppPageList({super.key, required this.layout, required this.children});

  final AdaptivePageLayout layout;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelPageList(layout: layout, children: children);
    }
    return StandardPageList(layout: layout, children: children);
  }
}

class AppSection extends StatelessWidget {
  const AppSection({
    super.key,
    required this.title,
    required this.children,
    this.showDividers = true,
  });

  final String title;
  final List<Widget> children;
  final bool showDividers;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelSection(
        title: title,
        showDividers: showDividers,
        children: children,
      );
    }
    return StandardSection(
      title: title,
      showDividers: showDividers,
      children: children,
    );
  }
}

class AppPanel extends StatelessWidget {
  const AppPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelPanel(padding: padding, child: child);
    }
    return StandardPanel(padding: padding, child: child);
  }
}

class AppInfoRow extends StatelessWidget {
  const AppInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelInfoRow(label: label, value: value);
    }
    return StandardInfoRow(label: label, value: value);
  }
}

class AppLinkTile extends StatelessWidget {
  const AppLinkTile({
    super.key,
    required this.label,
    required this.value,
    required this.onPressed,
  });

  final String label;
  final String value;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelLinkTile(label: label, value: value, onPressed: onPressed);
    }
    return StandardLinkTile(label: label, value: value, onPressed: onPressed);
  }
}

class AppTextList extends StatelessWidget {
  const AppTextList({super.key, required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    if (AppUiScope.of(context) == AppUiStyle.pixel) {
      return PixelTextList(values: values);
    }
    return StandardTextList(values: values);
  }
}
