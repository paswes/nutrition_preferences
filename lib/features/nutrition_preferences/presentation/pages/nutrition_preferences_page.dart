import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences/features/nutrition_preferences/presentation/cubit/nutrition_preferences_cubit.dart';
import 'package:preferences/features/nutrition_preferences/presentation/widgets/preferences_selection.dart';

class NutritionPreferencesPage extends StatelessWidget {
  const NutritionPreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.tealAccent,
        title: const Text('Ernährung'),
        elevation: 0,
      ),
      body: BlocBuilder<NutritionPreferencesCubit, NutritionPreferencesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AllergensSelection(),
                FoodTagsSelection(),
              ],
            ),
          );
        },
      ),
    );
  }
}
