import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeTab extends StatefulWidget {
  final ScrollController scrollController;
  final VoidCallback onEmptyDateTap;

  const HomeTab({
    super.key,
    required this.scrollController,
    required this.onEmptyDateTap,
  });

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              // padding: EdgeInsets.symmetric(horizontal: 10),
              controller: widget.scrollController,
              child: Column(
                children: [
                  // SfCalendar 높이를 화면 높이의 일부로 제한
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
                      onTap: (calendarTapDetails) {
                        if (calendarTapDetails.date != null) {
                          setState(() {
                            _selectedDate = calendarTapDetails.date;
                          });
                          widget.onEmptyDateTap();
                        }
                      },
                      monthCellBuilder: (context, details) {
                        final date = details.date;
                        // if (date == null) return const SizedBox();

                        final isSelected =
                            _selectedDate != null &&
                            date.year == _selectedDate!.year &&
                            date.month == _selectedDate!.month &&
                            date.day == _selectedDate!.day;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                            });
                            widget.onEmptyDateTap();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.purple[100]
                                      : Colors.grey[400],
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.purple
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
                                      ? Colors.purple
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
                  SizedBox(height: constraints.maxHeight * 0.1),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white54),
                    ),
                    child: _selectedDate != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${_selectedDate!.day}일 ${_weekdayToKorean(_selectedDate!.weekday)}요일',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildScheduleItem('타이틀1'),
                              SizedBox(height: 8),
                              _buildScheduleItem('타이틀2'),
                            ],
                          )
                        : const Center(
                            child: Text(
                              '날짜를 선택해주세요',
                              style: TextStyle(color: Colors.white),
                            ),
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

  Widget _buildScheduleItem(String title) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.grey[600],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  String _weekdayToKorean(int weekday) {
    switch (weekday) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      default:
        return '일';
    }
  }
}
