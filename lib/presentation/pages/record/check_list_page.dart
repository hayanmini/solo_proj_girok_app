import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/presentation/pages/record/widgets/save_button.dart';

class CheckListPage extends StatefulWidget {
  const CheckListPage({super.key});

  @override
  State<CheckListPage> createState() => _CheckListPageState();
}

class _CheckListPageState extends State<CheckListPage> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _itemController = [TextEditingController()];

  @override
  Widget build(BuildContext context) {
    final widthQuery = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("9월 20일 토요일", style: TextStyle(color: Colors.white)),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // Title
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BorderBoxDecoration.commonBox,
                      child: Center(
                        child: TextFormField(
                          controller: _titleController,
                          style: TitleTextStyle.recordTitle,
                          decoration: InputDecoration(
                            hint: Center(child: Text("제목을 입력하세요")),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    // Check Item
                    checkItem(widthQuery),
                    SizedBox(height: 10),

                    // Add Button
                    GestureDetector(
                      onTap: () {
                        // TODO :
                      },
                      child: Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BorderBoxDecoration.commonBox,
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),

            // Button
            SaveButton(),
          ],
        ),
      ),
    );
  }

  Row checkItem(double widthQuery) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BorderBoxDecoration.commonBox,
        ),
        SizedBox(width: 10),
        Container(
          width: widthQuery - 95,
          height: 50,
          decoration: BorderBoxDecoration.commonBox,
          child: TextFormField(),
        ),
      ],
    );
  }
}
