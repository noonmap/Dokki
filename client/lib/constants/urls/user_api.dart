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
