import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

import 'package:weather_app/model/apiCall.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/screens/selectCity.dart';

class HomeScreen extends StatefulWidget {
  String secilenSehir;
  HomeScreen({this.secilenSehir});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int gunDegisim = 0;
  String iconUrl;
  String guncelKonumSehir;
  List<Map<dynamic, dynamic>> weatherDataMapList =
      List<Map<dynamic, dynamic>>();

  var list;
  var listresult;
  var first;
  int kontrolInit = 0;
  String apiUrl;
  Position position;
  Size screenSize;

  @override
  void initState() {
    widget.secilenSehir == null
        ? guncelKonumSehir == null
            ? apiUrl = ApiCall.API_LINK + "Ankara"
            : apiUrl = ApiCall.API_LINK + guncelKonumSehir
        : apiUrl = ApiCall.API_LINK + widget.secilenSehir;
    print("initstate");
    print("güncelkonum: ${guncelKonumSehir}");
    print("widget.secilenSehir: ${widget.secilenSehir}");
    print("initstate bitti");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.purple[200], Colors.blue[200]],
                tileMode: TileMode.clamp)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: FutureBuilder<Object>(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return spinkit;
                } else {
                  if (snapshot.hasError) {
                    print("HATAAAA 46");
                  } else {
                    return _bodyTasarim(context);
                  }
                }
              }),
        ));
  }

  _bodyTasarim(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                      top: 50,
                      left: 30,
                    ),
                    height: screenSize.height,
                    width: screenSize.width,
                    child: SvgPicture.network(iconUrl)),
              ),
              Column(
                children: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 10, left: 220),
                      height: 50,
                      width: 50,
                      child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectCity()));
                          })),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 220),
                      height: 50,
                      width: 50,
                      child: IconButton(
                          icon: Icon(Icons.my_location),
                          onPressed: () {
                            _getCurrentLocation();
                          })),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Text(
          widget.secilenSehir == null
              ? guncelKonumSehir == null ? "Ankara" : guncelKonumSehir
              : widget.secilenSehir,
          style: TextStyle(fontSize: 40),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          weatherDataMapList[gunDegisim]["degree"],
          style: TextStyle(fontSize: 100),
        ),
        Text(
          weatherDataMapList[gunDegisim]["day"],
          style: TextStyle(fontSize: 20),
        ),
        Text(
          weatherDataMapList[gunDegisim]["date"],
          style: TextStyle(fontSize: 20),
        ),
        Divider(
          color: Colors.black,
          indent: 100,
          endIndent: 100,
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Minimum sıcaklık: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(
              weatherDataMapList[0]["min"],
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Maksimum sıcaklık: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(
              weatherDataMapList[gunDegisim]["max"],
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Gece sıcaklık: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(
              weatherDataMapList[gunDegisim]["degree"],
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Nem: ",
              style: TextStyle(fontSize: 25),
            ),
            Text(
              weatherDataMapList[gunDegisim]["humidity"],
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          margin: EdgeInsets.only(right: 1),
          width: 350,
          height: 60,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    setState(() {
                      gunDegisim = 0;
                    });
                    print(weatherDataMapList[0]["day"]);
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        weatherDataMapList[0]["day"],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 40,
                        child:
                            SvgPicture.network(weatherDataMapList[0]["icon"]),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.black,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gunDegisim = 1;
                    });

                    print(weatherDataMapList[1]["day"]);
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        weatherDataMapList[1]["day"],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 40,
                        child:
                            SvgPicture.network(weatherDataMapList[1]["icon"]),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.black,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gunDegisim = 2;
                    });
                    print(weatherDataMapList[2]["day"]);
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        weatherDataMapList[2]["day"],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 40,
                        child:
                            SvgPicture.network(weatherDataMapList[2]["icon"]),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.black,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gunDegisim = 3;
                    });
                    print(weatherDataMapList[3]["day"]);
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        weatherDataMapList[3]["day"],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 40,
                        child:
                            SvgPicture.network(weatherDataMapList[3]["icon"]),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.black,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gunDegisim = 4;
                    });

                    print(weatherDataMapList[4]["day"]);
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        weatherDataMapList[4]["day"],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 40,
                        child:
                            SvgPicture.network(weatherDataMapList[4]["icon"]),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.black,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gunDegisim = 5;
                    });
                    print(weatherDataMapList[5]["day"]);
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        weatherDataMapList[5]["day"],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 40,
                        child:
                            SvgPicture.network(weatherDataMapList[5]["icon"]),
                      )
                    ],
                  ),
                ),
                VerticalDivider(
                  color: Colors.black,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      gunDegisim = 6;
                    });
                  },
                  child: Column(
                    children: <Widget>[
                      Text(
                        weatherDataMapList[6]["day"],
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 35,
                        width: 40,
                        child:
                            SvgPicture.network(weatherDataMapList[6]["icon"]),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<String> fetchData() async {
    try {
      weatherDataMapList.clear();

      final response = await http.get(
        Uri.encodeFull(apiUrl),
        headers: {
          "content-type": "application/json",
          "authorization": ApiCall.TOKEN_VALUE
        },
      );

      if (response.statusCode == 200) {
        list = json.decode(response.body);
        listresult = list["result"];

        for (var i = 0; i < listresult.length; i++) {
          weatherDataMapList.add(listresult[i]);
        }

        iconUrl = weatherDataMapList[gunDegisim]["icon"];
      } else {
        throw Exception("İstek durumu başarısız oldu: ${response.statusCode}");
      }
    } catch (Exception) {
      print(Exception);
    }
  }

  final spinkit = SpinKitFadingCircle(
    size: 50.0,
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.orange : Colors.green,
        ),
      );
    },
  );

  _getCurrentLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    var coordinates = Coordinates(position.latitude, position.longitude);

    var address =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    first = address.first;

    setState(() {
      guncelKonumSehir = "${first.adminArea}";

      apiUrl = ApiCall.API_LINK + guncelKonumSehir;
      widget.secilenSehir = null;

      apiUrl = ApiCall.API_LINK + guncelKonumSehir;
    });
  }
}
