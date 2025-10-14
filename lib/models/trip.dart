class Trip {
  final int id;
  final String title;
  final String? description;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final double? budget;
  final int createdBy;
  final String? creatorName;
  final String? creatorEmail;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TripParticipant>? participants;

  Trip({
    required this.id,
    required this.title,
    this.description,
    required this.destination,
    required this.startDate,
    required this.endDate,
    this.budget,
    required this.createdBy,
    this.creatorName,
    this.creatorEmail,
    required this.createdAt,
    required this.updatedAt,
    this.participants,
  });

  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }

  bool get isUpcoming {
    return startDate.isAfter(DateTime.now());
  }

  bool get isOngoing {
    final now = DateTime.now();
    return startDate.isBefore(now) && endDate.isAfter(now);
  }

  bool get isPast {
    return endDate.isBefore(DateTime.now());
  }

  String get status {
    if (isUpcoming) return 'Upcoming';
    if (isOngoing) return 'Ongoing';
    return 'Completed';
  }

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      destination: json['destination'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      budget: json['budget']?.toDouble(),
      createdBy: json['createdBy'],
      creatorName: json['creatorName'],
      creatorEmail: json['creatorEmail'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((p) => TripParticipant.fromJson(p))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'budget': budget,
      'createdBy': createdBy,
      'creatorName': creatorName,
      'creatorEmail': creatorEmail,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'participants': participants?.map((p) => p.toJson()).toList(),
    };
  }

  Trip copyWith({
    int? id,
    String? title,
    String? description,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    double? budget,
    int? createdBy,
    String? creatorName,
    String? creatorEmail,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TripParticipant>? participants,
  }) {
    return Trip(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      budget: budget ?? this.budget,
      createdBy: createdBy ?? this.createdBy,
      creatorName: creatorName ?? this.creatorName,
      creatorEmail: creatorEmail ?? this.creatorEmail,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      participants: participants ?? this.participants,
    );
  }

  @override
  String toString() {
    return 'Trip{id: $id, title: $title, destination: $destination, status: $status}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Trip && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class TripParticipant {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final DateTime joinedAt;

  TripParticipant({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.joinedAt,
  });

  String get fullName => '$firstName $lastName';

  factory TripParticipant.fromJson(Map<String, dynamic> json) {
    return TripParticipant(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'] ?? json['firstName'],
      lastName: json['last_name'] ?? json['lastName'],
      joinedAt: DateTime.parse(json['joined_at'] ?? json['joinedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'TripParticipant{id: $id, fullName: $fullName, email: $email}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripParticipant && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
