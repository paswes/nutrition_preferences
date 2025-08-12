import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences/features/nutrition_preferences/domain/entities/food_tag_entity.dart';
import 'package:preferences/features/nutrition_preferences/presentation/cubit/nutrition_preferences_cubit.dart';
import 'package:preferences/features/nutrition_preferences/presentation/widgets/food_tags_list.dart';

class FoodTagsDetailPage extends StatefulWidget {
  const FoodTagsDetailPage({
    super.key,
    required this.title,
    required this.foodTags,
    this.showPreferenceTypeSelection = true,
    required this.preferencesCubit,
  });

  final String title;
  final List<FoodTagEntity> foodTags;
  final bool showPreferenceTypeSelection;
  final NutritionPreferencesCubit preferencesCubit;

  @override
  State<FoodTagsDetailPage> createState() => _FoodTagsDetailPageState();
}

class _FoodTagsDetailPageState extends State<FoodTagsDetailPage> {
  List<String> selectedTypes = [];

  void toggleTypes(String type) {
    setState(() {
      if (selectedTypes.contains(type)) {
        selectedTypes.remove(type);
      } else {
        selectedTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mockTypes = [
      'Weizen',
      'Roggen',
      'Gerste',
      'Hafer',
    ];

    final allTypesSelected = selectedTypes.length == mockTypes.length;

    return BlocProvider.value(
      value: widget.preferencesCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.tealAccent,
          title: Text(widget.title),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showPreferenceTypeSelection)
                _PreferenceTypeSelection(
                  types: mockTypes,
                  selectedTypes: selectedTypes,
                  onSelectAll: () => setState(() {
                    selectedTypes = mockTypes;
                  }),
                  onSelectSingle: toggleTypes,
                ),
              if (!allTypesSelected)
                Expanded(
                  child: FoodTagsList(
                    foodTags: widget.foodTags,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreferenceTypeSelection extends StatelessWidget {
  const _PreferenceTypeSelection({
    required this.types,
    required this.selectedTypes,
    required this.onSelectAll,
    required this.onSelectSingle,
  });

  final List<String> types;
  final List<String> selectedTypes;
  final VoidCallback onSelectAll;
  final Function(String) onSelectSingle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: [
        FilterChip(
          label: Text('Alle'),
          selected: selectedTypes.length == types.length,
          onSelected: (_) => onSelectAll(),
        ),
        ...types.map((type) {
          final isSelected = selectedTypes.contains(type);

          return FilterChip(
            label: Text(type),
            selected: isSelected,
            onSelected: (_) => onSelectSingle(type),
          );
        }),
      ],
    );
  }
}
