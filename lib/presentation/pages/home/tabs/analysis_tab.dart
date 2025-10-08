import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/core/enums.dart';
import 'package:flutter_girok_app/core/theme/colors.dart';
import 'package:flutter_girok_app/domain/models/ai/ai_request.dart';
import 'package:flutter_girok_app/domain/models/checklist.dart';
import 'package:flutter_girok_app/domain/models/daily.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';
import 'package:flutter_girok_app/presentation/pages/home/widgets/check_list_ratio_bar.dart';
import 'package:flutter_girok_app/presentation/pages/home/widgets/emotion_ratio_bar.dart';
import 'package:flutter_girok_app/presentation/pages/home/widgets/type_ratio_bar.dart';
import 'package:flutter_girok_app/presentation/providers/ai_provider.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_girok_app/presentation/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalysisTab extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const AnalysisTab({super.key, required this.scrollController});

  @override
  ConsumerState<AnalysisTab> createState() => _AnalysisTabState();
}

class _AnalysisTabState extends ConsumerState<AnalysisTab> {
  String? _result;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _sendPrompt();
  }

  Future<void> _sendPrompt() async {
    setState(() => _loading = true);

    try {
      final aiRepo = ref.read(aiRepositoryProvider);
      final response = await aiRepo.request(
        AiRequest(
          prompt: """오늘의 명언 문구 한 마디에서 두마디로 이모지랑 함께 이야기해줘.
              한 문장당 줄 바꿔서 다른 사담 없이 요청한 내용만 이야기 해줘.""",
        ),
      );

      setState(() {
        _result = response.content;
      });
    } catch (e) {
      setState(() {
        _result = "한마디 생각중...\n앱을 재실행하면 확인하실 수 있어요!";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(userIdProvider);

    final recordsAsync = userId == null
        ? const AsyncValue<List<RecordModel>>.data([])
        : ref.watch(allRecordsProvider);

    return SafeArea(
      child: SingleChildScrollView(
        controller: widget.scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 10),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 10),
            titleText("오늘의 한마디"),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              decoration: BorderBoxDecoration.commonBox,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_loading)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Center(
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  if (_result != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),

                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _result!,
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 15),
            Divider(),

            recordsAsync.when(
              data: (records) {
                // CheckList 필터링
                final checklistRecords = records.whereType<CheckList>();
                int total = 0;
                int done = 0;

                for (var record in checklistRecords) {
                  for (var item in record.items) {
                    total++;
                    if (item.check) done++;
                  }
                }

                // Daily 필터링
                final dailies = records.whereType<Daily>().toList();
                final Map<Emotion, int> counts = {
                  for (var e in Emotion.values) e: 0,
                };

                for (final daily in dailies) {
                  counts[daily.emotion] = counts[daily.emotion]! + 1;
                }

                // Type 카운트
                final totalCount = records.length;
                final Map<RecordType, int> typeCounts = {
                  for (var t in RecordType.values) t: 0,
                };

                for (final record in records) {
                  typeCounts[record.type] = typeCounts[record.type]! + 1;
                }

                final Map<RecordType, double> typePercents = {
                  for (var t in RecordType.values)
                    t: totalCount == 0
                        ? 0
                        : (typeCounts[t]! / totalCount * 100),
                };

                // Widget
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // CheckList 통계
                    const SizedBox(height: 10),
                    titleText("할 일 진척도"),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BorderBoxDecoration.commonBox,
                      child: CheckListRatioBar(
                        doneCount: done,
                        totalCount: total,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Divider(),

                    // Daily 통계
                    const SizedBox(height: 10),
                    titleText("기분 분포도"),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BorderBoxDecoration.commonBox,
                      child: EmotionRatioBar(counts: counts),
                    ),
                    const SizedBox(height: 15),
                    Divider(),

                    // 통계
                    const SizedBox(height: 10),
                    titleText("타입별 기록 분포도"),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BorderBoxDecoration.commonBox,
                      child: TypeRatioBar(typePercents: typePercents),
                    ),
                    const SizedBox(height: 15),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              error: (_, __) => const Text("오류가 발생했습니다."),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(title, style: TitleTextStyle.titleBold16),
    );
  }
}
