import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences/features/nutrition_preferences/domain/entities/food_tag_entity.dart';
import 'package:preferences/features/nutrition_preferences/presentation/cubit/nutrition_preferences_cubit.dart';
import 'package:preferences/features/nutrition_preferences/presentation/pages/food_tags_overview_page.dart';
import 'package:preferences/features/nutrition_preferences/presentation/widgets/allergens_selection_picker_sheet.dart';

class AllergensSelection extends StatelessWidget {
  const AllergensSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NutritionPreferencesCubit>();
    final state = context.select((NutritionPreferencesCubit c) => c.state);

    Future<void> onAddAllergens() async {
      final unselectedAllergens = state.unselectedAllergens;
      final result = await AllergensSelectionPickerSheet.show(
        context,
        unselectedAllergens,
      );

      if (result != null) {
        cubit.onAddAllergens(result);
      }
    }

    return _PreferencesSelectionBase<String>(
      title: 'Allergene',
      selectedItems: state.selectedIncompatibleAllergens,
      getLabel: (allergen) => allergen,
      onDelete: (allergen) => cubit.onRemoveAllergen(allergen),
      onAdd: onAddAllergens,
      showAddButton: state.unselectedAllergens.isNotEmpty,
    );
  }
}

class FoodTagsSelection extends StatelessWidget {
  const FoodTagsSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NutritionPreferencesCubit>();
    final selectedFoodTags = context.select(
      (NutritionPreferencesCubit c) => c.state.selectedExcludedFoodTags,
    );

    void onAddFoodTags() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodTagsOverviewPage(
            preferencesCubit: cubit,
          ),
        ),
      );
    }

    return _PreferencesSelectionBase<FoodTagEntity>(
      title: 'Lebensmittel',
      selectedItems: selectedFoodTags,
      getLabel: (tag) => tag.nameDe,
      onDelete: (tag) => cubit.onRemoveFoodTag(tag),
      onAdd: onAddFoodTags,
      showAddButton: true,
    );
  }
}

class _PreferencesSelectionBase<T> extends StatelessWidget {
  const _PreferencesSelectionBase({
    super.key,
    required this.title,
    required this.selectedItems,
    required this.getLabel,
    required this.onDelete,
    required this.onAdd,
    this.showAddButton = true,
  });

  final String title;
  final List<T> selectedItems;
  final String Function(T) getLabel;
  final void Function(T) onDelete;
  final VoidCallback onAdd;
  final bool showAddButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        Wrap(
          spacing: 8,
          children: [
            ...selectedItems.map(
              (item) => InputChip(
                label: Text(getLabel(item)),
                deleteIcon: const Icon(Icons.close),
                onDeleted: () => onDelete(item),
              ),
            ),
            if (showAddButton)
              ActionChip(
                label: const Text('Hinzufügen'),
                avatar: const Icon(Icons.add),
                onPressed: onAdd,
              ),
          ],
        ),
      ],
    );
  }
}
