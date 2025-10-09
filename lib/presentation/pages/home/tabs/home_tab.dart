import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
import 'package:flutter_girok_app/core/theme/colors.dart';
import 'package:flutter_girok_app/domain/models/record_model.dart';
import 'package:flutter_girok_app/presentation/pages/record/view_record/view_check_list_page.dart';
import 'package:flutter_girok_app/presentation/pages/record/view_record/view_daily_page.dart';
import 'package:flutter_girok_app/presentation/pages/record/view_record/view_memo_page.dart';
import 'package:flutter_girok_app/presentation/pages/record/view_record/view_series_page.dart';
import 'package:flutter_girok_app/presentation/providers/record_provider.dart';
import 'package:flutter_girok_app/presentation/providers/user_provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onEmptyDateTap;

  const HomeTab({
    super.key,
    required this.scrollController,
    required this.onEmptyDateTap,
  });

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  var currentColumnCount = 0;

  @override
  void initState() {
    super.initState();

    final date = DateTime.now();
    final firstDayOfMonth = DateTime(date.year, date.month, 1);
    final startWeekday = firstDayOfMonth.weekday % 7;
    final lastDayOfMonth = DateTime(date.year, date.month + 1, 0).day;
    final totalNeededSlots = startWeekday + lastDayOfMonth;
    currentColumnCount = (totalNeededSlots / 7).ceil();

    Future.microtask(() {
      final userId = ref.watch(userIdProvider);
      if (userId != null) {
        ref.read(allRecordsProvider.notifier).loadRecordList(userId);
      }
    });
  }

  String _formatDateTitle(DateTime date) {
    return '${date.month}월 ${date.day}일 ${weekdayToKorean(date.weekday)}요일';
  }

  @override
  Widget build(BuildContext context) {
    final fbUser = fb.FirebaseAuth.instance.currentUser;
    final selectedDate = ref.watch(selectedRecordDateProvider);
    final recordsAsync = fbUser != null
        ? ref.watch(allRecordsProvider)
        : const AsyncValue.data(<RecordModel>[]);

    return SafeArea(
      child: Scaffold(
        body: recordsAsync.when(
          data: (allRecords) {
            final recordsForDate = <DateTime, List<RecordModel>>{};
            for (var record in allRecords) {
              final date = DateTime(
                record.date.year,
                record.date.month,
                record.date.day,
              );
              if (!recordsForDate.containsKey(date)) {
                recordsForDate[date] = [];
              }
              recordsForDate[date]!.add(record);
            }
            return LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  controller: widget.scrollController,
                  child: Column(
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.7,

                        child: SfCalendar(
                          view: CalendarView.month,
                          headerHeight: 50,
                          viewHeaderHeight: -1,
                          headerStyle: CalendarHeaderStyle(
                            backgroundColor: AppColors.background,
                            textAlign: TextAlign.center,
                          ),

                          viewHeaderStyle: ViewHeaderStyle(
                            backgroundColor: AppColors.secondColor,
                            dayTextStyle: const TextStyle(color: Colors.white),
                          ),
                          selectionDecoration: BoxDecoration(),
                          monthViewSettings: const MonthViewSettings(
                            showTrailingAndLeadingDates: false,
                            dayFormat: 'EE',
                            appointmentDisplayMode:
                                MonthAppointmentDisplayMode.none,
                          ),

                          onViewChanged: (details) {
                            // 2) 시작 요일 (월=1 ... 일=7) → 캘린더 기준으로 쓰려면 일요일을 0으로 맞출 수 있음
                            final firstDay = details.visibleDates.first;
                            final startWeekday =
                                firstDay.weekday % 7; // 일요일 = 0

                            // 3) 실제 필요한 칸 수 = 앞 공백 + 날짜 길이
                            final totalSlots =
                                startWeekday + details.visibleDates.length;

                            // 4) 7로 나눈 후 올림 → 줄 수
                            WidgetsBinding.instance.addPostFrameCallback((t) {
                              setState(() {
                                currentColumnCount = (totalSlots / 7).ceil();
                              });
                            });
                          },
                          onTap: (calendarTapDetails) async {
                            final tapped = calendarTapDetails.date;
                            if (tapped != null) {
                              final date = DateTime(
                                tapped.year,
                                tapped.month,
                                tapped.day,
                              );
                              final selectedDateNotifier = ref.read(
                                selectedRecordDateProvider.notifier,
                              );
                              selectedDateNotifier.state = date;

                              final records = ref.read(
                                recordsForSelectedDateProvider,
                              );
                              if (records.isEmpty) {
                                widget.onEmptyDateTap();
                              }
                            }
                          },
                          monthCellBuilder: (context, details) {
                            final date = DateTime(
                              details.date.year,
                              details.date.month,
                              details.date.day,
                            );
                            final isSelected =
                                date.year == selectedDate.year &&
                                date.month == selectedDate.month &&
                                date.day == selectedDate.day;
                            final dateRecordList = recordsForDate[date];
                            return GestureDetector(
                              onTap: () async {
                                final selectedDateNotifier = ref.read(
                                  selectedRecordDateProvider.notifier,
                                );
                                selectedDateNotifier.state = date;
                                final records = ref.read(
                                  recordsForSelectedDateProvider,
                                );

                                if (records.isEmpty) {
                                  widget.onEmptyDateTap();
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: details.bounds.width * 0.7,
                                    height: details.bounds.height * 0.58,
                                    decoration: BoxDecoration(
                                      color: AppColors.containerColor,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.pointColor
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      "${dateRecordList?.length ?? 0}",
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${date.day}',
                                    style: TextStyle(
                                      color: isSelected
                                          ? AppColors.pointColor
                                          : Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // 캘린더와 컨테이너 간격
                      SizedBox(height: 30),

                      Container(
                        child: Consumer(
                          builder: (context, ref, _) {
                            final userId = ref.watch(userIdProvider);
                            final records = userId == null
                                ? []
                                : ref.watch(recordsForSelectedDateProvider);
                            return records.isEmpty
                                ? const SizedBox.shrink()
                                : Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                    decoration: BorderBoxDecoration.commonBox,

                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _formatDateTitle(
                                            ref.read(
                                              selectedRecordDateProvider,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ...records.map(
                                          (record) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: _buildScheduleItem(
                                              record,
                                              record.title,
                                              record.type,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
          error: (e, _) => Text("오류: $e"),
        ),
      ),
    );
  }

  Widget _buildScheduleItem(dynamic record, String title, dynamic type) {
    return InkWell(
      onTap: () {
        final userId = ref.watch(userIdProvider);

        if (type.toString() == "RecordType.checklist") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ViewCheckListPage(userId: userId!, record: record),
            ),
          );
        } else if (type.toString() == "RecordType.daily") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewDailyPage(userId: userId!, record: record),
            ),
          );
        } else if (type.toString() == "RecordType.series") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewSeriesPage(userId: userId!, record: record),
            ),
          );
        } else if (type.toString() == "RecordType.memo") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ViewMemoPage(userId: userId!, record: record),
            ),
          );
        } else {
          Center(child: Text("오류가 발생했습니다."));
        }
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            margin: const EdgeInsets.only(right: 8),
            // decoration: BorderBoxDecoration.commonBox,
            child: Icon(typeIcon(type), color: Colors.white),
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
