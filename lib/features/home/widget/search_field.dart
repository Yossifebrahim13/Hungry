import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key, this.controller, this.onChanged});
  final TextEditingController? controller;
  final Function(String)? onChanged;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    // Only dispose if this state created the controller
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        height: 50,
        child: TextField(
          controller: _controller,
          cursorColor: AppColors.primaryColor,
          decoration: InputDecoration(
            fillColor: Colors.grey.shade100,
            filled: true,
            prefixIcon: const Icon(Icons.search_sharp, color: Colors.grey),
            suffixIcon: _controller.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _controller.clear();
                      setState(() {});
                    },
                  )
                : null,
            hintText: "Search...",
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
