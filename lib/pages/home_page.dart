// ignore_for_file: avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../utils/constants.dart' as constants;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchTextController = TextEditingController();
  final SearchController searchController = SearchController();

  List<dynamic> favouriteStocks = [];

  void getFavStocks() async {
    const url = "${constants.baseUrl}/stocks/favourites";

    try {
      final dio = Dio();

      final response = await dio.get(
        url,
        options: Options(
          headers: {'user_id': 1},
        ),
      );

      final responseData = await response.data as List;

      setState(() {
        favouriteStocks = responseData;
      });
    } catch (e) {
      print(e);
    }
  }

  void removeFromFavourite(String sc_code) async {
    final url = "${constants.baseUrl}/stocks/favourite/$sc_code";
    final dio = Dio();

    try {
      await dio.delete(
        url,
        options: Options(
          headers: {'user_id': 1},
        ),
      );

      getFavStocks();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();

    getFavStocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: Text(
          "Stockify",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/searchpage")
                  .then((value) => getFavStocks()),
              child: Container(
                padding: const EdgeInsets.only(left: 10.0),
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Search and add",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary),
                    ),
                  ],
                ),
              ),
            ),

            //
            const SizedBox(height: 16),

            //
            Text(
              "Favourites (${favouriteStocks.length})",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            // List
            Expanded(
              child: favouriteStocks.isNotEmpty
                  ? ListView.separated(
                      itemCount: favouriteStocks.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/stockpage",
                                arguments: favouriteStocks[index]);
                          },
                          child: SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  favouriteStocks[index]['sc_name'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                IconButton(
                                  onPressed: () => removeFromFavourite(
                                      favouriteStocks[index]['sc_code']),
                                  icon: Icon(
                                    Icons.delete,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Nothing here",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          "Use the search bar to add stocks to",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "your favourites' list",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
