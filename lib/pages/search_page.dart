import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockify/components/stock_tile.dart';
import 'package:dio/dio.dart';
import '../utils/constants.dart' as constants;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchTextController = TextEditingController();
  Timer? _debounce;

  List<dynamic> stocksList = [];

  bool showClearButton = false;

  @override
  void dispose() {
    searchTextController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void searchStock() async {
    final value = searchTextController.text;
    final url = "${constants.baseUrl}/stocks?name=$value";

    try {
      final dio = Dio();

      final response = await dio.get(url);

      setState(() {
        stocksList = response.data;
      });
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, true),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: TextField(
          controller: searchTextController,
          style: const TextStyle(color: Colors.white),
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Search eg: nuvoco",
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          // onSubmitted: (value) {},
          onChanged: (value) => setState(
            () {
              searchTextController.text.isEmpty
                  ? showClearButton = false
                  : showClearButton = true;

              if (_debounce?.isActive ?? false) {
                _debounce?.cancel();
              }

              _debounce = Timer(const Duration(milliseconds: 700), () {
                searchStock();
              });
            },
          ),
        ),
        actions: [
          // Clear button
          showClearButton
              ? TextButton(
                  onPressed: () {
                    searchTextController.clear();
                    if (searchTextController.text.isEmpty) {
                      setState(() {
                        showClearButton = false;
                        stocksList = [];
                      });
                    }
                  },
                  child: Text(
                    "Clear",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                )
              : const SizedBox(),
        ],
      ),

      //
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: showClearButton == true
              ? ListView.separated(
                  itemBuilder: (context, index) {
                    return StockTile(stock: stocksList[index]);
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: stocksList.length)
              : null,
        ),
      ),
    );
  }
}
