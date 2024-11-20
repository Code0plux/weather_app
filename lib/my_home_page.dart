import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/hourly_forecast_card.dart';
import 'package:weather_app/additional_info.dart';
import 'package:weather_app/data/forecast.dart';
import 'package:weather_app/services/weather_service.dart';

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  final _textEditingController = TextEditingController();
  final _border = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),
  );

  late Future<Forecast?> _forecastFuture;
  Forecast? _forecast;
  final _forecastService = ForecastService();

  void _getForecast() {
    _forecastFuture = _forecastService
        .getWeatherUpdate(
          _textEditingController.text.isEmpty
              ? null
              : _textEditingController.text,
        )
        .then((forecast) => _forecast = forecast);
  }

  @override
  void initState() {
    super.initState();

    _getForecast();
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
            onPressed: () => setState(_getForecast),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _forecastFuture, // This future will be refreshed on retry
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return _buildErrorView();
          }
          return _buildSuccessView();
        },
      ),
    );
  }

  Widget _buildErrorView() {
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
              _textEditingController.clear();
              setState(_getForecast);
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

  Widget _buildSuccessView() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: "City",
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      prefixIconColor: Colors.black,
                      filled: true,
                      enabledBorder: _border,
                      focusedBorder: _border,
                      fillColor: const Color.fromARGB(218, 255, 255, 255),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                IconButton(
                  onPressed: () => setState(_getForecast),
                  icon: const Icon(Icons.search),
                )
              ],
            ),
            const SizedBox(height: 20),
            _buildConditionsOverview(),
            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Weather Forecast",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            _buildHourlyForecast(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Weather Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionsOverview() {
    return SizedBox(
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
                    '${_forecast?.temperature?.toStringAsFixed(2)} °C',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 32),
                  ),
                  Icon(
                    _forecast?.icon,
                    size: 64,
                  ),
                  Text(
                    _forecast?.conditions ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          if (_forecast?.firstTemperature != null)
            HourlyForecastCard(
              temperature: _forecast!.firstTemperature!,
            ),
          if (_forecast?.secondTemperature != null)
            HourlyForecastCard(
              temperature: _forecast!.secondTemperature!,
            ),
          if (_forecast?.thirdTemperature != null)
            HourlyForecastCard(
              temperature: _forecast!.thirdTemperature!,
            ),
          if (_forecast?.fourthTemperature != null)
            HourlyForecastCard(
              temperature: _forecast!.fourthTemperature!,
            ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            if (_forecast?.humidity != null)
              Additionalinfo(
                label: "Humidity",
                icon: Icons.water,
                value: _forecast!.humidity.toString(),
              ),
            if (_forecast?.windSpeed != null)
              Additionalinfo(
                label: "Wind Speed",
                icon: Icons.air,
                value: _forecast!.windSpeed.toString(),
              ),
            if (_forecast?.pressure != null)
              Additionalinfo(
                label: "Pressure",
                icon: Icons.format_align_center,
                value: _forecast!.pressure.toString(),
              ),
          ],
        ),
      ),
    );
  }
}
