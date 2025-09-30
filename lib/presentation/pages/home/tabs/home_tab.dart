import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';
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
  final ValueChanged<DateTime>? onDateSelected;

  const HomeTab({
    super.key,
    required this.scrollController,
    required this.onEmptyDateTap,
    this.onDateSelected,
  });

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDateSelected?.call(_selectedDate!);
    });
  }

  String _formatDateTitle(DateTime date) {
    return '${date.month}월 ${date.day}일 ${weekdayToKorean(date.weekday)}요일';
  }

  Future<void> _loadRecordsForDate(DateTime date) async {
    final fbUser = fb.FirebaseAuth.instance.currentUser;
    if (fbUser != null) {
      await ref
          .read(recordsProvider.notifier)
          .loadRecords(RecordQuery(userId: fbUser.uid, date: date));
    }
  }

  @override
  Widget build(BuildContext context) {
    final fbUser = fb.FirebaseAuth.instance.currentUser;
    final recordsAsync = fbUser != null
        ? ref.watch(recordsProvider)
        : const AsyncValue.data([]);

    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
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
                      headerStyle: CalendarHeaderStyle(
                        textAlign: TextAlign.center,
                      ),

                      viewHeaderStyle: ViewHeaderStyle(
                        backgroundColor: Colors.grey[700],
                        dayTextStyle: const TextStyle(color: Colors.white),
                      ),

                      monthViewSettings: const MonthViewSettings(
                        showTrailingAndLeadingDates: false,
                        dayFormat: 'EE',
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.none,
                      ),

                      onTap: (calendarTapDetails) async {
                        final tapped = calendarTapDetails.date;
                        if (tapped != null) {
                          final date = DateTime(
                            tapped.year,
                            tapped.month,
                            tapped.day,
                          );
                          setState(() {
                            _selectedDate = date;
                          });
                          widget.onDateSelected?.call(date);

                          await _loadRecordsForDate(date);
                          final records = ref.read(recordsProvider).value ?? [];

                          if (records.isEmpty) {
                            widget.onEmptyDateTap();
                          }
                        }
                      },
                      monthCellBuilder: (context, details) {
                        final date = details.date;
                        final isSelected =
                            _selectedDate != null &&
                            date.year == _selectedDate!.year &&
                            date.month == _selectedDate!.month &&
                            date.day == _selectedDate!.day;

                        return GestureDetector(
                          onTap: () async {
                            setState(() {
                              _selectedDate = date;
                            });
                            widget.onDateSelected?.call(date);

                            await _loadRecordsForDate(date);
                            final records =
                                ref.read(recordsProvider).value ?? [];

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
                                  color: isSelected
                                      ? Colors.purple[100]
                                      : Colors.grey[400],
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.purple.shade200
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${date.day}',
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.purple.shade200
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
                  SizedBox(height: constraints.maxHeight * 0.05),

                  Container(
                    child: _selectedDate == null
                        ? const Center(
                            child: Text(
                              '날짜를 선택해주세요',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : Consumer(
                            builder: (context, ref, _) {
                              final userId = ref.watch(userIdProvider);
                              final recordsAsync = userId == null
                                  ? const AsyncValue<List<RecordModel>>.data([])
                                  : ref.watch(recordsProvider);

                              return recordsAsync.when(
                                data: (records) {
                                  // 선택된 날짜 기준으로 필터링
                                  final filteredRecords = records
                                      .where(
                                        (r) =>
                                            r.date.year ==
                                                _selectedDate!.year &&
                                            r.date.month ==
                                                _selectedDate!.month &&
                                            r.date.day == _selectedDate!.day,
                                      )
                                      .toList();
                                  if (filteredRecords.isEmpty) {
                                    return const SizedBox.shrink();
                                  }

                                  return Container(
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
                                          _formatDateTitle(_selectedDate!),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        ...filteredRecords.map(
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
                                loading: () => const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                                error: (e, _) => Text("오류: $e"),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
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
