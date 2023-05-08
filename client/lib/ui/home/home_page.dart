import 'package:dokki/constants/colors.dart';
import 'package:dokki/constants/common.dart';
import 'package:dokki/providers/book_provider.dart';
import 'package:dokki/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      final bp = Provider.of<BookProvider>(context, listen: false);
      bp.errorMessage = "";
      bp.successMessage = "";
      bp.getLikeBookList("1", PAGE_LIMIT);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bp = Provider.of<BookProvider>(context);

    TabController tabController = TabController(length: 2, vsync: this);
    return Container(
      decoration: const BoxDecoration(color: brandColor100),
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Container(
            width: double.maxFinite,
            height: 220,
            decoration: const BoxDecoration(color: brandColor100),
            child: Column(
              children: [
                Text(
                  Utils.getToday(),
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 50),
                const Text(
                  "00 : 00 : 01",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: grayColor000),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: brandColor300,
                    indicatorWeight: 3,
                    labelColor: brandColor300,
                    unselectedLabelColor: brandColor200,
                    controller: tabController,
                    labelPadding: EdgeInsets.symmetric(vertical: 14),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    tabs: const [
                      Tab(
                        text: "읽는 중",
                      ),
                      Tab(
                        text: "찜 목록",
                      ),
                    ],
                  ),
                  Expanded(
                      child: TabBarView(
                    controller: tabController,
                    children: [
                      Text("ss"),
                      Text("aa"),
                    ],
                  ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
