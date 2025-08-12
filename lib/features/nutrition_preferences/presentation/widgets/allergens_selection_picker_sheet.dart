import 'package:flutter/material.dart';

class AllergensSelectionPickerSheet extends StatefulWidget {
  const AllergensSelectionPickerSheet({
    super.key,
    required this.allergens,
  });

  final List<String> allergens;

  static Future<List<String>?> show(
    BuildContext context,
    List<String> allergens,
  ) async {
    return await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => AllergensSelectionPickerSheet(allergens: allergens),
    );
  }

  @override
  State<AllergensSelectionPickerSheet> createState() =>
      _AllergensSelectionPickerSheetState();
}

class _AllergensSelectionPickerSheetState
    extends State<AllergensSelectionPickerSheet> {
  List<String> selected = [];

  void _toggleSelection(String allergen, bool? checked) {
    setState(() {
      if (checked == true) {
        if (!selected.contains(allergen)) {
          selected.add(allergen);
        }
      } else {
        selected.remove(allergen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (_, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: widget.allergens.length,
              itemBuilder: (_, index) {
                final allergen = widget.allergens[index];
                final isSelected = selected.contains(allergen);

                return CheckboxListTile(
                  title: Text(allergen),
                  value: isSelected,
                  onChanged: (checked) => _toggleSelection(allergen, checked),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(selected);
                },
                child: const Text('Fertig'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
