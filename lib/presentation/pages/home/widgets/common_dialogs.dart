import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/core/theme/colors.dart';

// 기록 삭제 다이얼로그
Future<bool?> showConfirmDeleteDialog({
  required BuildContext context,
  required String title,
  required String content,
  String cancelText = "취소",
  String confirmText = "삭제",
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: AppColors.level1Color),
      ),
      content: Text(content, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelText,
            style: TextStyle(color: AppColors.whiteTextColor),
          ),
        ),
        Container(
          decoration: BorderBoxDecoration.saveBox,
          child: TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: TextStyle(color: AppColors.whiteTextColor),
            ),
          ),
        ),
      ],
    ),
  );
}

// 새 폴더 생성 다이얼로그
Future<String?> showNewFolderDialog(BuildContext context) async {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        '새 폴더 이름',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: AppColors.level1Color),
      ),
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
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        Container(
          decoration: BorderBoxDecoration.saveBox,
          child: TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(
              '확인',
              style: TextStyle(color: AppColors.whiteTextColor),
            ),
          ),
        ),
      ],
    ),
  );
}

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
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: AppColors.level1Color),
      ),
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
          child: Text(
            cancelText,
            style: TextStyle(color: AppColors.whiteTextColor),
          ),
        ),
        Container(
          decoration: BorderBoxDecoration.saveBox,
          child: TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: Text(
              confirmText,
              style: TextStyle(color: AppColors.whiteTextColor),
            ),
          ),
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
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, color: AppColors.level1Color),
      ),
      content: Text(content, textAlign: TextAlign.center),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            cancelText,
            style: TextStyle(color: AppColors.whiteTextColor),
          ),
        ),
        Container(
          decoration: BorderBoxDecoration.saveBox,
          child: TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmText,
              style: TextStyle(color: AppColors.whiteTextColor),
            ),
          ),
        ),
      ],
    ),
  );
}
