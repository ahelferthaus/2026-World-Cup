import 'package:flutter/material.dart';
import 'matches_tab.dart';
import 'standings_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('2026 World Cup'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Matches'),
              Tab(text: 'Standings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MatchesTab(),
            StandingsTab(),
          ],
        ),
      ),
    );
  }
}
