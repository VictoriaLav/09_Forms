import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/hotel.dart';

class HotelView extends StatefulWidget {
  static const routeName = '/hotel';
  HotelView({Key? key, required this.uuid}) : super(key: key);
  String uuid;

  @override
  _HotelViewState createState() => _HotelViewState();
}

double _radiusBox = 20;
int activePage = 0;

class _HotelViewState extends State<HotelView> {
  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';
  late Hotel hotel;
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
      final response = await _dio.get('https://run.mocky.io/v3/${widget.uuid}');
      var data = response.data;
      hotel = Hotel.fromJson(data);
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
      appBar: AppBar(
        title: Text(!isLoading && !hasError ? hotel.name : ''),
      ),
      body: Column(
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
                child: Column(
                  children: [
                    Container(
                      child: CarouselSlider.builder(
                        options: CarouselOptions(
                          height: 250.0,
                          onPageChanged: (page, reason) =>
                              setState(() => activePage = page),
                        ),
                        itemCount: hotel.photos.length,
                        itemBuilder: (context, index, realIndex) {
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            child: Image.asset(
                              'assets/images/${hotel.photos[index]}',
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                addTextRich('Страна', hotel.address.country),
                                addTextRich('Город', hotel.address.city),
                                addTextRich('Улица', hotel.address.street),
                                addTextRich('Рейтинг', hotel.rating.toString()),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                const Text(
                                  'Сервисы',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: const [
                                    Expanded(
                                      child: Text(
                                        'Платные',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Бесплатно',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.topLeft,
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView(
                                children: <Widget>[
                                  ...(hotel.services['paid'] ?? []).map((item) {
                                    return Text(item.toString());
                                  }).toList(),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: ListView(
                                  children: <Widget>[
                                    ...(hotel.services['free'] ?? []).map((item) {
                                      return Text(item.toString());
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }

  @override
  Widget addTextRich(String text1, text2) {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          height: 2,
        ),
        children: [
          TextSpan(text: '$text1: '),
          TextSpan(
            text: text2,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}