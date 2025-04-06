import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './../controller/category_controller.dart'; // Import the category provider
import './../controller/subcategory_controller.dart'; // Import the subcategory provider
import '../model/category_model.dart';
import '../model/subcategory_model.dart';

class AddCategoryScreen extends ConsumerWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the correct providers
    final categoryAsyncValue = ref.watch(
      categoryProvider,
    ); // Use ref.watch() for Riverpod 2.x
    final subcategoryAsyncValue = ref.watch(
      subcategoryProvider,
    ); // Use ref.watch() for Riverpod 2.x

    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Dropdown
            categoryAsyncValue.when(
              data: (categories) {
                return DropdownButtonFormField<Category>(
                  hint: const Text('Select Category'),
                  onChanged: (Category? category) {
                    // Handle category change here
                    // For example, update the subcategory list or state
                    print('Selected Category: ${category?.name}');
                  },
                  items:
                      categories.map((category) {
                        return DropdownMenuItem<Category>(
                          value: category,
                          child: Text(category.name),
                        );
                      }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) {
                return Column(
                  children: [
                    const Text('Error loading categories'),
                    Text('Error details: $e'),
                    ElevatedButton(
                      onPressed: () {
                        // Trigger a reload of categories
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // Subcategory Dropdown
            subcategoryAsyncValue.when(
              data: (subcategories) {
                return DropdownButtonFormField<Subcategory>(
                  hint: const Text('Select Subcategory'),
                  onChanged: (Subcategory? subcategory) {
                    // Handle subcategory change here
                    print('Selected Subcategory: ${subcategory?.name}');
                  },
                  items:
                      subcategories.map((subcategory) {
                        return DropdownMenuItem<Subcategory>(
                          value: subcategory,
                          child: Text(subcategory.name),
                        );
                      }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, stack) {
                return Column(
                  children: [
                    const Text('Error loading subcategories'),
                    Text('Error details: $e'),
                    ElevatedButton(
                      onPressed: () {
                        // Trigger a reload of subcategories
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
