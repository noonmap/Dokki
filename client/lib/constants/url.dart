// User 관련 API URL
class UserApiUrl {
  static const baseUrl = "https://dokki.kr/api/users";

  static const login = "$baseUrl/login"; // 로그인
  static const logout = "$baseUrl/logout"; // 로그아웃
  /*
  * @params
  * search : string
  * page : int
  * size : int
  * @response
  * List<UserModel>
  */
  static const search = baseUrl; // 사용자 검색

  static const updateNickname = "$baseUrl/profile/nickname"; // 사용자 닉네임 수정
  static const updateImage = "$baseUrl/profile/image"; // 사용자 이미지 수정

  // 사용자 프로필 정보 조희
  static String detailProfile(String userId) {
    return "$baseUrl/profile/$userId";
  }

  // 사용자 독끼풀 상태 조회
  static String dokkiState(String userId) {
    return "$baseUrl/dokki/$userId";
  }

  // 팔로우 추가,취소
  // POST : 추가
  // DELETE : 제거
  static String follow(String userId) {
    return "$baseUrl/follow/$userId";
  }
}

// Book 관련 API URL
class BookApiUrl {
  static const baseUrl = "https://dokki.kr/api/books";

  static const recommend = baseUrl; // 추천 도서 검색

  static const search = "$baseUrl/search"; // 도서 검색

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
