import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences/features/nutrition_preferences/domain/entities/food_tag_entity.dart';
import 'package:preferences/features/nutrition_preferences/presentation/cubit/nutrition_preferences_cubit.dart';
import 'package:preferences/features/nutrition_preferences/presentation/widgets/food_tags_list.dart';

class FoodTagsOverviewPage extends StatefulWidget {
  const FoodTagsOverviewPage({
    super.key,
    required this.preferencesCubit,
  });

  final NutritionPreferencesCubit preferencesCubit;

  @override
  State<FoodTagsOverviewPage> createState() => _FoodTagsOverviewPageState();
}

class _FoodTagsOverviewPageState extends State<FoodTagsOverviewPage> {
  final TextEditingController _searchController = TextEditingController();
  late final List<FoodTagEntity> _flattenedTags;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _flattenedTags = widget.preferencesCubit.state.flattenedTags;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onClearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  List<FoodTagEntity> _filterFoodTags(String query) {
    if (query.isEmpty) return [];

    return _flattenedTags.where((tag) {
      return tag.nameDe.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.preferencesCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.tealAccent,
          title: const Text('Lebensmittel'),
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SearchBar(
                controller: _searchController,
                searchQuery: _searchQuery,
                onSearchChanged: _onSearchChanged,
                onClearSearch: _onClearSearch,
              ),
              Expanded(
                child: BlocBuilder<NutritionPreferencesCubit,
                    NutritionPreferencesState>(
                  builder: (context, state) {
                    final filteredFoodTags = _filterFoodTags(_searchQuery);

                    if (filteredFoodTags.isEmpty && _searchQuery.isNotEmpty) {
                      return const _NoResultsFound();
                    }

                    final tagsToShow = _searchQuery.isNotEmpty
                        ? filteredFoodTags
                        : state.rootTagsWithChildren;

                    return FoodTagsList(foodTags: tagsToShow);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.searchQuery,
    required this.onSearchChanged,
    required this.onClearSearch,
  });

  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintText: 'Lebensmittel suchen...',
        prefixIcon: Icon(Icons.search),
        suffixIcon: searchQuery.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear),
                onPressed: onClearSearch,
              )
            : null,
      ),
      onChanged: onSearchChanged,
    );
  }
}

class _NoResultsFound extends StatelessWidget {
  const _NoResultsFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64),
          Text('Keine Ergebnisse gefunden'),
        ],
      ),
    );
  }
}
