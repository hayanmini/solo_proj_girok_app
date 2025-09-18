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
        // TODO : Theme Color 설정
        color: const Color.fromARGB(145, 48, 48, 48),
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
              icon: const Icon(
                Icons.check_box,
                // TODO : Theme Color 설정
                color: Colors.white,
              ),
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
              icon: const Icon(
                Icons.emoji_emotions,
                // TODO : Theme Color 설정
                color: Colors.white,
              ),
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
              icon: const Icon(
                Icons.folder,
                // TODO : Theme Color 설정
                color: Colors.white,
              ),
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
                Icons.edit,
                // TODO : Theme Color 설정
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
