// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockify/store/store.dart';
import 'package:stockify/store/user_reducer.dart';
import 'package:stockify/utils/helper.dart';

import '../utils/constants.dart' as constants;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchTextController = TextEditingController();
  final SearchController searchController = SearchController();

  final userId = store.state.user['user_id'];
  // final favouriteStocks = store.state.favouriteStocks;

  List<dynamic> favouriteStocks = [];

  Future<void> getFavStocks() async {
    const url = "${constants.baseUrl}/stocks/favourites";

    final sharedPreferences = await SharedPreferences.getInstance();
    final userIdKey = sharedPreferences.getInt('userId');

    store.dispatch(
        const LoadingAction(payload: {"isError": false, "isLoading": true}));
    try {
      final dio = Dio();

      final response = await dio.get(
        url,
        options: Options(
          headers: {'user_id': userIdKey ?? userId},
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
      );

      final responseData = await response.data as List;

      if (context.mounted) {
        store.dispatch(StoreFavouriteStocks(payload: responseData));
        setState(() {
          favouriteStocks = responseData;
        });

        store.dispatch(const LoadingAction(
            payload: {"isError": false, "isLoading": false}));
      }

      //
    } catch (e) {
      store.dispatch(
          const ErrorAction(payload: {"isError": true, "isLoading": false}));
      print(e);
    }
  }

  Future<void> removeFromFavourite(String scCode) async {
    final url = "${constants.baseUrl}/stocks/favourite/$scCode";
    final dio = Dio();

    try {
      await dio.delete(
        url,
        options: Options(
          headers: {'user_id': userId},
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
      );

      getFavStocks();
    } catch (e) {
      print(e);
    }
  }

  Future<void> signOut(int userId) async {
    const url = "${constants.baseUrl}/logout";

    try {
      final dio = Dio();

      final body = {"user_id": userId};

      final response = await dio.post(
        url,
        data: body,
        options: Options(
          followRedirects: false,
          validateStatus: (status) {
            return status! <= 500;
          },
        ),
      );

      var responseBody = await response.data;

      // navigate to signin page
      if (context.mounted) {
        if (response.statusCode == 200) {
          store.dispatch(UserLoggedOutAction());
          Navigator.pushNamedAndRemoveUntil(
              context, "/signin", ((Route<dynamic> route) => false));
        } else {
          showDialogMessage(
              context, responseBody['title'], responseBody['message']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getFavStocks();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Stockify",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final sharedPreferences = await SharedPreferences.getInstance();
              final userIdKey = sharedPreferences.getInt('userId');
              signOut(userIdKey!);
              sharedPreferences.clear();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
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
                  borderRadius: BorderRadius.circular(8),
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
              child: store.state.isLoading == true && !store.state.isLoggedIn
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    )
                  : favouriteStocks.isNotEmpty
                      ? Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          child: ListView.separated(
                            itemCount: favouriteStocks.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Navigator.pushNamed(context, "/stockpage",
                                      arguments: favouriteStocks[index]);
                                },
                                child: SizedBox(
                                  height: 40,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        favouriteStocks[index]['sc_name'],
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      IconButton(
                                        onPressed: () => removeFromFavourite(
                                            favouriteStocks[index]['sc_code']),
                                        icon: Icon(
                                          Icons.delete,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
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
