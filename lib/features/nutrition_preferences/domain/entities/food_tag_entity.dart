import 'package:equatable/equatable.dart';

class FoodTagEntity extends Equatable {
  const FoodTagEntity({
    required this.id,
    required this.tag,
    required this.nameDe,
    required this.type,
    this.parentTagId,
    required this.allergens,
    required this.dietPractices,
    this.children = const [],
  });

  final String id;
  final String tag;
  final String nameDe;
  final String type;
  final String? parentTagId;
  final List<String> allergens;
  final List<String> dietPractices;
  final List<FoodTagEntity> children;

  factory FoodTagEntity.fromDocument({
    required String docId,
    required Map<String, dynamic> docData,
  }) {
    return FoodTagEntity(
      id: docId,
      tag: (docData['tag'] ?? '') as String,
      nameDe: (docData['nameDe'] ?? '') as String,
      type: (docData['type'] ?? '') as String,
      parentTagId: docData['parentTagId'] as String?,
      allergens: (docData['allergens'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      dietPractices: (docData['dietPractices'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  FoodTagEntity copyWith({
    String? id,
    String? tag,
    String? nameDe,
    String? type,
    String? parentTagId,
    List<String>? allergens,
    List<String>? dietPractices,
    List<FoodTagEntity>? children,
  }) {
    return FoodTagEntity(
      id: id ?? this.id,
      tag: tag ?? this.tag,
      nameDe: nameDe ?? this.nameDe,
      type: type ?? this.type,
      parentTagId: parentTagId ?? this.parentTagId,
      allergens: allergens ?? this.allergens,
      dietPractices: dietPractices ?? this.dietPractices,
      children: children ?? this.children,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nameDe,
        type,
        parentTagId,
        allergens,
        dietPractices,
        children,
      ];
}
