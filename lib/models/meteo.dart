class Meteo {
  List<Temp>? list;
  CityApi? city;

  Meteo(this.list, this.city);
}

class Temp {
    int dt;
  Wind wind;
  double tempMin;
  double tempMax;
  int pressure;
  int humidity;
  String main;
  String description;
  String icon;

  Temp(
    this.dt,
      this.wind,
      this.tempMin,
      this.tempMax,
      this.pressure,
      this.humidity,
      this.main,
      this.description,
      this.icon);
}

class Wind {
  double speed;
  int deg;
  double gust;

  Wind(this.speed, this.deg, this.gust);
}

class CityApi {
  int id;
  String name;
  String country;
  int population;
  int timezone;
  int sunrise;
  int sunset;

  CityApi(
      this.id,
      this.name,
      this.country,
      this.population,
      this.timezone,
      this.sunrise,
      this.sunset);
}
