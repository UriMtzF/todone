import 'package:flutter/material.dart';
import 'package:todone/i18n/strings.g.dart';
import 'package:todone/view/list/list.dart';
import 'package:todone/view/profile/profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.list),
            label: context.t.navbar.list,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: context.t.navbar.profile,
          ),
        ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: const <Widget>[
        TaskList(),
        Profile(),
      ][currentPageIndex],
    );
  }
}
