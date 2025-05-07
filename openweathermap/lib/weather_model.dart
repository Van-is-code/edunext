class Weather {
  final String time;
  final double temperature;
  final String icon;

  Weather({required this.time, required this.temperature, required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    final timestamp = json['dt'] as int;
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)
        .toLocal()
        .toIso8601String()
        .substring(11, 16); // Chuyển thành HH:mm
    return Weather(
      time: time,
      temperature: json['temp'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}