class ApiConstant {
  //API Calling URL
  static const String SERVER_IP_PORT = 'http://172.16.61.221:8052';
  static const String BASE_URL = '$SERVER_IP_PORT/api/v1/';

  //Request
  static const int LIST_VIEW_PAGE_SIZE = 20;

  //Response Area.
  static const String FULL_RESPONSE = 'Full Response';
  static const String DATA_RESPONSE = 'data';

  //Response Key
  static const STATUS_CODE_KEY = 'statusCode';
  static const TOTAL_COUNT = 'totalCount';
  static const SAMPLE_PROFILE_IMAGE_URL =
      'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500';
}
