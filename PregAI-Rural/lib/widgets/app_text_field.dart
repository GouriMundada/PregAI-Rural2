import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable labeled text field used across all forms (registration,
/// ANC entry, etc). Supports basic validation, read-only mode (for
/// date pickers), multiline notes, and a leading icon.
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final IconData? icon;
  final TextInputType keyboardType;
  final bool isRequired;
  final bool readOnly;
  final int maxLines;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.icon,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.onTap,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppMetrics.spaceM),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        maxLines: maxLines,
        onTap: onTap,
        style: const TextStyle(color: AppColors.darkText, fontSize: 16),
        validator: validator ??
            (isRequired
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '$label is required';
                    }
                    return null;
                  }
                : null),
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }
}

/// Reusable dropdown field, styled to match AppTextField.
class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?> onChanged;
  final IconData? icon;
  final bool isRequired;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.itemLabel,
    required this.onChanged,
    this.icon,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppMetrics.spaceM),
      child: DropdownButtonFormField<T>(
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          prefixIcon: icon != null ? Icon(icon, color: AppColors.primary) : null,
        ),
        items: items
            .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                ))
            .toList(),
        onChanged: onChanged,
        validator: isRequired
            ? (v) => v == null ? '$label is required' : null
            : null,
      ),
    );
  }
}
