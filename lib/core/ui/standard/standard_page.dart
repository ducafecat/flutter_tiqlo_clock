import 'package:flutter/material.dart';

import '../adaptive_page_frame.dart';
import 'standard_tokens.dart';

typedef StandardPageBodyBuilder =
    Widget Function(BuildContext context, AdaptivePageLayout layout);

class StandardPageScaffold extends StatelessWidget {
  const StandardPageScaffold({
    super.key,
    required this.title,
    required this.onBack,
    required this.portraitMaxWidth,
    required this.builder,
  });

  final String title;
  final VoidCallback onBack;
  final double portraitMaxWidth;
  final StandardPageBodyBuilder builder;

  @override
  Widget build(BuildContext context) {
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

class StandardPageList extends StatelessWidget {
  const StandardPageList({
    super.key,
    required this.layout,
    required this.children,
  });

  final AdaptivePageLayout layout;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        layout.isLandscape ? StandardSpacing.lg : StandardSpacing.md,
        StandardSpacing.md,
        layout.isLandscape ? StandardSpacing.lg : StandardSpacing.md,
        StandardSpacing.lg,
      ),
      itemCount: children.length,
      separatorBuilder: (_, _) => const SizedBox(height: StandardSpacing.md),
      itemBuilder: (_, index) => children[index],
    );
  }
}

class StandardSectionHeader extends StatelessWidget {
  const StandardSectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title.toUpperCase(),
              style: StandardTextStyles.labelOn(context),
            ),
          ),
          if (trailing case final Widget widget) widget,
        ],
      ),
    );
  }
}

class StandardSettingsTile extends StatelessWidget {
  const StandardSettingsTile({
    super.key,
    required this.label,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String label;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: StandardSpacing.md,
          vertical: 14,
        ),
        child: Row(
          children: [
            if (leading case final Widget widget) ...[
              widget,
              const SizedBox(width: StandardSpacing.sm),
            ],
            Expanded(
              child: Text(label, style: StandardTextStyles.bodyOn(context)),
            ),
            if (trailing case final Widget widget) widget,
          ],
        ),
      ),
    );
  }
}

class StandardSettingsGroup extends StatelessWidget {
  const StandardSettingsGroup({
    super.key,
    required this.children,
    this.showDividers = true,
  });

  final List<Widget> children;
  final bool showDividers;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = theme.colorScheme.onSurface.withValues(alpha: 0.12);
    final items = <Widget>[];
    for (var index = 0; index < children.length; index++) {
      final child = children[index];
      if (showDividers && index != children.length - 1) {
        items.add(
          Stack(
            children: [
              child,
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: ColoredBox(
                    color: line,
                    child: const SizedBox(height: 1, width: double.infinity),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        items.add(child);
      }
    }
    return Material(
      color: theme.colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: StandardRadius.card),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: items,
      ),
    );
  }
}

class StandardSection extends StatelessWidget {
  const StandardSection({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StandardSectionHeader(title: title),
        const SizedBox(height: StandardSpacing.sm),
        StandardSettingsGroup(showDividers: showDividers, children: children),
      ],
    );
  }
}

class StandardPanel extends StatelessWidget {
  const StandardPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(StandardSpacing.md),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: StandardRadius.card),
      clipBehavior: Clip.hardEdge,
      child: Padding(padding: padding, child: child),
    );
  }
}

class StandardInfoRow extends StatelessWidget {
  const StandardInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      minTileHeight: 44,
      title: Text(label, style: StandardTextStyles.bodyOn(context)),
      trailing: Text(value, style: StandardTextStyles.secondaryOn(context)),
    );
  }
}

class StandardLinkTile extends StatelessWidget {
  const StandardLinkTile({
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
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(label, style: StandardTextStyles.bodyOn(context)),
      subtitle: Text(value, style: StandardTextStyles.metaOn(context)),
      trailing: Icon(
        Icons.open_in_new,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      onTap: onPressed,
    );
  }
}

class StandardTextList extends StatelessWidget {
  const StandardTextList({super.key, required this.values});

  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(StandardSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < values.length; index++) ...[
              Text(
                values[index],
                style: StandardTextStyles.secondaryOn(context),
              ),
              if (index != values.length - 1)
                const SizedBox(height: StandardSpacing.xs),
            ],
          ],
        ),
      ),
    );
  }
}
