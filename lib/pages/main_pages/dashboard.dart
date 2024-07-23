import 'package:flutter/material.dart';
import 'package:team_proj_leanne/controllers/dashboard_controller.dart';
import 'package:team_proj_leanne/controllers/user_controller.dart';
import 'package:team_proj_leanne/model/dashboard_stat.dart';
import 'package:team_proj_leanne/model/user_profile.dart';
import 'package:team_proj_leanne/pages/sub_pages/user_statistics.dart';
import 'package:team_proj_leanne/pages/widgets/circle_avatar.dart';
import 'package:team_proj_leanne/pages/widgets/custom_graph.dart';
import 'package:team_proj_leanne/pages/widgets/custom_monthly_graph.dart';
import 'package:team_proj_leanne/pages/widgets/progress_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String selectedOption;
  late DashboardStat futureData;
  late UserProfile userData;
  late String category;
  late Future<List<dynamic>> _dashboardFuture;

  final DashboardController _dashController = DashboardController();
  final UserController _userController = UserController();

  String? previousOption;

  @override
  void initState() {
    super.initState();
    selectedOption = 'Week';
    category = 'Steps';
    _dashboardFuture = Future.wait([
      _dashController.getStepSummary(),
      _userController.getUserStatistics(),
    ]);
  }

  void updateSelectedOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: const Center(child: Text('No data available')),
          );
        } else {
          futureData = snapshot.data![0] as DashboardStat;
          userData = snapshot.data![1] as UserProfile;

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
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              userData.username,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
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
                            child: MyCircleAvatar(
                              imageUrl: userData.profile_pic_url,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildOption('Week'),
                              buildOption('Month'),
                            ],
                          ),
                        ),
                        Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7)),
                          child: PopupMenuButton<String>(
                            icon: const Padding(
                              padding: EdgeInsets.only(bottom: 16),
                              child: Icon(
                                Icons.filter_list,
                                color: Color.fromARGB(255, 120, 82, 174),
                              ),
                            ),
                            onSelected: (value) {
                              setState(() {
                                if (value != category) {
                                  category = value;
                                  _dashboardFuture = Future.wait([
                                    value == 'Steps'
                                        ? _dashController.getStepSummary()
                                        : _dashController.getCaloriesSummary(),
                                    _userController.getUserStatistics(),
                                  ]);
                                }
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              List<String> categories = ['Steps', 'Calories'];
                              return categories.map((String category) {
                                return PopupMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                );
                              }).toList();
                            },
                          ),
                        ),
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
                    padding: const EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      height: 300,
                      child: selectedOption == 'Week'
                          ? CustomGraph(data: futureData.weeklyData)
                          : CustomMonthlyGraph(data: futureData.monthlyData),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProgressCard(
                          mainText: futureData.weeklyTotal.toString(),
                          subText: category == 'Steps' ? 'Steps' : 'Cals',
                          type: 'Weekly',
                        ),
                        ProgressCard(
                          mainText: futureData.monthlyTotal.toString(),
                          subText: category == 'Steps' ? 'Steps' : 'Cals',
                          type: 'Monthly',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
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
          ),
        ],
      ),
    );
  }
}
