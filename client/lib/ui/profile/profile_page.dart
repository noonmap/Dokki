import 'package:dokki/constants/colors.dart';
import 'package:dokki/providers/user_provider.dart';
import 'package:dokki/ui/common_widgets/paragraph.dart';
import 'package:dokki/ui/common_widgets/pink_box.dart';
import 'package:dokki/ui/profile/widgets/profile_menu.dart';
import 'package:dokki/ui/profile/widgets/user_bio.dart';
import 'package:dokki/ui/profile/widgets/user_month_calendar.dart';
import 'package:dokki/ui/profile/widgets/user_year_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 🍇TODO :: userBio - 본인 프로필 여부에 따라 1️⃣팔로우 버튼, 2️⃣메뉴 구성 다르게 하기
// 🍇TODO :: menuItem - onTap 처리하기

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ScrollController _scrollController = ScrollController();

  // 🍇 임시 유저 ID
  int userId = 101;

  int calendarYear = DateTime.now().year;
  int calendarMonth = DateTime.now().month;
  int chartYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    // provider
    final up = Provider.of<UserProvider>(context, listen: false);
    up.getUserBioById(userId);
  }

  @override
  Widget build(BuildContext context) {
    final up = Provider.of<UserProvider>(context);

    void onCalendarArrowTap(String direction) {
      setState(() {
        if (direction == 'left') {
          if (calendarMonth == 1) {
            calendarYear -= 1;
            calendarMonth = 12;
          } else {
            calendarMonth -= 1;
          }
        } else if (direction == 'right') {
          if (!(calendarMonth == DateTime.now().month &&
              calendarYear == DateTime.now().year)) {
            if (calendarMonth == 12) {
              calendarYear += 1;
              calendarMonth = 1;
            } else {
              calendarMonth += 1;
            }
          }
        }
      });
    }

    void onChartArrowTap(String direction) {
      setState(() {
        if (direction == 'left') {
          chartYear -= 1;
        } else if (direction == 'right' && chartYear < DateTime.now().year) {
          chartYear += 1;
        }
      });
    }

    return Scaffold(
      body: up.isLoading || up.userBio == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(28, 48, 28, 48),
              child: Column(
                children: [
                  // 바이오
                  userBio(up: up),
                  const SizedBox(height: 48),
                  // 메뉴
                  const ProfileMenu(),
                  const SizedBox(height: 48),
                  // 독서 달력
                  PinkBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Paragraph(
                          text: '독서 달력',
                          size: 20,
                          weightType: WeightType.semiBold,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => onCalendarArrowTap('left'),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: grayColor300,
                                size: 20,
                              ),
                            ),
                            Column(
                              children: [
                                Paragraph(
                                  text: '$calendarYear',
                                  size: 14,
                                  color: grayColor300,
                                  weightType: WeightType.medium,
                                ),
                                Paragraph(
                                  text: '$calendarMonth월',
                                  size: 20,
                                  weightType: WeightType.semiBold,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => onCalendarArrowTap('right'),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: grayColor300,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        UserMonthCalendar(
                          up: up,
                          userId: userId,
                          year: calendarYear,
                          month: calendarMonth,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // 한 해 기록
                  PinkBox(
                    width: double.infinity,
                    height: 360.toDouble(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Paragraph(
                          text: '한 해 기록',
                          size: 20,
                          weightType: WeightType.semiBold,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => onChartArrowTap('left'),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: grayColor300,
                                size: 20,
                              ),
                            ),
                            Paragraph(
                              text: '$chartYear',
                              size: 20,
                              weightType: WeightType.semiBold,
                            ),
                            GestureDetector(
                              onTap: () => onChartArrowTap('right'),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: grayColor300,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        UserYearChart(up: up, userId: userId, year: chartYear),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
