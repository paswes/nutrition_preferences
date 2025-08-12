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

  bool get isLoading => status == PreferencesStateStatus.loading;
  List<String> get unselectedAllergens => availableAllergens
      .where((allergen) => !selectedIncompatibleAllergens.contains(allergen))
      .toList();

  @override
  List<Object?> get props => [
        availableAllergens,
        selectedIncompatibleAllergens,
        availableFoodTags,
        selectedExcludedFoodTags,
      ];
}
