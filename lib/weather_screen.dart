import 'package:weather/weather.dart';
import 'package:weather_app/secrets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/main.dart';
import 'package:weather_app/weather_forecast.dart';

class WeatherScreen extends StatefulWidget {
  final Function callbackFN;
  const WeatherScreen({super.key, required this.callbackFN});

  @override
  State<WeatherScreen> createState() =>
      WeatherScreenState(callbackFunction: callbackFN);
}

class WeatherScreenState extends State<WeatherScreen> {
  WeatherScreenState({required this.callbackFunction});

  final Function callbackFunction;

  Future<Weather> fetchWeather() async {
    String apiKey = openWeatherAPIKey;
    WeatherFactory wf = new WeatherFactory(apiKey);
    Weather weatherOutput = await wf.currentWeatherByCityName("Faridabad");
    return weatherOutput;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                iconBool = !iconBool;
              });
              callbackFunction(iconBool);
            },
            icon: Icon(iconBool ? Icons.light_mode : Icons.dark_mode),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchWeather(),
        builder: (BuildContext context, AsyncSnapshot<Weather> weather) {
          if (weather.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // main card
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Text(
                                    "${weather.data!.temperature!.celsius!.toStringAsFixed(2)}°C",
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Icon(
                                    weather.data!.weatherDescription! ==
                                            "clear sky"
                                        ? Icons.sunny
                                        : Icons.cloud,
                                    size: 64,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    weather.data!.weatherDescription!,
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Weather Forecast",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    SizedBox(
                      height: 120,
                      child: WeatherForecast(),
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Additional Information",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        AdditionalInfoItem(
                          icon: Icons.water_drop,
                          label: "Humidity",
                          value: weather.data!.humidity!.toStringAsFixed(0),
                        ),
                        AdditionalInfoItem(
                          icon: Icons.air,
                          label: "Wind Speed",
                          value: weather.data!.windSpeed!.toStringAsFixed(2),
                        ),
                        AdditionalInfoItem(
                          icon: Icons.beach_access,
                          label: "Pressure",
                          value: weather.data!.pressure!.toStringAsFixed(0),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
