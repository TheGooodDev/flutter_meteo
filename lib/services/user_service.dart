import 'dart:convert';

import 'package:flutter_meteo/models/meteo.dart';
import 'package:http/http.dart' as http;

Future<Meteo> getMeteoData(String city_name) async{
 // Meteo user = Meteo("", "", 0, 0);

  final queryParameters = {
    'q': city_name,
  };

  var url = Uri.https("pro.openweathermap.org", "/data/2.5/forecast/hourly",queryParameters);
  var response = await http.get(url);
  if(response.statusCode == 200){
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse["gender"] != null){
     //user = Meteo(jsonResponse["name"], jsonResponse["gender"], jsonResponse["probability"], jsonResponse["count"]);
    }else{
      //user = Meteo("notEmplty", "", 0, 0);
    }

  }else{
    print("Request failed : ${response.statusCode}");
  }

  return Meteo();
}