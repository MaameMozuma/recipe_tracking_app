import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/sub_pages/profile_detail.dart';
import 'package:team_proj_leanne/pages/widgets/custom_app_bar.dart';
import '../widgets/weekly_dashboard.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final List<String> xAxisList = [
    "SUN",
    "MON",
    "TUE",
    "WED",
    "Thu",
    "FRI",
    "SAT",
  ];

  final String xAxisName = "Days";
  final List<double> yAxisList = [100, 50, 200, 300, 300, 50, 500];
  final String yAxisName = "Calories";
  final double interval = 100;

  @override
  Widget build(BuildContext context) {
    final pageHeight = MediaQuery.of(context).size.height;
    final pageWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: AppBar(
              backgroundColor: Color.fromRGBO(230, 230, 250, 1),
            )),
        body: ListView(children: [
          Stack(children: [
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            Positioned(
              top: 0,
              child: SizedBox(
                  height: pageHeight * 0.21,
                  width: pageWidth,
                  child: CustomAppBar(
                      height: pageHeight * 0.21,
                      title: 'My Profile',
                      barColor: Color.fromRGBO(230, 230, 250, 1),
                      FontColor: Colors.black,
                      FontSize: 24)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: pageHeight * 0.15),
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://www.woolha.com/media/2020/03/eevee.png'),
                      minRadius: 30,
                      maxRadius: 45,
                    )),
                const Text(
                  'Samuel Blankson',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const Text('+(233) 543 786 897',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: pageWidth * 0.05,
                        right: pageWidth * 0.05,
                        top: pageHeight * 0.05,
                        bottom: pageHeight * 0.07),
                    child: Card(
                        elevation: 5,
                        shadowColor: Colors.grey,
                        color: const Color.fromRGBO(237, 234, 234, 1),
                        child: SizedBox(
                            width: pageWidth,
                            height: pageHeight * 0.45,
                            child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ProfileDetail(
                                          Maintext: 'Address',
                                          SummaryText: 'Dr Amical Road, Accra',
                                          IconDetails: const Icon(
                                              Icons.location_city,
                                              size: 20)),
                                      const Divider(
                                          color:
                                              Color.fromRGBO(173, 172, 172, 1)),
                                      SizedBox(height: pageHeight * 0.02),
                                      ProfileDetail(
                                          Maintext: 'Email Address',
                                          SummaryText: 'sam.blank@gmail.com',
                                          IconDetails: const Icon(Icons.email,
                                              size: 20)),
                                      const Divider(
                                          color:
                                              Color.fromRGBO(173, 172, 172, 1)),
                                      SizedBox(height: pageHeight * 0.02),
                                      ProfileDetail(
                                          Maintext: 'Location',
                                          SummaryText: 'Ghana',
                                          IconDetails: const Icon(
                                              Icons.my_location,
                                              size: 20))
                                    ]))))),
              ],
            )
          ]),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WeeklyDashboard(
                          xAxisList: xAxisList,
                          xAxisName: xAxisName,
                          yAxisList: yAxisList,
                          yAxisName: yAxisName,
                          interval: interval,
                        )),
              );
            },
            child: Text(
              "Calendar",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(120, 81, 169, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: pageWidth * 0.05),
            ),
          )
        ]));
  }
}
