import 'package:flutter/material.dart';

class CreatePopup extends StatelessWidget {
  final void Function(String type)? onSelect;
  const CreatePopup({super.key, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 250,
      decoration: BoxDecoration(
        color: Color.fromARGB(181, 98, 93, 152),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 50,
            height: 50,
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                onSelect?.call("checklist");
              },
              icon: const Icon(Icons.check_box, color: Colors.white),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                onSelect?.call("daily");
              },
              icon: const Icon(Icons.emoji_emotions, color: Colors.white),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                onSelect?.call("series");
              },
              icon: const Icon(Icons.edit_document, color: Colors.white),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            color: Colors.transparent,
            child: IconButton(
              onPressed: () {
                onSelect?.call("memo");
              },
              icon: const Icon(
                Icons.my_library_books_sharp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
