import 'package:flutter/material.dart';

/// Lightweight RadioGroup wrapper to centralize selection state and callbacks.
/// This mirrors the emerging pattern of grouping radios without passing
/// groupValue/onChanged in each widget, while remaining compatible with
/// current Flutter versions.
class AppRadioGroup<T> extends InheritedWidget {
  const AppRadioGroup({
    super.key,
    required this.selected,
    required this.onChanged,
    required super.child,
  });

  final T? selected;
  final ValueChanged<T?> onChanged;

  static AppRadioGroup<T>? maybeOf<T>(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppRadioGroup<T>>();
  }

  static AppRadioGroup<T> of<T>(BuildContext context) {
    final group = maybeOf<T>(context);
    assert(group != null, 'No AppRadioGroup<$T> found in context');
    return group!;
  }

  @override
  bool updateShouldNotify(AppRadioGroup<T> oldWidget) {
    return oldWidget.selected != selected || oldWidget.onChanged != onChanged;
  }
}

class AppRadio<T> extends StatelessWidget {
  const AppRadio({
    super.key,
    required this.value,
    this.activeColor,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
    this.fillColor,
    this.onSelected,
  });

  final T value;
  final Color? activeColor;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final WidgetStateProperty<Color?>? fillColor;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final group = AppRadioGroup.of<T>(context);
    return Radio<T>(
      value: value,
      // Centralize deprecated usage inside one place only
      // ignore: deprecated_member_use
      groupValue: group.selected,
      // ignore: deprecated_member_use
      onChanged: (val) {
        group.onChanged(val);
        if (val == value) {
          onSelected?.call();
        }
      },
      activeColor: activeColor,
      materialTapTargetSize: materialTapTargetSize,
      visualDensity: visualDensity,
      focusNode: focusNode,
      autofocus: autofocus,
      fillColor: fillColor,
    );
  }
}

class AppRadioListTile<T> extends StatelessWidget {
  const AppRadioListTile({
    super.key,
    required this.value,
    required this.title,
    this.subtitle,
    this.secondary,
    this.contentPadding,
    this.dense,
    this.visualDensity,
    this.controlAffinity = ListTileControlAffinity.platform,
    this.activeColor,
    this.onSelected,
  });

  final T value;
  final Widget title;
  final Widget? subtitle;
  final Widget? secondary;
  final EdgeInsetsGeometry? contentPadding;
  final bool? dense;
  final VisualDensity? visualDensity;
  final ListTileControlAffinity controlAffinity;
  final Color? activeColor;
  final VoidCallback? onSelected;

  @override
  Widget build(BuildContext context) {
    final group = AppRadioGroup.of<T>(context);
    return RadioListTile<T>(
      value: value,
      // ignore: deprecated_member_use
      groupValue: group.selected,
      // ignore: deprecated_member_use
      onChanged: (val) {
        group.onChanged(val);
        if (val == value) {
          onSelected?.call();
        }
      },
      title: title,
      subtitle: subtitle,
      secondary: secondary,
      contentPadding: contentPadding,
      dense: dense,
      visualDensity: visualDensity,
      controlAffinity: controlAffinity,
      activeColor: activeColor,
    );
  }
}
