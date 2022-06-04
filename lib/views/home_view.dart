import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/hotel.dart';

class HomeView extends StatefulWidget {
  static const routeName = '/';
  HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

double _radiusBox = 20;

class _HomeViewState extends State<HomeView> {
  bool isLoading = false;
  bool hasError = false;
  bool viewList = true;
  String errorMessage = '';
  List<HotelPreview> hotelsList = [];
  Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    getDataDio();
  }

  getDataDio() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _dio
          .get('https://run.mocky.io/v3/ac888dc5-d193-4700-b12c-abb43e289301');
      var data = response.data;
      hotelsList = data.map<HotelPreview>((hotel) => HotelPreview.fromJson(hotel)).toList();
    } on DioError catch (e) {
      setState(() {
        errorMessage = e.response?.data['message'];
        hasError = true;
      });
    }
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('Find hotel'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              setState(() {
                viewList = true;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.apps),
            onPressed: () {
              setState(() {
                viewList = false;
              });
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            if (isLoading) Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            if (!isLoading && hasError) Expanded(
              child: Center(
                child: Text(errorMessage),
              ),
            ),
            if (!isLoading && !hasError)
              Expanded(
                child: GridView.count(
                  crossAxisCount: viewList ? 1 : 2,
                  childAspectRatio: viewList ? 2 : 1, //размер элемента (соотношение сторон, высоты к ширине)
                  mainAxisSpacing: viewList ? 5 : 10, //расстояние между рядами вертикально
                  crossAxisSpacing: 10.0, //расстояние между рядами горизонтально
                  children: <Widget>[
                    ...hotelsList.map((hotel) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(_radiusBox),
                        ),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              flex: viewList ? 3 : 1,
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset('assets/images/${hotel.poster}', fit: BoxFit.cover, width: double.infinity,),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(_radiusBox),
                                      topRight: Radius.circular(_radiusBox),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: viewList
                                  ? Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(hotel.name),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed('/hotel', arguments: {'uuid': hotel.uuid});
                                              },
                                              child: Text('Подробнее'),
                                          ),
                                        ],
                                      ),
                                  )
                                  : Column(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Center(
                                            child: Text(hotel.name),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Container(
                                            width: double.infinity,
                                            clipBehavior: Clip.antiAlias,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pushNamed('/hotel', arguments: {'uuid': hotel.uuid});
                                              },
                                              child: Text('Подробнее'),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(_radiusBox),
                                                bottomRight: Radius.circular(_radiusBox),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                  ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}


// class HotelCard extends StatefulWidget {
//   HotelCard({Key? key}) : super(key: key);
//
//   @override
//   _HotelCardState createState() => _HotelCardState();
// }
//
// class _HotelCardState extends State<HotelCard> {
//   @override
//   Widget build(BuildContext context) {
//     return BoxDecoration(
//       image: Image.asset('assets/images/${hotel.poster}', fit: BoxFit.fill),
//     );
//   }
// }