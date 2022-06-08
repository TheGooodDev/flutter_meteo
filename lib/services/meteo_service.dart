import 'dart:convert';

import 'package:flutter_meteo/models/meteo.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_meteo/utils/glob_var.dart';

Future<Meteo> getMeteoData(String city_name) async {
  Meteo meteo = Meteo([Temp(0,Wind(0, 0, 0), 0, 0, 0, 0, '', '', '')],
      CityApi(0, '', '', 0, 0, 0, 0));
  final queryParameters = {
    'q': city_name,
    'appid': API_KEY,
    'units': "metric",
  };

  var url = Uri.https(
      "api.openweathermap.org", "/data/2.5/forecast", queryParameters);
  var response = await http.get(url);
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    CityApi city = CityApi(
        jsonResponse["city"]['id'],
        jsonResponse["city"]['name'],
        jsonResponse["city"]['country'],
        jsonResponse["city"]['population'],
        jsonResponse["city"]['timezone'],
        jsonResponse["city"]['sunrise'],
        jsonResponse["city"]['sunset']);

    List<Temp> temperatures = [];
    for (var temps in jsonResponse["list"]) {
      Wind wind = Wind(
          temps['wind']['speed'].toDouble(), temps['wind']['deg'], temps['wind']['gust']);
      temperatures.add(Temp(
          temps['dt'],
          wind,
          temps['main']['temp_min'].toDouble(),
          temps['main']['temp_max'].toDouble(),
          temps['main']['pressure'],
          temps['main']['humidity'],
          temps['weather'][0]['main'],
          temps['weather'][0]['description'],
          temps['weather'][0]['icon']));
    }
    meteo = Meteo(temperatures, city);
    return meteo;
  } else {
    print("Request failed : ${response.statusCode}");
    return meteo;
  }
}
