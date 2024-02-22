// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:stockify/components/custom_button.dart';
import 'package:stockify/components/custom_line_chart.dart';

import '../utils/constants.dart' as constants;

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String startDate = "";
  String endDate = "";

  double minY = double.infinity, maxY = double.negativeInfinity;
  DateTime? minX, maxX;

  Map<String, dynamic> stockHistoryDetails = {};

  @override
  Widget build(BuildContext context) {
    final stockDetails = ModalRoute.of(context)!.settings.arguments! as Map;

    void getStockHistory() async {
      const url = "${constants.baseUrl}/stocks/history";
      final dio = Dio();

      final body = {
        'name': stockDetails['sc_name'],
        'from': startDate,
        'to': endDate
      };

      try {
        var response = await dio.get(url,
            data: body,
            options: Options(
              followRedirects: false,
              validateStatus: (status) {
                return status! <= 500;
              },
            ));

        var data = await response.data;

        // print(response.data);

        setState(() {
          stockHistoryDetails = data.length != 0 ? data[0] : {};

          minY = double.parse(stockHistoryDetails['data']
              [stockHistoryDetails['data'].length - 1]['close']);
          maxY = double.parse(stockHistoryDetails['data'][0]['close']);

          for (var data in stockHistoryDetails['data']) {
            // Date value
            DateTime date = DateTime.parse(data['date']);
            if (minX == null || date.isBefore(minX!)) minX = date;
            if (maxX == null || date.isAfter(maxX!)) maxX = date;
          }
        });

        // stockHistoryDetails['data'].asMap().forEach(
        //       (index, ele) =>
        //           print("Index: $index, Close Value: ${ele['close']}"),
        //     );
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          stockDetails['sc_name'],
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
            Text("Stock Price History Graph",
                style: Theme.of(context).textTheme.bodyMedium),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Start Date:",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    //
                    const SizedBox(
                      width: 20,
                    ),

                    //
                    Text(
                      startDate == "" ? "" : startDate,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                // date picker
                IconButton(
                  onPressed: () async {
                    DateTime? datePicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime.now());

                    if (datePicked != null) {
                      setState(() {
                        _startDate = datePicked;
                        startDate = DateFormat('yyyy-MM-dd').format(_startDate);
                      });
                    }

                    // return;
                  },
                  icon: const Icon(Icons.date_range_outlined,
                      color: Colors.white),
                ),
              ],
            ),

            //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "End Date:",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    //
                    const SizedBox(
                      width: 29,
                    ),

                    //
                    Text(
                      endDate == "" ? "" : endDate,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),

                // date picker
                IconButton(
                  onPressed: () async {
                    DateTime? datePicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2021),
                        lastDate: DateTime.now());

                    if (datePicked != null &&
                        datePicked.compareTo(_startDate) >= 0) {
                      setState(() {
                        _endDate = datePicked;
                        endDate = DateFormat('yyyy-MM-dd').format(_endDate);
                      });
                    }
                  },
                  icon: const Icon(Icons.date_range_outlined,
                      color: Colors.white),
                ),
              ],
            ),

            // Generate Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  onPressed: () {
                    if (startDate != "" && endDate != "") {
                      getStockHistory();
                    }
                  },
                  buttonText: 'Generate Graph',
                  height: MediaQuery.of(context).size.width / 8,
                  width: MediaQuery.of(context).size.width / 2.2,
                ),

                //
                CustomButton(
                  onPressed: () {
                    setState(() {
                      stockHistoryDetails = {};
                      startDate = "";
                      endDate = "";
                    });
                  },
                  buttonText: 'Clear Graph',
                  height: MediaQuery.of(context).size.width / 8,
                  width: MediaQuery.of(context).size.width / 2.7,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),

            // Graph
            Container(
                margin: const EdgeInsets.only(top: 50.0),
                child: stockHistoryDetails.isNotEmpty &&
                        startDate.isNotEmpty &&
                        endDate.isNotEmpty
                    ? CustomLineChart(stockData: stockHistoryDetails['data'])
                    : const SizedBox(
                        child: AspectRatio(aspectRatio: 16 / 9),
                      )),
          ],
        ),
      ),
    );
  }
}
