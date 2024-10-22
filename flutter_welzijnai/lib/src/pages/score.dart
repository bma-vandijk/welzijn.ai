import 'package:flutter/material.dart';
import 'package:welzijnai/src/components/navbar.dart';
import 'package:welzijnai/src/components/text_bubble.dart';
import 'package:welzijnai/src/services/history/history_service.dart';

/// Score page
/// Shows the scores from the questionnaire as interpreted by the Runda Wang model
/// File path: lib/src/pages/score.dart
class ScorePage extends StatelessWidget {
  final String date;
  ScorePage({
    super.key,
    required this.date,
  });
  final HistoryService historyService = HistoryService();
  static const routeName = '/score';

  @override
  Widget build(BuildContext context) {
    HistoryService historyService = HistoryService();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Center(
          child: Text(
            "Gesprek van $date",
          ),
        ),
        shape: const Border(bottom: BorderSide(width: 1)),
        automaticallyImplyLeading: false,
      ),

      // Load data from the database and display in a list of bulletpoints
      body: FutureBuilder(
        // Load data
        future: historyService.getHistory(date),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            dynamic data = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 20,
                      bottom: 50,
                    ),
                    child: SizedBox(
                      height: 150,
                      child: TextBubble(
                        color: Theme.of(context).colorScheme.secondary,
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Welzijn score",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    " \t \u2022 \n \t \u2022 \n \t \u2022 \n \t \u2022 \n \t \u2022",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  const Text(
                                      " Mobiliteit \n Zelfzorg \n Gebruikelijke activiteiten \n Pijn/ongemak \n Ongerustheid/depressie"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 40),
                                    child: Text(
                                      " ${data['mobility']} \n ${data['selfcare']} \n ${data['activities']} \n ${data['pain']} \n ${data['anxiety']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: const NavBar(
        selected: [false, true, false],
      ),
    );
  }
}
