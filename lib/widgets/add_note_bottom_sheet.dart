import 'package:flutter/material.dart';
import 'package:notes_app/widgets/custom_text_field.dart';

class AddNoteBottomSheet extends StatelessWidget {
  const AddNoteBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 32),
          CustomTextFiel(hint: 'Title'),
          SizedBox(height: 16),
          CustomTextFiel(hint: 'Content', maxLines: 5),
        ],
      ),
    );
  }
}
