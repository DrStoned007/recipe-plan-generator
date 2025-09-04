// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['id'] as String,
  name: json['name'] as String,
  age: (json['age'] as num?)?.toInt(),
  dietType:
      $enumDecodeNullable(_$DietTypeEnumMap, json['diet_type']) ??
      DietType.none,
  allergies: (json['allergies'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  preferences: json['preferences'] as Map<String, dynamic>?,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'age': instance.age,
  'diet_type': _$DietTypeEnumMap[instance.dietType]!,
  'allergies': instance.allergies,
  'preferences': instance.preferences,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
};

const _$DietTypeEnumMap = {
  DietType.diabetic: 'diabetic',
  DietType.renal: 'renal',
  DietType.heartHealthy: 'heartHealthy',
  DietType.lowFodmap: 'lowFodmap',
  DietType.none: 'none',
};
