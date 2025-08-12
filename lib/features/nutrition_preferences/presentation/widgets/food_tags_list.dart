import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences/features/nutrition_preferences/domain/entities/food_tag_entity.dart';
import 'package:preferences/features/nutrition_preferences/presentation/cubit/nutrition_preferences_cubit.dart';
import 'package:preferences/features/nutrition_preferences/presentation/pages/food_tags_detail_page.dart';

class FoodTagsList extends StatelessWidget {
  const FoodTagsList({
    super.key,
    required this.foodTags,
  });

  final List<FoodTagEntity> foodTags;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NutritionPreferencesCubit>();

    void onTap(FoodTagEntity foodTag) {
      final foodTagChildren = foodTag.children;
      if (foodTagChildren.isEmpty) return;

      final showPreferenceTypeSelection = foodTag.parentTagId == null;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoodTagsDetailPage(
            title: foodTag.nameDe,
            foodTags: foodTagChildren,
            showPreferenceTypeSelection: showPreferenceTypeSelection,
            preferencesCubit: cubit,
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: foodTags.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final foodTag = foodTags[index];
        final foodTagChildren = foodTag.children;
        final hasChildren = foodTagChildren.isNotEmpty;

        return ListTile(
          title: Text(foodTag.nameDe),
          trailing: hasChildren ? Icon(Icons.chevron_right) : null,
          leading:
              BlocBuilder<NutritionPreferencesCubit, NutritionPreferencesState>(
            builder: (context, state) {
              final selectedFoodTags = state.selectedExcludedFoodTags;
              final isSelected = selectedFoodTags.contains(foodTag);

              return Checkbox(
                value: isSelected,
                onChanged: (_) => cubit.onSelectedFoodTagChanged(foodTag),
              );
            },
          ),
          onTap: () => onTap(foodTag),
        );
      },
    );
  }
}
