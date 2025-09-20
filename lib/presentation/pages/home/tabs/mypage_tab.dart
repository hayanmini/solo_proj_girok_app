import 'package:flutter/material.dart';
import 'package:flutter_girok_app/core/constants.dart';

class MypageTab extends StatelessWidget {
  final ScrollController scrollController;
  const MypageTab({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("마이페이지")),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 계정 정보
              titleText("계정"),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BorderBoxDecoration.commonBox,
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      color: Colors.transparent,
                      // TODO : 로그인 플랫폼(구글, 애플)
                      child: Icon(Icons.person),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "로그인 정보",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "그 외 다룰 정보",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(),

              // 폴더
              SizedBox(height: 10),
              titleText("폴더"),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 170,
                    height: 100,
                    decoration: BorderBoxDecoration.commonBox,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(width: 10),
                            // TODO : 글자수 초과 시 오버플로우 처리
                            Text(
                              "폴더명",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Container(
                              // width: 50,
                              height: 50,
                              color: Colors.transparent,
                              child: IconButton(
                                onPressed: () {
                                  //
                                },
                                icon: Icon(Icons.edit),
                              ),
                            ),
                            Container(
                              // width: 50,
                              height: 50,
                              color: Colors.transparent,
                              child: IconButton(
                                onPressed: () {
                                  //
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                        Text("작성한 글 1"),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  // 가짜, 실제 데이터 연결 시 아이템 카운트
                  Container(
                    width: 170,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(),

              // Record List
              SizedBox(height: 10),
              titleText("내가 작성한 글"),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 500,
                decoration: BorderBoxDecoration.commonBox,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // TODO : ListView Builder 사용
                      _buildScheduleItem("작성 리스트"),
                      _buildScheduleItem("작성 리스트"),
                      _buildScheduleItem("작성 리스트"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 타이틀 속성
  Widget titleText(String title) {
    return Text(title, style: TitleTextStyle.titleBold16);
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
}
