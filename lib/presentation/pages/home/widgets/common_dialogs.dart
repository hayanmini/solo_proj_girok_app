import 'package:flutter/material.dart';

// 폴더 이름 수정 다이얼로그
Future<String?> showEditNameDialog({
  required BuildContext context,
  required String title,
  required String initialName,
  String cancelText = "취소",
  String confirmText = "저장",
}) {
  final controller = TextEditingController(text: initialName);
  final formKey = GlobalKey<FormState>();

  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          validator: (val) {
            if (val == null || val.trim().isEmpty) {
              return "폴더 이름을 입력하세요.";
            }
            return null;
          },
          decoration: const InputDecoration(hintText: "폴더 이름을 입력하세요"),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(context, controller.text.trim());
            }
          },
          child: Text(confirmText),
        ),
      ],
    ),
  );
}

// 삭제 확인 다이얼로그
Future<bool?> showDeleteDialog({
  required BuildContext context,
  required String title,
  required String content,
  String cancelText = "취소",
  String confirmText = "삭제",
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmText),
        ),
      ],
    ),
  );
}
