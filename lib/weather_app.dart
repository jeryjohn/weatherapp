import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secret.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Ernakulam';
      final res = await http.get(
        Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityName,in&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occurred';
      }
      final weatherData = {
        'temp': data['list'][0]['main']['temp'],
        'currentSky': data['list'][0]['weather'][0]['main'],
        'pressure': data['list'][0]['main']['pressure'],
        'humidity': data['list'][0]['main']['humidity'],
        'windSpeed': data['list'][0]['wind']['speed'],
        'forecastList': data['list'],
      };
      return weatherData;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                print('Refresh');
                setState(() {});
              },
              icon: const Icon(Icons.refresh)),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Unexpected error occured'));
          }

          final data = snapshot.data!;
          final double temp = data['temp'];
          final String currentSky = data['currentSky'];
          final int pressure = data['pressure'];
          final int humidity = data['humidity'];
          final double windSpeed = data['windSpeed'];
          final List forecastList = data['forecastList'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(15),
                  decoration: BoxDecoration(color: const Color.fromARGB(255, 15, 8, 24), borderRadius: BorderRadius.circular(20), boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 10,
                      spreadRadius: 3,
                    ),
                  ]),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Text(
                        '${temp.toString()} K',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(
                        currentSky == 'Clouds' || currentSky == 'Rains  ' ? Icons.cloud : Icons.sunny,
                        size: 50,
                      ),
                      Text(
                        currentSky,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      )
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Weather Forecast',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // SingleChildScrollView(
              //   scrollDirection: Axis.horizontal,
              //   child: Row(
              //     children: [
              //       for (int i = 0; i < 5; i++)
              //         HourlyForecastItem(
              //           time: forecastList[i + 1]['dt'].toString(),
              //           icon: forecastList[i + 1]['weather'][0]['main'] ==
              //                       'Clouds' ||
              //                   forecastList[i + 1]['weather'][0]['main'] ==
              //                       'Rain'
              //               ? Icons.cloud
              //               : Icons.sunny,
              //           temperature:
              //               forecastList[i + 1]['main']['temp'].toString(),
              //         ),
              //     ],
              //   ),
              // ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    final forcast = forecastList[index + 1];
                    final time = DateTime.parse(forcast['dt_txt']);
                    return HourlyForecastItem(
                      time: DateFormat.j().format(time),
                      temperature: forcast['main']['temp'].toString(),
                      icon: forcast['weather'][0]['main'] == 'Clouds' || forcast['weather'][0]['main'] == 'Rains' ? Icons.cloud : Icons.sunny,
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoItem(
                    icon: Icons.water_drop,
                    label: 'Humidity',
                    labelb: humidity.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    labelb: windSpeed.toString(),
                  ),
                  AdditionalInfoItem(
                    icon: Icons.wind_power,
                    label: 'Pressure',
                    labelb: pressure.toString(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Center(
                  child: Container(
                    width: 220,
                    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 2),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(30),
                        color: const Color.fromARGB(255, 17, 35, 44)),
                    child: const SizedBox(
                        height: 23,
                        child: Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_on,
                              ),
                              Text(
                                'Ernakulam',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
