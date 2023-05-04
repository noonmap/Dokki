import 'package:dokki/constants/colors.dart';
import 'package:dokki/data/model/library/library_book_model.dart';
import 'package:dokki/providers/library_provider.dart';
import 'package:dokki/ui/common_widgets/paragraph.dart';
import 'package:dokki/utils/routes/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  // 🍇 임시 유저 ID
  int userId = 0;

  int page = 0;
  List<LibraryBookModel> libraryBooks = [];

  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  Future<void> setLibrary(LibraryProvider lp) async {
    setState(() => isLoadingMore = true);

    await lp.getLibraryBooks(userId: userId, page: page);

    setState(() {
      libraryBooks = [...libraryBooks, ...lp.libraryBooks];
      isLoadingMore = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      final lp = Provider.of<LibraryProvider>(context, listen: false);
      setLibrary(lp);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lp = Provider.of<LibraryProvider>(context);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (mounted) {
          setState(() => page += 1);
          setLibrary(lp);
        }
      }
    });

    return Scaffold(
      body: lp.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(28, 40, 28, 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 32,
                        height: 32,
                      ),
                      Row(
                        children: [
                          Paragraph(
                            text: '$userId',
                            size: 18,
                            weightType: WeightType.semiBold,
                          ),
                          const Paragraph(
                            text: '님의 서재',
                            size: 18,
                            weightType: WeightType.medium,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(
                          Icons.menu,
                          size: 32,
                          color: brandColor300,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: GridView.builder(
                      controller: _scrollController,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, idx) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RoutesName.bookDetail,
                                arguments: {
                                  'bookId': libraryBooks[idx].bookId
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 10,
                                  offset: const Offset(4, 4),
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ],
                            ),
                            child: Image.network(
                              libraryBooks[idx].bookCoverPath,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      itemCount: libraryBooks.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
