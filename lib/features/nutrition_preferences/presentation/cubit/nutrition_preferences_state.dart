part of 'nutrition_preferences_cubit.dart';

enum PreferencesStateStatus {
  initial,
  loading,
  loaded,
  error,
}

class NutritionPreferencesState extends Equatable {
  const NutritionPreferencesState({
    this.availableAllergens = const [],
    this.selectedIncompatibleAllergens = const [],
    this.availableFoodTags = const [],
    this.selectedExcludedFoodTags = const [],
    this.status = PreferencesStateStatus.initial,
  });

  final List<String> availableAllergens;
  final List<String> selectedIncompatibleAllergens;
  final List<FoodTagEntity> availableFoodTags;
  final List<FoodTagEntity> selectedExcludedFoodTags;
  final PreferencesStateStatus status;

  NutritionPreferencesState copyWith({
    List<String>? availableAllergens,
    List<String>? selectedIncompatibleAllergens,
    List<FoodTagEntity>? availableFoodTags,
    List<FoodTagEntity>? selectedExcludedFoodTags,
    PreferencesStateStatus? status,
  }) {
    return NutritionPreferencesState(
      availableAllergens: availableAllergens ?? this.availableAllergens,
      selectedIncompatibleAllergens:
          selectedIncompatibleAllergens ?? this.selectedIncompatibleAllergens,
      availableFoodTags: availableFoodTags ?? this.availableFoodTags,
      selectedExcludedFoodTags:
          selectedExcludedFoodTags ?? this.selectedExcludedFoodTags,
      status: status ?? this.status,
    );
  }

  List<String> get unselectedAllergens => availableAllergens
      .where((allergen) => !selectedIncompatibleAllergens.contains(allergen))
      .toList();

  List<FoodTagEntity> get rootTagsWithChildren {
    final tagMap = {
      for (var tag in availableFoodTags) tag.id: tag.copyWith(children: [])
    };

    final List<FoodTagEntity> rootTagsWithChildren = [];

    for (var tag in tagMap.values) {
      if (tag.parentTagId == null) {
        rootTagsWithChildren.add(tag);
      } else {
        final parentFoodTag = tagMap[tag.parentTagId];
        if (parentFoodTag != null) {
          parentFoodTag.children.add(tag);
        }
      }
    }

    return rootTagsWithChildren;
  }

  List<FoodTagEntity> get flattenedTags {
    List<FoodTagEntity> result = [];

    void addTagAndChildren(FoodTagEntity tag) {
      result.add(tag);
      for (final child in tag.children) {
        addTagAndChildren(child);
      }
    }

    for (final tag in rootTagsWithChildren) {
      addTagAndChildren(tag);
    }
    return result;
  }

  bool get isLoading => status == PreferencesStateStatus.loading;

  @override
  List<Object?> get props => [
        availableAllergens,
        selectedIncompatibleAllergens,
        availableFoodTags,
        selectedExcludedFoodTags,
        status,
      ];
}
