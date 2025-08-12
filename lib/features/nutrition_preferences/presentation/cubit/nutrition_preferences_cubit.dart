import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences/features/nutrition_preferences/domain/entities/food_tag_entity.dart';
import 'package:preferences/features/nutrition_preferences/domain/repositories/food_tags_repository.dart';

part 'nutrition_preferences_state.dart';

class NutritionPreferencesCubit extends Cubit<NutritionPreferencesState> {
  final FoodTagsRepository repository;

  NutritionPreferencesCubit(this.repository)
      : super(const NutritionPreferencesState());

  Future<void> initialize() async {
    emit(state.copyWith(status: PreferencesStateStatus.loading));

    final availableAllergens = await _loadAvailableAllergens();
    final availableFoodTags = await repository.getAllFoodTags();

    emit(state.copyWith(
      availableAllergens: availableAllergens,
      availableFoodTags: availableFoodTags,
      status: PreferencesStateStatus.loaded,
    ));
  }

  Future<List<String>> _loadAvailableAllergens() async {
    const mockAllergens = [
      'Gluten',
      'Eier',
      'Fisch',
      'Milch',
      'Nüsse',
      'Sesam',
      'Sulfit',
    ];

    // TODO: fetch allergens from backend
    await Future.delayed(const Duration(milliseconds: 500), () {});

    return mockAllergens;
  }

  void onAddAllergens(List<String> allergens) {
    emit(state.copyWith(
      selectedIncompatibleAllergens: [
        ...state.selectedIncompatibleAllergens,
        ...allergens,
      ],
    ));
  }

  void onRemoveAllergen(String allergen) {
    final updatedAllergens = state.selectedIncompatibleAllergens
        .where((e) => e != allergen)
        .toList();

    emit(state.copyWith(selectedIncompatibleAllergens: updatedAllergens));
  }

  void onSelectedFoodTagChanged(FoodTagEntity foodTag) {
    final selectedFoodTags = state.selectedExcludedFoodTags;
    final isSelected = selectedFoodTags.contains(foodTag);

    final updatedTags = isSelected
        ? selectedFoodTags.where((e) => e.id != foodTag.id).toList()
        : [...selectedFoodTags, foodTag];

    emit(state.copyWith(selectedExcludedFoodTags: updatedTags));
  }

  void onRemoveFoodTag(FoodTagEntity foodTag) {
    final updatedFoodTags =
        state.selectedExcludedFoodTags.where((e) => e != foodTag).toList();

    emit(state.copyWith(selectedExcludedFoodTags: updatedFoodTags));
  }
}
