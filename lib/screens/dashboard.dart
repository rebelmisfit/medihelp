import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:medihelp/screens/reminder-screen.dart';
import 'package:medihelp/services/medicine_search.dart';
import '../components/mapscreen.dart';
import '../widgets/category.dart';
import '../components/datetimepicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meditation App',
      theme: ThemeData(
        fontFamily: "SourceSansPro",
        scaffoldBackgroundColor: Color(0xFFA7B2D0),
        //textTheme: Theme.of(context).textTheme.apply(displayColor: kTextColor),
      ),
      home: Dashboard(),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            // Here the height of the container is 45% of our total height
            height: size.height * .45,
            decoration: BoxDecoration(
              color: Color(0xFF375AB4),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Color(0xFFF2BEA1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person),
                    ),
                  ),
                  Text(
                    "fall in love with taking care of yourself",
                    style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                  Lottie.asset('assets/images/loader.json'),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: .85,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      children: <Widget>[
                        InkWell(
                          child: CategoryCard(
                            title: "Set new reminder ",
                            src: "assets/images/clock.png",
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ReminderPage(),
                              ),
                            );
                          },
                        ),
                        InkWell(
                          child: CategoryCard(
                            title: "Pharmacies near me",
                            src: "assets/images/pharmacy.png",
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapScreen(),
                              ),
                            );
                          },
                        ),
                        InkWell(
                          child: CategoryCard(
                            title: "Search medicine",
                            src: "assets/images/medicine.png",
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
