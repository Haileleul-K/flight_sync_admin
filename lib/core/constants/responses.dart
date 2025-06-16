class AdminLoginData {
  final String token;
  final bool isAdmin;
  final AdminUser user;

  AdminLoginData({
    required this.token,
    required this.isAdmin,
    required this.user,
  });

  factory AdminLoginData.fromJson(Map<String, dynamic> json) {
    return AdminLoginData(
      token: json['token'],
      isAdmin: json['is_admin'] == 1, // Convert 1/0 to boolean
      user: AdminUser.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'is_admin': isAdmin ? 1 : 0, // Convert boolean back to 1/0
      'user': user.toJson(),
    };
  }
}

class AdminUser {
  final int id;
  final String fullName;
  final String email;

  AdminUser({
    required this.id,
    required this.fullName,
    required this.email,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
    };
  }
}




class FacLevel {
  final int? id;
  final String? level;

  FacLevel({this.id, this.level});

  factory FacLevel.fromJson(Map<String, dynamic> json) {
    return FacLevel(
      id: json['id'],
      level: json['level'],
    );
  }

    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'level': level,
    };
  }
}

class AircraftModel {
  final int? id;
  final String? model;
  final List<String>? seats;

  AircraftModel({this.id, this.model, this.seats});

  factory AircraftModel.fromJson(Map<String, dynamic> json) {
    return AircraftModel(
      id: json['id'],
      model: json['model'],
      seats: json['seats'] != null ? List<String>.from(json['seats']) : null,
    );
  }

    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'model': model,
      'seats': seats,
    };
  }
}

class Rank {
  final int? id;
  final String? name;

  Rank({this.id, this.name});

  factory Rank.fromJson(Map<String, dynamic> json) {
    return Rank(
      id: json['id'],
      name: json['name'],
    );
  }

    Map<String, dynamic> toMap() {
    return <String, dynamic>{
           'name': name,
    };
  }
}

class RlLevel {
  final int? id;
  final String? level;

  RlLevel({this.id, this.level});

  factory RlLevel.fromJson(Map<String, dynamic> json) {
    return RlLevel(
      id: json['id'],
      level: json['level'],
    );
  }

    Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'level': level,
    };
  }
}



class Mission {
  final int? id;
  final String? code;
  final String? label;

  Mission({this.id, this.code, this.label});

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      code: json['code'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'label': label,
    };
  }
}

class DutyPosition {
  final int? id;
  final String? code;
  final String? label;

  DutyPosition({this.id, this.code, this.label});

  factory DutyPosition.fromJson(Map<String, dynamic> json) {
    return DutyPosition(
      id: json['id'],
      code: json['code'],
      label: json['label'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'code': code,
      'label': label,
    };
  }
}



class DashboardData {
  final int totalUsers;
  final String subscribedUsersIncreasePercent;
  final int totalFlightsLogged;
  final double totalAircraftHours;
  final double totalSimulatorHours;
  final Map<String, AircraftHours> aircraftUsage;

  DashboardData({
    required this.totalUsers,
    required this.subscribedUsersIncreasePercent,
    required this.totalFlightsLogged,
    required this.totalAircraftHours,
    required this.totalSimulatorHours,
    required this.aircraftUsage,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final aircraftUsageMap = <String, AircraftHours>{};
    if (json['AircraftUsage'] != null) {
      (json['AircraftUsage'] as Map<String, dynamic>).forEach((key, value) {
        aircraftUsageMap[key] = AircraftHours.fromJson(value);
      });
    }

    return DashboardData(
      totalUsers: json['total_users'] as int,
      subscribedUsersIncreasePercent: json['subscribed_users_increase_percent'] as String,
      totalFlightsLogged: json['total_flights_logged'] as int,
      totalAircraftHours: double.parse(json['total_aircraft_hours'] as String),
      totalSimulatorHours: double.parse(json['total_simulator_hours'] as String),
      aircraftUsage: aircraftUsageMap,
    );
  }

  Map<String, dynamic> toJson() => {
        'total_users': totalUsers,
        'subscribed_users_increase_percent': subscribedUsersIncreasePercent,
        'total_flights_logged': totalFlightsLogged,
        'total_aircraft_hours': totalAircraftHours.toString(),
        'total_simulator_hours': totalSimulatorHours.toString(),
        'AircraftUsage': aircraftUsage.map((k, v) => MapEntry(k, v.toJson())),
      };
}

class AircraftHours {
  final double hours;

  AircraftHours({required this.hours});

  factory AircraftHours.fromJson(Map<String, dynamic> json) {
    return AircraftHours(
      hours: double.parse(json['hours'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'hours': hours.toString(),
      };
}