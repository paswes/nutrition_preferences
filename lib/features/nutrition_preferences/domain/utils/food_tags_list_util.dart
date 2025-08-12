import 'package:preferences/features/nutrition_preferences/domain/entities/food_tag_entity.dart';

class FoodTagsListUtil {
  static List<FoodTagEntity> getStructuredTags(List<FoodTagEntity> flatTags) {
    final tagMap = {
      for (var tag in flatTags) tag.id: tag.copyWith(children: [])
    };

    List<FoodTagEntity> structuredTags = [];

    for (var tag in tagMap.values) {
      if (tag.parentTagId == null) {
        structuredTags.add(tag);
      } else {
        final parentTag = tagMap[tag.parentTagId];
        if (parentTag != null) {
          parentTag.children.add(tag);
        }
      }
    }

    return structuredTags;
  }

  static List<FoodTagEntity> getFlattenedTags(
      List<FoodTagEntity> structuredTags) {
    List<FoodTagEntity> flatTags = [];

    void addTagAndChildren(FoodTagEntity tag) {
      flatTags.add(tag);
      for (final child in tag.children) {
        addTagAndChildren(child);
      }
    }

    for (final tag in structuredTags) {
      addTagAndChildren(tag);
    }

    return flatTags;
  }
}
