import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences/features/nutrition_preferences/domain/repositories/food_tags_repository.dart';
import 'package:preferences/features/nutrition_preferences/presentation/cubit/nutrition_preferences_cubit.dart';
import 'package:preferences/features/nutrition_preferences/presentation/pages/nutrition_preferences_page.dart';
import 'package:preferences/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  final foodTagsRepository = FirestoreFoodTagsRepository(firestore);

  runApp(App(foodTagsRepository: foodTagsRepository));
}

class App extends StatelessWidget {
  const App({
    super.key,
    required this.foodTagsRepository,
  });

  final FoodTagsRepository foodTagsRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: foodTagsRepository,
      child: MaterialApp(
        home: BlocProvider(
          create: (context) =>
              NutritionPreferencesCubit(foodTagsRepository)..initialize(),
          child: NutritionPreferencesPage(),
        ),
      ),
    );
  }
}
