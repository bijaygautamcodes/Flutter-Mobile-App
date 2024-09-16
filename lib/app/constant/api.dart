class ApiConstants {
  // static const String baseUrl = 'http://10.0.2.2:3000';
  static const String baseUrl = 'http://192.168.1.71:3000';
  // static const String baseUrl = 'http://localhost:3000';
  static const String apiUrl = "/api/v0";
  static const String socket = "http://192.168.1.71:3000";
  static const String staticUrl = "/public/media/uploads/all/";

  /* AUTH  */
  static const String register = "$apiUrl/auth/register";
  static const String login = "$apiUrl/auth/login";
  static const String refresh = "$apiUrl/auth/refresh";
  static const String logout = "$apiUrl/auth/logout";

  /* USER */
  static const String whoAmI = '$apiUrl/user/whoami';
  static const String isUsernameUnique = '$apiUrl/user/unique';

  /* ALL */
  static const String user = "$apiUrl/user";
  static const String post = "$apiUrl/post";
  static const String conn = "$apiUrl/conn";
  static const String story = "$apiUrl/story";
  static const String event = "$apiUrl/event";

  static const String connOverview = "$apiUrl/conn/old-recent";
  static const String connRandom = "$apiUrl/conn/random";
  static const String connRecom = "$apiUrl/conn/recom";
}
