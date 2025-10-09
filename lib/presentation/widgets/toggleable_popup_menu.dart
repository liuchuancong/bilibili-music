import 'package:flutter/material.dart';

class MenuOption<T> {
  final String label;
  final T? value;
  MenuOption({required this.label, required this.value});
}

class NullableValue<T> {
  final T? value;
  NullableValue(this.value);

  @override
  bool operator ==(Object other) => identical(this, other) || other is NullableValue<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

typedef OnValueChanged<T> = void Function(T? value);

class ToggleablePopupMenu<T> extends StatelessWidget {
  final List<MenuOption<T>> options;
  final T? selectedValue;
  final OnValueChanged<T> onChanged;
  final Widget? icon;
  final String? tooltip;
  final bool isSelected;

  const ToggleablePopupMenu({
    super.key,
    required this.options,
    required this.selectedValue,
    required this.onChanged,
    this.icon,
    this.tooltip,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<NullableValue<T>>(
      tooltip: tooltip,
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(4),
      onSelected: (NullableValue<T> selected) {
        if (selected.value == selectedValue) {
          onChanged(null);
        } else {
          onChanged(selected.value);
        }
      },
      itemBuilder: (context) {
        return options.map((option) {
          final bool isSelected = option.value == selectedValue;
          return PopupMenuItem<NullableValue<T>>(
            value: NullableValue(option.value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  option.label,
                  style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.primary : null),
                ),
                const SizedBox(width: 4),
                if (isSelected) const Icon(Icons.check_rounded, size: 16),
                if (!isSelected) const SizedBox(width: 16), // 保持对齐
              ],
            ),
          );
        }).toList();
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: null,
          child: icon ??
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(
                  Icons.sort_rounded, size: 16,
                  color: isSelected ? Theme.of(context).colorScheme.primary : null, // 根据 isSelected 设置颜色
                ),
              ),
        ),
      ),
    );
  }
}
