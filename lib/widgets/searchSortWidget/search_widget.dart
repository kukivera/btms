import 'package:bruh_finance_tms/constants.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const SearchWidget({
    super.key,
    this.onChanged,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(searchController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: kMediumTextStyle,
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(
          Icons.search,
          color: Colors.lightBlueAccent,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
