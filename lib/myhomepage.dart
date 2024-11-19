import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/HourlyForecastCard.dart';
import 'package:weather_app/additionalinfo.dart';

class Myhomepage extends StatefulWidget {
  const Myhomepage({super.key});

  @override
  State<Myhomepage> createState() => _MyhomepageState();
}

class _MyhomepageState extends State<Myhomepage> {
  double temp = 0;
  String atemp = "";
  String cclimat = "";
  String chumidity = "";
  String cwindspeed = "";
  String cpressure = "";
  late DateTime onetime;
  String onetemperature = "";
  String oneicon = "";
  late DateTime twotime;
  String twotemperature = "";
  String twoicon = "";
  late DateTime threetime;
  String threetemperature = "";
  String threeicon = "";
  late DateTime fourtime;
  String fourtemperature = "";
  String fouricon = "";

  late IconData cicon = Icons.cloud;
  final textEditingController = TextEditingController();
  final border = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),
  );

  late Future<bool> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = getweatherupdate();
  }

  IconData getWeatherIcon(String weather) {
    switch (weather.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'snow':
        return Icons.ac_unit;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'drizzle':
        return Icons.grain;
      case 'mist':
        return Icons.water;
      case 'fog':
        return Icons.foggy;
      case 'haze':
        return Icons.foggy;
      default:
        return Icons.help_outline;
    }
  }

  Future<bool> getweatherupdate([String city = "trichy"]) async {
    if (textEditingController.text.isNotEmpty) {
      city = textEditingController.text;
    }
    String apiKey = "65b6e54bb72d508e4eaff28dd1238c1b"; // Secure this later

    try {
      final response = await http.get(
        Uri.parse(
            "https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$apiKey"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temp = data["list"][0]["main"]["temp"] - 273.15;
          cclimat = data["list"][0]["weather"][0]["main"];
          atemp = "${temp.toStringAsFixed(2)} °C";
          cpressure = data["list"][0]["main"]["pressure"].toString();
          chumidity = data["list"][0]["main"]["humidity"].toString();
          cwindspeed = data["list"][0]["wind"]["speed"].toString();
          cicon = getWeatherIcon(cclimat);
          onetime = DateTime.parse(data["list"][1]['dt_txt']);
          onetemperature =
              (data["list"][1]["main"]['temp'] - 273.15).toStringAsFixed(2);
          oneicon = data["list"][1]["weather"][0]["main"];
          twotime = DateTime.parse(data["list"][2]['dt_txt']);
          twotemperature =
              (data["list"][2]["main"]['temp'] - 273.15).toStringAsFixed(2);
          twoicon = data["list"][2]["weather"][0]["main"];
          threetime = DateTime.parse(data["list"][3]['dt_txt']);
          threetemperature =
              (data["list"][3]["main"]['temp'] - 273.15).toStringAsFixed(2);
          threeicon = data["list"][3]["weather"][0]["main"];
          fourtime = DateTime.parse(data["list"][4]['dt_txt']);
          fourtemperature =
              (data["list"][4]["main"]['temp'] - 273.15).toStringAsFixed(2);
          fouricon = data["list"][4]["weather"][0]["main"];
        });
        return true;
      } else {
        throw Error;
      }
    } catch (e) {
      throw Error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weatherFuture = getweatherupdate(); // Refreshes the future
              });
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: weatherFuture, // This future will be refreshed on retry
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Show error screen
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 80),
                  const SizedBox(height: 16),
                  const Text(
                    "Invalid city. Please try again.",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Refresh the weather data
                      setState(() {
                        weatherFuture = getweatherupdate();
                        // Reset the Future
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: "City",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      prefixIconColor: Colors.black,
                      filled: true,
                      enabledBorder: border,
                      focusedBorder: border,
                      fillColor: const Color.fromARGB(218, 255, 255, 255),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  atemp,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32),
                                ),
                                Icon(
                                  cicon,
                                  size: 64,
                                ),
                                Text(
                                  cclimat,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Weather Forecast",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HourlyForecastCard(
                          time: (DateFormat.Hm().format(onetime)).toString(),
                          temperature: onetemperature,
                          icon: getWeatherIcon(oneicon),
                        ),
                        HourlyForecastCard(
                          time: (DateFormat.Hm().format(twotime)).toString(),
                          temperature: twotemperature,
                          icon: getWeatherIcon(twoicon),
                        ),
                        HourlyForecastCard(
                          time: (DateFormat.Hm().format(threetime)).toString(),
                          temperature: threetemperature,
                          icon: getWeatherIcon(threeicon),
                        ),
                        HourlyForecastCard(
                          time: (DateFormat.Hm().format(fourtime)).toString(),
                          temperature: fourtemperature,
                          icon: getWeatherIcon(fouricon),
                        ),
                      ],
                    ),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Weather Details",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Additionalinfo(
                              label: "Humidity",
                              icon: Icons.water,
                              value: chumidity,
                            ),
                            Additionalinfo(
                              label: "Wind Speed",
                              icon: Icons.air,
                              value: cwindspeed,
                            ),
                            Additionalinfo(
                              label: "Pressure",
                              icon: Icons.format_align_center,
                              value: cpressure,
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
