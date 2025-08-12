import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preferences/features/nutrition_preferences/domain/entities/food_tag_entity.dart';

const foodTagsMock = [
  FoodTagEntity(
    id: 'mockId1',
    tag: 'nuts',
    nameDe: 'Nüsse',
    type: 'category',
    parentTagId: null,
    allergens: [],
    dietPractices: [],
  ),
  FoodTagEntity(
    id: 'mockId2',
    tag: 'fruit',
    nameDe: 'Obst',
    type: 'category',
    parentTagId: null,
    allergens: [],
    dietPractices: [],
  ),
  FoodTagEntity(
    id: 'mockId3',
    tag: 'vegetables',
    nameDe: 'Gemüse',
    type: 'category',
    parentTagId: null,
    allergens: [],
    dietPractices: [],
  ),
  FoodTagEntity(
    id: 'mockId4',
    tag: 'animalProducts',
    nameDe: 'Tierprodukte',
    type: 'category',
    parentTagId: null,
    allergens: [],
    dietPractices: [],
  ),
];

abstract class FoodTagsRepository {
  Future<List<FoodTagEntity>> getAllFoodTags();
  Future<List<FoodTagEntity>> getAllRootFoodTags();
  Future<List<FoodTagEntity>> getChildrenFoodTagsByParentTagId(
    String parentTagId,
  );
}

class FirestoreFoodTagsRepository implements FoodTagsRepository {
  final FirebaseFirestore firestore;
  final String collectionName = 'FoodTags';

  FirestoreFoodTagsRepository(this.firestore);

  @override
  Future<List<FoodTagEntity>> getAllFoodTags() async {
    final snapshot = await firestore.collection(collectionName).get();

    final tags = snapshot.docs.map((doc) {
      return FoodTagEntity.fromDocument(docId: doc.id, docData: doc.data());
    }).toList();

    final tagsWithMocks = [...tags, ...foodTagsMock];

    return tagsWithMocks;
  }

  @override
  Future<List<FoodTagEntity>> getAllRootFoodTags() async {
    // We do not need this for current state of the feature
    throw UnimplementedError();
  }

  @override
  Future<List<FoodTagEntity>> getChildrenFoodTagsByParentTagId(
    String parentTagId,
  ) async {
    // We do not need this for current state of the feature
    throw UnimplementedError();
  }
}
