// Book 관련 API URL
class BookApiUrl {
  static const baseUrl = "http://10.0.2.2:5010/books";

  static const recommend = baseUrl; // 추천 도서 검색

  // 도서 검색 URL
  static String getSearchUrl(
      String search, String queryType, int page, int size) {
    return "$baseUrl/search?search=$search&queryType=$queryType&page=$page&size=$size";
  }

  static const myLike = "$baseUrl/like"; // 찜한 책 조회

  static const readBook = "$baseUrl/read-book"; // 읽는 중(타이머)인 책 조회

  // POST : 찜한 책 추가
  // DELETE : 찜한 책 제거
  static String myLikeToggle(String bookId) {
    return "$baseUrl/like/$bookId";
  }

  // 책 상태 변경
  // reading : 완독(컬렉션) -> 진행 중(타이머)
  // complete : 진행 중(타이머) -> 완독(컬렉션)
  static String updateState(String bookId, String state) {
    switch (state) {
      case "reading":
        return "$baseUrl/status/$bookId/reading";
      case "complete":
        return "$baseUrl/status/$bookId/complete";
      default:
        return "error";
    }
  }

  // 책 상세 조회
  static String detail(String bookId) {
    return "$baseUrl/$bookId";
  }

  // 한해 독서 기록 조회
  static String history(String userId) {
    return "$baseUrl/history/$userId";
  }

  // 한달 독서 시간 조회
  static String historyTime(String userId) {
    return "$baseUrl/history/time/$userId";
  }

  // 다 읽은 책 조회
  static String collection(String userId) {
    return "$baseUrl/collections/$userId";
  }

  // 컬렉션에서 책 제거
  // DELETE
  static String removeCollection(String bookId) {
    return "$baseUrl/collections/$bookId";
  }

  // 읽고 있는 책(타이머)에서 책 제거
  // DELETE
  static String removeTimer(String bookId) {
    return "$baseUrl/read-book/$bookId";
  }
}
