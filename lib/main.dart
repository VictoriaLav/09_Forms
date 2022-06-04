import 'package:flutter/material.dart';
import 'views/home_view.dart';
import 'views/hotel_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case HomeView.routeName:
            return MaterialPageRoute(builder: (BuildContext context) {
              return HomeView();
            });
          case HotelView.routeName:
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(fullscreenDialog: true,
                builder: (BuildContext context) {
                  return HotelView(uuid: args['uuid']);
                });
          default:
            return MaterialPageRoute(builder: (BuildContext context) {
              return HomeView();
            });
        }
      },
    );
  }
}
