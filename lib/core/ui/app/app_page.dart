import 'package:flutter/material.dart';

import '../adaptive_page_frame.dart';
import '../pixel/pixel_ui.dart';
import 'app_ui_style.dart';
import 'app_ui_theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Back',
          onPressed: onBack,
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(title),
      ),
      body: AdaptivePageFrame(
        portraitMaxWidth: portraitMaxWidth,
        builder: builder,
      ),
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
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        layout.isLandscape ? 24 : 16,
        24,
        layout.isLandscape ? 24 : 16,
        32,
      ),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: 24),
      itemBuilder: (_, index) => children[index],
    );
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
    final items = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      items.add(children[index]);
      if (showDividers && index != children.length - 1) {
        items.add(const Divider());
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(children: items),
        ),
      ],
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
    return Card(
      child: Padding(padding: padding, child: child),
    );
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
    return ListTile(title: Text(label), trailing: Text(value));
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
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
      trailing: const Icon(Icons.open_in_new),
      onTap: onPressed,
    );
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
    final ui = AppUiTheme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < values.length; index++) ...[
            Text(values[index], style: ui.body(color: ui.textSecondary)),
            if (index != values.length - 1) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}
