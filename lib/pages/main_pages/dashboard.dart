import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:team_proj_leanne/pages/sub_pages/user_statistics.dart';
import 'package:team_proj_leanne/pages/widgets/circle_avatar.dart';
import 'package:team_proj_leanne/pages/widgets/progress_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String selectedOption = 'Daily';

  void updateSelectedOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.white,
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Samuel Blankson',
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserStatistics(),
                          ),
                        );
                      },
                      child: const MyCircleAvatar()),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildOption('Day'),
                buildOption('Week'),
                buildOption('Month'),
              ],
            ),
          ),
          const SizedBox(height: 5.0),
          Container(
            width: double.infinity,
            color: Colors.grey,
            height: 2,
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              color: const Color.fromARGB(255, 237, 234, 234),
              width: double.infinity,
              height: 300,
              child: Center(
                child: Text(
                  'Displaying ${selectedOption.toLowerCase()} data',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: Color.fromARGB(255, 120, 82, 174),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Avg. Calorie Intake',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
                Text(
                  '2457kcal',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ProgressCard(),
                ProgressCard(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildOption(String option) {
    bool isSelected = selectedOption == option;
    return GestureDetector(
      onTap: () => updateSelectedOption(option),
      child: Column(
        children: [
          Text(
            option,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? const Color.fromARGB(255, 120, 82, 174)
                  : Colors.grey,
            ),
          ),
          const SizedBox(height: 1.0), // Spacer between text and underline

          Container(
            width: 50.0,
            height: 2.0,
            color: isSelected
                ? const Color.fromARGB(255, 120, 82, 174)
                : Colors.white,
          )
        ],
      ),
    );
  }
}
