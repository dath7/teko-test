import 'package:flutter/material.dart';

// validate on typing
class CustomTextFormField extends StatefulWidget {
  final void Function(String)? onChanged;
  final bool Function(String?)? validator;
  final String? Function(String?)? errorText;
  final bool isOnlyNumber;
  final bool isAutoFocus;


  const CustomTextFormField({
    super.key, 
    required this.onChanged,
    this.validator, 
    this.errorText, 
    this.isOnlyNumber = false,
    this.isAutoFocus = false

  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isValid = true;
  ValueNotifier<String?> errorText = ValueNotifier(null);
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        TextFormField(
          onChanged: (value) {
            widget.onChanged?.call(value);
            final valid = widget.validator?.call(value) ?? true;
            errorText.value = widget.errorText?.call(value);
            if (valid != isValid) {
              setState(() {
                isValid = valid;
              });
            }
          },
          controller: _controller,
          autofocus: widget.isAutoFocus,
          onTapOutside: (_) {
            FocusScope.of(context).unfocus();
          },
          style: Theme.of(context).textTheme.bodySmall,
          keyboardType: widget.isOnlyNumber 
            ? TextInputType.numberWithOptions() 
            : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isValid 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: errorText, 
          builder: (context, value, child) {
            return value == null ? SizedBox() : Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
            );
          }
        )
      ],
    );
  }
}