import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {super.key,
      this.hintText,
      this.label,
      this.prefix,
      required this.isPassword,
      this.onChange,
      this.validator,
      required this.controller});
  final String? hintText;
  final String? label;
  final Function(String)? onChange;
  final FormFieldValidator<String>? validator;
  final IconData? prefix;
  final bool isPassword;
  final TextEditingController controller;
  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
    final defaultPadding = EdgeInsets.symmetric(horizontal: 15);
    return Padding(
      padding: defaultPadding,
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword ? _isObscure : false,
        onChanged: widget.onChange,
        validator: widget.validator,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        }, //remove keyboard when tapping on screen

        // on subit make next foucus
        decoration: InputDecoration(
            hintText: widget.hintText,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500),
                borderRadius: BorderRadius.circular(15)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(15)),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.all(5),
            prefixIcon: widget.prefix != null
                ? Icon(widget.prefix, color: Colors.grey)
                : null,
            suffix: widget.isPassword == true
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure != _isObscure;
                      });
                    },
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off))
                : null,
            labelText: widget.label,
            prefixIconColor: Colors.grey[400],
            suffixIconColor: Colors.blue,
            hintStyle: TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100]),
      ),
    );
  }
}
