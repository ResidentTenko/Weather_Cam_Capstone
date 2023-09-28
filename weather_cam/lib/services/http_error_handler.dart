// handles errors if our response code is not 200 - 200 means successful
import "package:http/http.dart" as http;

// receives a http response type arguement and returns a string
String httpErrorHandler(http.Response response) {
  final String errorMessage =
      'Request Failed\nStatus Code: ${response.statusCode}\nReason: ${response.reasonPhrase}';
  return errorMessage;
}
