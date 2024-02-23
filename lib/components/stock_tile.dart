// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:stockify/store/store.dart';
import '../utils/constants.dart' as constants;

class StockTile extends StatefulWidget {
  final Map<String, dynamic> stock;
  const StockTile({super.key, required this.stock});

  @override
  State<StockTile> createState() => _StockTileState();
}

class _StockTileState extends State<StockTile> {
  //
  bool addedToFavourite = false;
  final userId = store.state.user['user_id'];

  Future<void> addToFavourite(String sc_code) async {
    final url = "${constants.baseUrl}/stocks/favourite/$sc_code";

    try {
      final dio = Dio();

      await dio.post(
        url,
        options: Options(
          headers: {"user_id": userId},
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
      );
    } on DioException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        Navigator.pushNamed(context, "/stockpage", arguments: widget.stock);
      },
      child: SizedBox(
        height: 40,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.stock['sc_name'],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            IconButton(
              onPressed: addedToFavourite == false
                  ? () {
                      setState(() {
                        addedToFavourite = true;
                      });
                      addToFavourite(widget.stock['sc_code']);
                    }
                  : null,
              icon: addedToFavourite == true || widget.stock['isFavourite']
                  ? Icon(
                      Icons.check_box,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : Icon(
                      Icons.add_box_outlined,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
