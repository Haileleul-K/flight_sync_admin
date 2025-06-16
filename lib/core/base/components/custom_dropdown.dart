import 'package:flight_sync_admin/core/styles/colors_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> items;
  final String hint;
  final String? initialValue; // Add initial value
  final ValueChanged<String> onChanged;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.label = '',
    this.initialValue, // Accept initial value
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    // Initialize selectedValue with initialValue if provided
    selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(CustomDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selectedValue if items change and current value is invalid
    if (!widget.items.contains(selectedValue)) {
      setState(() {
        selectedValue = widget.initialValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 12.h,
        ),
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 12.0,
            color: ColorThemes.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: ColorThemes.inputGreyColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              alignment: Alignment.center,
              value: selectedValue,
              hint: Center(
                child: Text(
                  widget.hint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ),
              isExpanded: true,
              isDense: true,
              icon: Icon(
                Icons.keyboard_arrow_down_outlined,
                size: 42.dg,
                color: Colors.black,
              ),
              items: widget.items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  widget.onChanged(newValue);
                  setState(() {
                    selectedValue = newValue;
                  });
                }
              },
              selectedItemBuilder: (BuildContext context) {
                return widget.items.map((String item) {
                  return Center(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ],
    );
  }
}