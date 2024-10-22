import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:welzijnai/models/history_data.dart';
import 'package:welzijnai/src/components/text_bubble.dart';
import 'package:welzijnai/src/services/history/history_service.dart';

/// Linechart
/// Retrieves data from the database and displays them in a graph
/// Filepath: lib\src\components\linechart.dart
class LineChartWidget extends StatelessWidget {
  final HistoryService history = HistoryService();

  LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 300,
          child: FutureBuilder<List<HistoryData>>(
            // Retrieve data from database
            future: history.getOverviewData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No data found'));
              } else {
                List<HistoryData> historyDataList = snapshot.data!;
                // Sort data in their respective lists
                List<FlSpot> spotsMobility = [];
                List<FlSpot> spotsSelfcare = [];
                List<FlSpot> spotsActivities = [];
                List<FlSpot> spotsPain = [];
                List<FlSpot> spotsAnxiety = [];

                for (int i = historyDataList.length - 1; i >= 0; i--) {
                  spotsMobility.add(FlSpot(
                      ((i - historyDataList.length + 1) * -1).toDouble(),
                      historyDataList[i].mobility.toDouble()));
                  spotsSelfcare.add(FlSpot(
                      ((i - historyDataList.length + 1) * -1).toDouble(),
                      historyDataList[i].selfcare.toDouble()));
                  spotsActivities.add(FlSpot(
                      ((i - historyDataList.length + 1) * -1).toDouble(),
                      historyDataList[i].activities.toDouble()));
                  spotsPain.add(FlSpot(
                      ((i - historyDataList.length + 1) * -1).toDouble(),
                      historyDataList[i].pain.toDouble()));
                  spotsAnxiety.add(FlSpot(
                      ((i - historyDataList.length + 1) * -1).toDouble(),
                      historyDataList[i].anxiety.toDouble()));
                }
                return TextBubble(
                  color: Theme.of(context).colorScheme.secondary,
                  onTap: () {},
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Laatste 7 gesprekken",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: LineChart(
                          // The amount of days/conversations
                          LineChartData(
                            // lineTouchData: LineTouchData(),
                            minX: 0,
                            maxX: 6,
                            minY: 0,
                            maxY: 5,
                            gridData: const FlGridData(
                              horizontalInterval: 1.0,
                              verticalInterval: 1.0,
                            ),

                            // Visible axis titles
                            titlesData: const FlTitlesData(
                              topTitles: AxisTitles(drawBelowEverything: false),
                              bottomTitles:
                                  AxisTitles(drawBelowEverything: false),
                              rightTitles:
                                  AxisTitles(drawBelowEverything: false),
                            ),
                            // Graphs
                            lineBarsData: [
                              LineChartBarData(
                                color: Colors.blue,
                                spots: spotsMobility,
                              ),
                              LineChartBarData(
                                color: Colors.black,
                                spots: spotsSelfcare,
                              ),
                              LineChartBarData(
                                color: Colors.red,
                                spots: spotsActivities,
                              ),
                              LineChartBarData(
                                color: Colors.green,
                                spots: spotsPain,
                              ),
                              LineChartBarData(
                                color: Colors.purple,
                                spots: spotsAnxiety,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        RawScrollbar(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextBubble(
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () {},
                      child: const Text(
                        "Mobiliteit",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextBubble(
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () {},
                      child: const Text(
                        "Zelfzorg",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextBubble(
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () {},
                      child: const Text(
                        "Activiteiten",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextBubble(
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () {},
                      child: const Text(
                        " Pijn ",
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                    const SizedBox(width: 5),
                    TextBubble(
                      color: Theme.of(context).colorScheme.secondary,
                      onTap: () {},
                      child: const Text(
                        "Ongerustheid",
                        style: TextStyle(color: Colors.purple),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
