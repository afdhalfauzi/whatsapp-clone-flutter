import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/api_manager.dart';
import 'package:flutter_application_1/utils/show_toast.dart';
import 'package:flutter_application_1/views/pages/api_get_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class APIDeletePage extends StatefulWidget {
  const APIDeletePage({super.key});

  @override
  State<APIDeletePage> createState() => _APIDeletePageState();
}

class _APIDeletePageState extends State<APIDeletePage> {
  @override
  Widget build(BuildContext context) {
    final api = Provider.of<APIManager>(context, listen: false);
    return Column(
      children: [
        Expanded(child: APIGetPage()),
        Row(
          children: [
            ElevatedButton(
              onPressed: () async {
                final tableName = "admin";
                final idName = "admin9";
                try {
                  final msg = await api.delete(table: tableName, id: idName);
                  showToast(msg);
                  setState(() {});
                } catch (e) {
                  showToast("Delete failed: $e");
                }
              },
              child: Text(
                "Delete admin9",
                style: TextStyle(fontSize: 10),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final msg = await api.put(
                    table: "admin",
                    newData: {"adminId": "admin1", "email": "admin1@email.com"},
                  );
                  setState(() {
                    showToast(msg);
                  });
                } catch (e) {
                  showToast("Update failed: $e");
                }
              },
              child: Text("Update admin1", style: TextStyle(fontSize: 10)),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final msg = await api.post(
                    table: "admin",
                    newData: {
                      "adminId": "admin9",
                      "name": "aku admin9",
                      "email": "admin9@email.com",
                      "phoneNumber": "081234567890",
                      "accountProvider": "email",
                      "createdAt": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
                    },
                  );
                  setState(() {
                    showToast(msg);
                  });
                } catch (e) {
                  showToast("Update failed: $e");
                }
              },
              child: Text("Post admin9", style: TextStyle(fontSize: 10)),
            ),
          ],
        ),
      ],
    );
  }
}
