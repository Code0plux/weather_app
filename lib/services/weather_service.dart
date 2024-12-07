import 'package:weather_app/credentials.dart';
import 'package:weather_app/data/forecast.dart';
import 'package:http/http.dart' as http;

class ForecastService {
  Future<Forecast?> getWeatherUpdate(String? city) async {
    final response = await http.get(
      Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?q=${city ?? 'trichy'}&APPID=$weatherApiKey",
      ),
    );

    if (response.statusCode == 200) {
      return Forecast.fromString(response.body);
    } else {
      throw Error();
    }
  }
}
