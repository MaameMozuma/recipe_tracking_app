import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:team_proj_leanne/pages/sub_pages/splash_screen.dart';
//import 'package:team_proj_leanne/pages/sub_pages/add_meal.dart';
//import 'package:team_proj_leanne/pages/sub_pages/edit_user.dart';
import 'package:team_proj_leanne/pages/widgets/custom_bottom_nav_bar.dart';
//import 'package:team_proj_leanne/pages/sub_pages/view_all_meals.dart';
// import 'package:Firebase';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await initialize_notifications();

//   runApp(const MyApp());

//   // foregrounded notifications
//   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     print('Got a message whilst in the foreground!');
//     print('Message data: ${message.data}');

//     if (message.notification != null) {
//       print('Message also contained a notification: ${message.notification}');
//     }
//   });
// }

// Future<void> initialize_notifications() async {
//   final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
//   final fcmToken = await FirebaseMessaging.instance.getToken();

//   print(fcmToken);

//   FirebaseMessaging.instance.onTokenRefresh
//       .listen((fcmToken) {
//     // TODO: If necessary send token to application server.

//     // Note: This callback is fired at each app startup and whenever a new
//     // token is generated.
//   })
//       .onError((err) {
//     // Error getting token.
//   });
// }
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        //body: EditUser(),
        body: SplashScreen(),
        // body: customBottomNavigationBar(initialPageIndex: 0)
        //body: AddMealPage()
        //body: DisplayAllMeals()
      ),
    );
  }
}
