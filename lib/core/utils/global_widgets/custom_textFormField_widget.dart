import 'package:flutter/material.dart';
import 'package:notsy/core/utils/helper/extension_function/size_extension.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
    this.suffixIcon,
    this.suffixIconOnPressed,
    this.labelText,
    this.readOnly,
    this.hintStyle,
    this.maxLines,
    this.onChange,
  });
  Icon? suffixIcon;
  void Function(String)? onChange;
  void Function()? suffixIconOnPressed;
  int? maxLines;
  TextEditingController? controller;
  String? label;
  String? hintText;
  bool? readOnly = false;
  String? Function(String?)? validator;
  TextInputType? keyboardType;
  String? labelText;
  TextStyle? hintStyle = TextStyle(
    fontSize: 13.w,
    fontWeight: FontWeight.w400,
    color: Color(0xffb3b6ba),
  );
  void Function(String)? onFieldSubmitted;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label ?? "",
            style: TextStyle(
              color: Color(0xff4B5563),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: onChange,
            maxLines: maxLines ?? 1,
            readOnly: readOnly ?? false,
            keyboardType: keyboardType,
            onFieldSubmitted: onFieldSubmitted,
            validator: validator,
            controller: controller,
            decoration: InputDecoration(
              suffixIcon: suffixIcon != null
                  ? IconButton(
                      onPressed: suffixIconOnPressed,
                      icon: suffixIcon!,
                    )
                  : null,
              contentPadding: EdgeInsets.symmetric(
                vertical: 12.w,
                horizontal: 16.w,
              ),
              hintText: hintText,

              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD1D5DB), width: .8),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffEF4444), width: .8),

                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD1D5DB), width: .8),
                borderRadius: BorderRadius.circular(12),
              ),

              border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffD1D5DB), width: .8),
                borderRadius: BorderRadius.circular(12),
              ),

              hintStyle: hintStyle,
            ),
          ),
        ],
      ),
    );
  }
}
