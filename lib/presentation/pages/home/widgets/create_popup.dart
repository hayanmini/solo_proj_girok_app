import 'package:flutter/material.dart';

class CreatePopup extends StatelessWidget {
  const CreatePopup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            //
            Navigator.pop(context);
          },
          child: const Text("Create"),
        ),
      ),
    );
  }
}
