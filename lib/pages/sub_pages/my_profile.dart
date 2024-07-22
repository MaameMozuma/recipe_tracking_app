import 'package:flutter/material.dart';
import 'package:team_proj_leanne/model/user_profile.dart';
import 'package:team_proj_leanne/pages/widgets/custom_app_bar.dart';
import 'package:team_proj_leanne/pages/widgets/profile_detail.dart';

import '../../services/get_user_detail.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});
  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  late Future<UserProfile> userDetails;
  late String? userId;

  @override
  void initState() {
    userDetails = fetchProfile();
    super.initState();
  }

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
        body: FutureBuilder(
            future: userDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data'));
              } else if (snapshot.hasError) {
                return Center(child: Text('${snapshot.error}'));
              } else {
                return RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        userDetails = fetchProfile();
                      });
                    },
                    child: ListView(children: [
                      Stack(children: [
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
                                padding:
                                    EdgeInsets.only(top: pageHeight * 0.15),
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
                                    color:
                                        const Color.fromRGBO(237, 234, 234, 1),
                                    child: SizedBox(
                                        width: pageWidth,
                                        height: pageHeight * 0.60,
                                        child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  ProfileDetail(
                                                      Maintext: 'Username',
                                                      SummaryText: snapshot
                                                          .data!.username,
                                                      IconDetails: const Icon(
                                                          Icons.location_city,
                                                          size: 20)),
                                                  const Divider(
                                                      color: Color.fromRGBO(
                                                          173, 172, 172, 1)),
                                                  ProfileDetail(
                                                      Maintext: 'Email Address',
                                                      SummaryText:
                                                          snapshot.data!.email,
                                                      IconDetails: const Icon(
                                                          Icons.email,
                                                          size: 20)),
                                                  const Divider(
                                                      color: Color.fromRGBO(
                                                          173, 172, 172, 1)),
                                                  ProfileDetail(
                                                      Maintext: 'Height',
                                                      SummaryText:
                                                          snapshot.data!.height,
                                                      IconDetails: const Icon(
                                                          Icons.height,
                                                          size: 20)),
                                                  const Divider(
                                                      color: Color.fromRGBO(
                                                          173, 172, 172, 1)),
                                                  ProfileDetail(
                                                      Maintext: 'Weight',
                                                      SummaryText:
                                                          snapshot.data!.weight,
                                                      IconDetails: const Icon(
                                                          Icons.scale,
                                                          size: 20)),
                                                  const Divider(
                                                      color: Color.fromRGBO(
                                                          173, 172, 172, 1)),
                                                  ProfileDetail(
                                                      Maintext: 'Date of Birth',
                                                      SummaryText:
                                                          snapshot.data!.dob,
                                                      IconDetails: const Icon(
                                                          Icons.calendar_month,
                                                          size: 20)),
                                                  const Divider(
                                                      color: Color.fromRGBO(
                                                          173, 172, 172, 1)),
                                                  ProfileDetail(
                                                      Maintext: 'Phone Number',
                                                      SummaryText:
                                                          snapshot.data!.telno,
                                                      IconDetails: const Icon(
                                                          Icons.phone,
                                                          size: 20)),
                                                  const Divider(
                                                      color: Color.fromRGBO(
                                                          173, 172, 172, 1)),
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
                    ]));
              }
            }));
  }
}
