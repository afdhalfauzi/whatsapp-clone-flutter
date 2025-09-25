import 'package:http/http.dart' as http;
import 'dart:convert'; // For JSON encoding/decoding

class APIManager {
  static const _baseUrl = "10.0.2.2";

  Future<List<dynamic>> get({
    required String table,
    String?
    select, //without space, default is * | e.g "tenantId,email,phoneNumber"
    String? id,
    Map<String, String>? condition, //e.g {"accountProvider":"google"}
  }) async {
    final _path = "/api/$table.php";
    final queryParams = <String, String>{};

    if (id != null) queryParams["${table}Id"] = id;
    if (select != null) queryParams["select"] = select;
    if (condition != null) queryParams.addAll(condition);

    final response = await http.get(
      Uri.http(_baseUrl, _path, queryParams.isNotEmpty ? queryParams : null),
    );
    print("\nGETTING=======>  \n");
    print("\n${response.body}  \n");
    // if (response.body == "[]") {
    //   final List<dynamic> data = jsonDecode() ;
    //   return null;
    // }
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return (data);
    } else {
      return jsonDecode("Failed to load data: ${response.statusCode}");
    }
  }

  Future<String> post({
    required String table,
    required Map<String, dynamic> newData,
  }) async {
    final _path = "/api/$table.php";
    final response = await http.post(
      Uri.http(_baseUrl, _path),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode(newData),
    );
    print("\nCREATING=======>  \n");
    print("\n${response.body}  \n");
    if (response.statusCode == 200) {
      return "Created succesfully";
    }
    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }

  Future<String> put({
    required String table,
    required Map<String, dynamic> newData,
  }) async {
    final _path = "/api/$table.php";
    final response = await http.put(
      Uri.http(_baseUrl, _path),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode(newData),
    );
    print("\nUPDATING=======>  \n");
    print("\n${response.body}  \n");
    if (response.statusCode == 200) {
      return "Updated succesfully";
    }
    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }

  Future<String> delete({
    required String table,
    required String id,
    Map<String, String>? condition,
  }) async {
    final _path = "/api/$table.php";
    final queryParams = <String, String>{};
    queryParams["${table}Id"] = id;

    if (condition != null) queryParams.addAll(condition);
    final response = await http.delete(
      Uri.http(_baseUrl, _path, queryParams.isNotEmpty ? queryParams : null),
    );
    print("\nDELETING=======>  \n");
    print("\n${response.body}  \n");
    if (response.statusCode == 200) {
      return "$id deleted succesfully";
    }
    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }

  Future<String> notif({required Map<String, dynamic> body}) async {
    final url =
        "https://fcm.googleapis.com/v1/projects/810381943500/messages:send";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization":
            "Bearer ya29.a0AQQ_BDS_UlhngxNcOFrva-20aVf-Vq922iSJLxPVjePd9MT52M2eL_YoZ9lAANYpGeJcL0_I-CkFn6Uk-fyN3pQr51uuqA09xKPrmbmDKsClqUQgvZ4uwDnkuS7Xm1I8cEG_-lV75Qn8bMGqfysD4nkxDTeGkVhlMa2bJX16Uuwr3dOfvNWxjCwzaDJfDiYM8_iGgugaCgYKAXgSARASFQHGX2MihkISsDThbtn6976lM_UtnQ0206",
      },
      body: jsonEncode(body),
    );
    print("\nSENDING=======>  \n");
    print("\n${response.body}  \n");
    if (response.statusCode == 200) {
      return "Sent succesfully";
    }
    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }

  Future<void> sendNotification(String token) async {
    final _path = "/api/req_notif.php";
    final response = await http.post(
      Uri.http(_baseUrl, _path),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode({
        "title": "Kosan App",
        "body": "Bayar bayar",
      }),
    );
    if (response.statusCode == 200) {
      print("Notification sent: ${response.body}");
    } else {
      print("Failed: ${response.statusCode} ${response.body}");
    }
  }
}
