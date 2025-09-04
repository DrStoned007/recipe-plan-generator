import 'package:json_annotation/json_annotation.dart';
import '../constants/app_constants.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String name;
  final int? age;
  @JsonKey(name: 'diet_type')
  final DietType dietType;
  final List<String>? allergies;
  final Map<String, dynamic>? preferences;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    this.age,
    this.dietType = DietType.none,
    this.allergies,
    this.preferences,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  
  Map<String, dynamic> toJson() => _$UserToJson(this);

  User copyWith({
    String? id,
    String? name,
    int? age,
    DietType? dietType,
    List<String>? allergies,
    Map<String, dynamic>? preferences,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      dietType: dietType ?? this.dietType,
      allergies: allergies ?? this.allergies,
      preferences: preferences ?? this.preferences,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}