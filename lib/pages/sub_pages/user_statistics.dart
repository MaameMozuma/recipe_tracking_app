import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:team_proj_leanne/pages/widgets/daily_stat_card.dart';
import 'package:team_proj_leanne/pages/widgets/profile_card.dart';

class UserStatistics extends StatelessWidget {
  const UserStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding:
                  const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const Center(
                    child: Icon(
                      Icons.person,
                      size: 110,
                    ),
                  ),
                  const Text(
                    'Samuel Blankson',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Column(
                        children: [
                          Text(
                            '70 kg',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          Text('WEIGHT',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15))
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 3,
                        color: Colors.black,
                      ),
                      const Column(
                        children: [
                          Text(
                            '188 cm',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          Text('HEIGHT',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15))
                        ],
                      ),
                      Container(
                        height: 60,
                        width: 3,
                        color: Colors.black,
                      ),
                      const Column(
                        children: [
                          Text(
                            '22 y.o',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 20),
                          ),
                          Text('AGE',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15))
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      DailyStatCard(),
                      SizedBox(height: 10,),
                      Text('40', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text('steps', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey),)
                    ],
                  ),
                  Column(
                    children: [
                      DailyStatCard(),
                      SizedBox(height: 10,),
                      Text('3600', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      SizedBox(
                        width: 76,
                        child: Text('Calories gained', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey),))
                    ],
                  ),
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DailyStatCard(),
                      SizedBox(height: 10,),
                      Text('2400', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      SizedBox(
                        width: 76,
                        child: Text('Calories burned', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.grey),))
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
}
