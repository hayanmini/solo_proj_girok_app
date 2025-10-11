import 'package:flutter/material.dart';
import 'package:flutter_girok_app/presentation/pages/home/tabs/analysis_tab.dart';
import 'package:flutter_girok_app/presentation/pages/home/tabs/home_tab.dart';
import 'package:flutter_girok_app/presentation/pages/home/tabs/mypage_tab.dart';
import 'package:flutter_girok_app/presentation/pages/home/tabs/settings_tab.dart';
import 'package:flutter_girok_app/presentation/pages/home/widgets/create_popup.dart';
import 'package:flutter_girok_app/presentation/pages/record/check_list_page.dart';
import 'package:flutter_girok_app/presentation/pages/record/daily_page.dart';
import 'package:flutter_girok_app/presentation/pages/record/memo_page.dart';
import 'package:flutter_girok_app/presentation/pages/record/series_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/record_provider.dart';

class MainTabPage extends ConsumerStatefulWidget {
  const MainTabPage({super.key});

  @override
  ConsumerState<MainTabPage> createState() => _MainTabPageState();
}

class _MainTabPageState extends ConsumerState<MainTabPage> {
  int _currentIndex = 0;
  OverlayEntry? _overlayEntry;

  final List<ScrollController> _scrollControllers = List.generate(
    4,
    (_) => ScrollController(),
  );

  @override
  void initState() {
    super.initState();
  }

  // 스크롤 초기화
  @override
  void dispose() {
    for (final c in _scrollControllers) {
      c.dispose();
    }
    _overlayEntry?.remove();
    super.dispose();
  }

  // CreatePopup
  void _toggleCreatePopup() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  // HomeTab 빈 날짜 터치 시
  void _showCreatePopup() {
    if (_overlayEntry == null) {
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  // 페이지 이동
  OverlayEntry _buildOverlayEntry() {
    final width = MediaQuery.of(context).size.width;
    return OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _toggleCreatePopup,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              bottom: 95,
              left: width / 2 - 125,
              child: Material(
                color: Colors.transparent,
                child: CreatePopup(
                  onSelect: (type) {
                    if (type == "checklist") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckListPage(
                            date: ref.read(selectedRecordDateProvider),
                            editingRecord: null,
                          ),
                        ),
                      );
                    } else if (type == "daily") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DailyPage(
                            date: ref.read(selectedRecordDateProvider),
                            editingRecord: null,
                          ),
                        ),
                      );
                    } else if (type == "series") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SeriesPage(
                            date: ref.read(selectedRecordDateProvider),
                            editingRecord: null,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => MemoPage(
                            date: ref.read(selectedRecordDateProvider),
                            editingRecord: null,
                          ),
                        ),
                      );
                    }
                    _toggleCreatePopup();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab Tap 이벤트
  void _onTabTapped(int index) {
    if (index == 2) {
      _toggleCreatePopup();
      return;
    }

    // 동일한 탭에서 다시 터치 시 스크롤 최상단
    if (_currentIndex == index) {
      _scrollControllers[index > 2 ? index - 1 : index].animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  // BottomNavigationBar UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex == 2 ? 0 : _currentIndex,
        children: [
          HomeTab(
            scrollController: _scrollControllers[0],
            onEmptyDateTap: _showCreatePopup,
          ),
          AnalysisTab(scrollController: _scrollControllers[1]),
          const SizedBox(),
          MypageTab(scrollController: _scrollControllers[2]),
          SettingsTab(scrollController: _scrollControllers[3]),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined, size: 24),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics, size: 26),
              label: "분석",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 28),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 28),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: 26),
              label: "",
            ),
          ],
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
    );
  }
}
