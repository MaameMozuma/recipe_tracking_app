import 'package:flutter/material.dart';
import 'package:team_proj_leanne/controllers/user_controller.dart';
import 'package:team_proj_leanne/pages/sub_pages/my_profile.dart';
import 'package:team_proj_leanne/pages/widgets/daily_stat_card.dart';
import 'package:team_proj_leanne/pages/widgets/profile_card.dart';

class UserStatistics extends StatefulWidget {
  const UserStatistics({super.key});

  @override
  State<UserStatistics> createState() => _UserStatisticsState();
}

class _UserStatisticsState extends State<UserStatistics> {
  final UserController _userController = UserController();
  DateTime parseDateString(String dateString) {
    final parts = dateString.split('/');
    if (parts.length == 3) {
      final year =
          int.parse(parts[2]) + 2000; // Assuming all dates are in the 2000s
      final month = int.parse(parts[1]);
      final day = int.parse(parts[0]);
      return DateTime(year, month, day);
    } else {
      throw FormatException('Invalid date format');
    }
  }

  int calculateAge(DateTime dob) {
    DateTime today = DateTime.now();
    int age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _userController.getUserStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return Scaffold(
                body: Center(child: Text('Error: ${snapshot.error}')));
          } else if (!snapshot.hasData) {
            return const Scaffold(
                body: Center(child: Text('No data available')));
          } else {
            final user = snapshot.data!;
            final dobString = user.dob;
            final dob = parseDateString(dobString);
            final age = calculateAge(dob);
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(310),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                  child: Container(
                    color: const Color.fromARGB(255, 230, 230, 250),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 40.0, left: 10.0, right: 10.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.arrow_back,
                                    color: Colors.black),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.settings,
                                    color: Colors.black),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MyProfilePage()),
                                  );
                                },
                              ),
                            ],
                          ),
                          Center(
                            child: ClipOval(
                              child: user.profile_pic_url.isNotEmpty
                                  ? Image.network(
                                      user.profile_pic_url,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Handle image loading error
                                        return Container(
                                          width: 55,
                                          height: 55,
                                          color: Colors.grey[
                                              300], // Background color for error state
                                          child: Icon(
                                            Icons.person, // Default meal icon
                                            size: 30,
                                            color: Colors.grey[600],
                                          ),
                                        );
                                      },
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                            ),
                          ),
                          Text(
                            user.username,
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    '${user.weight} kg',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  const Text('WEIGHT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15))
                                ],
                              ),
                              Container(
                                height: 60,
                                width: 3,
                                color: Colors.black,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '${user.height} cm',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  const Text('HEIGHT',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15))
                                ],
                              ),
                              Container(
                                height: 60,
                                width: 3,
                                color: Colors.black,
                              ),
                              Column(
                                children: [
                                  Text(
                                    '$age y.o',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  const Text('AGE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15))
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ProfileCard(),
                        ProfileCard(),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Daily',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              DailyStatCard(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '40',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              Text(
                                'steps',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              DailyStatCard(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '3600',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                  width: 76,
                                  child: Text(
                                    'Calories gained',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.grey),
                                  ))
                            ],
                          ),
                          Column(
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DailyStatCard(),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                '2400',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(
                                  width: 76,
                                  child: Text(
                                    'Calories burned',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.grey),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        });
  }
}
