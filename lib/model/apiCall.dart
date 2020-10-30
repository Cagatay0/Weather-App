class ApiCall {
  String secilenSehir;
  ApiCall({this.secilenSehir});

  static String sehir; //bu güncel konum gibi düşün şimdilik

  static String API_LINK =
      "https://api.collectapi.com/weather/getWeather?data.lang=tr&data.city=";
  static const String TOKEN_VALUE =
      "apikey 5dduUWZkDE368FlLEVC3Ad:2PW4CSd3ITXQgPgulQCrHi";
}
