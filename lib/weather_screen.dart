import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/additionalInfoItem.dart';
import 'package:weather/hourly_forcast_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>> getWeather() async {
    try {
      String cityName = 'Nagpur';
      final res = await http.get(
        (Uri.parse(
            'http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey')),
      );
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'an expected error occured';
      }
      return data;

      // temperature = data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: FutureBuilder(
          future: getWeather(),
          builder: (context, snapshot) {
            print(snapshot);
            print(snapshot.runtimeType);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: const CircularProgressIndicator.adaptive());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            final data = snapshot.data;
            final currWeatherData = data!['list'][0];
            final currentTemerature = currWeatherData['main']['temp'];
            final currentSky = currWeatherData['weather'][0]['main'];
            final currentPressure = currWeatherData['main']['pressure'];
            final currentWindSpeed = currWeatherData['wind']['speed'];
            final currentHumidity = currWeatherData['main']['humidity'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //main Card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(children: [
                              Text(
                                '$currentTemerature K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(fontSize: 20),
                              )
                            ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //weatherforcast Cards
                  const Text(
                    'weather forcast',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for (int i = 1; i <= 5; i++)
                  //         ForcastCard(
                  //             icon: data['list'][i]['weather'][0]['main'] ==
                  //                         'Clouds' ||
                  //                     data['list'][i]['weather'][0]['main'] ==
                  //                         'Rain'
                  //                 ? Icons.cloud
                  //                 : Icons.sunny,
                  //             temp: data['list'][i]['main']['temp'].toString(),
                  //             time: data['list'][i]['dt'].toString()),
                  //     ],
                  //   ),
                  // ),

                  // improvement
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: (ctx, i) {
                          final hourlyForcast = data['list'][i + 2];
                          final timeDT = hourlyForcast['dt_txt'].toString();
                          final time = DateTime.parse(timeDT);
                          return ForcastCard(
                            time: DateFormat.j().format(time),
                            temp: hourlyForcast['main']['temp'].toString(),
                            icon: hourlyForcast['weather'][0]['main'] ==
                                        'Clouds' ||
                                    hourlyForcast['weather'][0]['main'] ==
                                        'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                          );
                        }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Additional Info',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoCard(
                        icon: Icons.water_drop,
                        title: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfoCard(
                        icon: Icons.air,
                        title: 'wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfoCard(
                        icon: Icons.beach_access,
                        title: 'pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
