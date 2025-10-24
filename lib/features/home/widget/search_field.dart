import 'package:flutter/material.dart';
import 'package:hungry/core/constants/app_colors.dart';

class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      // ignore: deprecated_member_use
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
          onChanged: (value) => setState(() {}),
        ),
      ),
    );
  }
}
