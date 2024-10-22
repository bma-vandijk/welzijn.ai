import 'package:flutter/material.dart';
import 'package:welzijnai/src/components/linechart.dart';
import 'package:welzijnai/src/components/navbar.dart';
import 'package:welzijnai/src/components/text_bubble.dart';
import 'package:welzijnai/src/pages/score.dart';
import 'package:welzijnai/src/services/history/history_service.dart';

/// History page
/// Shows a graph with the questionnaire scores from the past 7 conversations
/// Shows a list of the past conversations.
/// File path: lib/src/pages/history.dart
class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
  });
  static const routeName = '/history';

  @override
  Widget build(BuildContext context) {
    HistoryService historyService = HistoryService();
    // historyService.updateUserData();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Geschiedenis",
          ),
        ),
        shape: const Border(bottom: BorderSide(width: 1)),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),

              // Graph showing progress over the last 7 conversations
              LineChartWidget(),

              // List of dates on which conversations have been started
              FutureBuilder<List<String>>(
                // Get the dates from the database
                future: historyService.getHistoryDates(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading...");
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  List<String> dates = snapshot.data ?? [];
                  if (dates.isEmpty) {
                    return const Text('Geen geschiedenis beschikbaar');
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextBubble(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScorePage(
                                  date: dates[index],
                                ),
                              ),
                            );
                          },
                          color: Theme.of(context).colorScheme.secondary,
                          child: Center(
                            child: Text("Gesprek van ${dates[index]}"),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(
        // Of the three available pages, the second one is currently selected.
        selected: [false, true, false],
      ),
    );
  }
}
