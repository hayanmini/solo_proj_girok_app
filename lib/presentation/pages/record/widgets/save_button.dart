import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomQuery = MediaQuery.of(context).padding.bottom;
    return GestureDetector(
      onTap: () {
        // TODO : Save
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BorderBoxDecoration.saveBox,
              child: Center(
                child: Text("저장", style: TitleTextStyle.titleBold16),
              ),
            ),
            SizedBox(height: bottomQuery + 10),
          ],
        ),
      ),
    );
  }
}
