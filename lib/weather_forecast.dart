import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/secrets.dart';

class WeatherForecast extends StatefulWidget {
  const WeatherForecast({super.key});

  @override
  State<WeatherForecast> createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecast> {
  Future<List<Weather>> fetchWeatherForecast() async {
    String apiKey = openWeatherAPIKey;
    WeatherFactory wf = new WeatherFactory(apiKey);
    List<Weather> weatherForecast =
        await wf.fiveDayForecastByCityName("Faridabad");

    return weatherForecast;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWeatherForecast(),
      builder: ((BuildContext context, AsyncSnapshot<List<Weather>> weather) {
        if (weather.hasData) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return HourlyForecastItem(
                time: DateFormat("j")
                    .format(weather.data![index].date!.toLocal())
                    .toString(),
                temperature:
                    "${weather.data![index].temperature!.celsius!.round().toString()}°C",
                icon: weather.data![index].weatherDescription == "clear sky"
                    ? Icons.sunny
                    : Icons.cloud,
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }),
    );
  }
}
