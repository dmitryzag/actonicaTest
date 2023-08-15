// import 'package:actonic_adboard/screens/advert_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:actonic_adboard/screens/advert_maker.dart';

// import 'models/database.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SQLHelper.db();
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int currentIndex = 0;
//   final List<Widget> screens = const [
//     AdvertScreen(),
//     AdvertScreen(isFavorite: true),
//     AdvertMaker(null)
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         body: screens[currentIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: currentIndex,
//           onTap: (index) => setState(() => currentIndex = index),
//           items: const [
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.home),
//                 label: 'Объявления',
//                 backgroundColor: Colors.blue),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.favorite),
//                 label: 'Избранное',
//                 backgroundColor: Colors.blue),
//             BottomNavigationBarItem(
//                 icon: Icon(Icons.create),
//                 label: 'Создать объявление',
//                 backgroundColor: Colors.blue)
//           ],
//         ),
//       ),
//     );
//   }
// }
