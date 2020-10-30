import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:weather_app/model/apiCall.dart';
import 'package:weather_app/screens/homeScreen.dart';

class SelectCity extends StatefulWidget {
  @override
  _SelectCityState createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  final _formKey = GlobalKey<FormState>();
  String textDosyaOkuma = "";

  String city;
  List<String> cityList = [
    "Adana",
    "Adıyaman",
    "Afyon",
    "Ağrı",
    "Amasya",
    "Ankara",
    "Antalya",
    "Artvin",
    "Aydın",
    "Balıkesir",
    "Bilecik",
    "Bingöl",
    "Bitlis",
    "Bolu",
    "Burdur",
    "Bursa",
    "Çanakkale",
    "Çankırı",
    "Çorum",
    "Denizli",
    "Diyarbakır",
    "Edirne",
    "Elazığ",
    "Ezincan",
    "Erzurum",
    "Eskişehir",
    "Gaziantep",
    "Giresun",
    "Gümüşhane",
    "Hakkari",
    "Hatay",
    "Isparta",
    "Mersin",
    "İstanbul",
    "İzmir",
    "Kars",
    "Kastamonu",
    "Kayseri",
    "Kırklareli",
    "Kırşehir",
    "Kocaeli",
    "Konya",
    "Kütahya",
    "Malatya",
    "Manisa",
    "Kahramanmaraş",
    "Mardin",
    "Muğla",
    "Muş",
    "Nevşehir",
    "Niğde",
    "Ordu",
    "Rize",
    "Sakarya",
    "Samsun",
    "Siirt",
    "Sinop",
    "Sivas",
    "Tekirdağ",
    "Tokat",
    "Trabzon",
    "Tunceli",
    "Şanlıurfa",
    "Uşak",
    "Van",
    "Yozgat",
    "Zonguldak",
    "Aksaray",
    "Bayburt",
    "Karaman",
    "Kırıkkale",
    "Batman",
    "Şırnak",
    "Bartın",
    "Ardahan",
    "Iğdır",
    "Yalova",
    "Karabük",
    "Kilis",
    "Osmaniye",
    "Düzce"
  ];
  List<String> filterCity = List();

  fetchFileData() async {
    var responseText;
    responseText = await rootBundle.loadString("assets/textfiles/sehirler.txt");
    setState(() {
      textDosyaOkuma = responseText;
      filterCity = cityList;

      //cityList = responseText;
    });
  }

  @override
  void initState() {
    fetchFileData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Container(
      width: screenSize.width,
      height: screenSize.height,

      /*  decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.purple[200], Colors.white30],
              tileMode: TileMode.clamp)),
     */

      child: Scaffold(
        backgroundColor: Colors.white,
        body: _tasarim(),
      ),
    );
  }

  _tasarim() {
    return Column(
      children: [
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.only(
            top: 100,
          ),
          height: 50,
          width: 370,
          color: Colors.white,
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: "Şehir giriniz"),
                    onChanged: (string) {
                      setState(() {
                        filterCity = cityList
                            .where((element) => element
                                .toLowerCase()
                                .contains(string.toLowerCase()))
                            .toList();
                      });
                    },
                  )
                ],
              )),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
            child: ListView.builder(
          padding: EdgeInsets.all(10),
          itemCount: filterCity.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  //print(filterCity[index]);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                secilenSehir: filterCity[index],
                              )));
                });
              },
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        filterCity[index],
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ))
      ],
    );
  }
}
