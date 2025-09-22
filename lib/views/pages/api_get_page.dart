import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/api_manager.dart';
import 'package:provider/provider.dart';

class APIGetPage extends StatefulWidget {
  const APIGetPage({super.key});

  @override
  State<APIGetPage> createState() => _APIGetPageState();
}

class _APIGetPageState extends State<APIGetPage> {
  @override
  Widget build(BuildContext context) {
    final api = Provider.of<APIManager>(context, listen: false);
    return Material(
      child: FutureBuilder(
        future: api.get(table: "admin"),
        builder: (context, snapshot) {
          return RefreshIndicator(
            child: _listView(snapshot),
            onRefresh: _pullRefresh,
          );
        },
      ),
    );
  }

  Widget _listView(AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return Center(child: Text('No data found'));
    } else {
      final apiData = snapshot.data!;
      return ListView.builder(
        itemCount: apiData.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              safeText(apiData[index]["adminId"]),
              safeText(apiData[index]["name"]),
              safeText(apiData[index]["email"]),
              safeText(apiData[index]["phoneNumber"]),
              safeText(apiData[index]["accountProvider"]),
              safeText(apiData[index]["createdAt"]),

              // safeText(apiData[index]["tenantId"]),
              // safeText(apiData[index]["roomId"]),
              // safeText(apiData[index]["name"]),
              // safeText(apiData[index]["email"]),
              // safeText(apiData[index]["phoneNumber"]),
              // safeText(apiData[index]["accountProvider"]),
              // safeText(apiData[index]["createdAt"]),

              // safeText(apiData[index]["roomId"]),
              // safeText(apiData[index]["roomNumber"]),
              // safeText(apiData[index]["status"]),
              // safeText(apiData[index]["facilities"]),
              // safeText(apiData[index]["price"]),
              // safeText(apiData[index]["photoUrl"]),
              // safeText(apiData[index]["createdAt"]),

              // safeText(apiData[index]["contractId"]),
              // safeText(apiData[index]["tenantId"]),
              // safeText(apiData[index]["startDate"]),
              // safeText(apiData[index]["endDate"]),
              // safeText(apiData[index]["status"]),
              // safeText(apiData[index]["createdAt"]),

              // safeText(apiData[index]["paymentId"]),
              // safeText(apiData[index]["contractId"]),
              // safeText(apiData[index]["amount"]),
              // safeText(apiData[index]["paymentDate"]),
              // safeText(apiData[index]["method"]),
              // safeText(apiData[index]["status"]),
              // safeText(apiData[index]["receiptUrl"]),
              // safeText(apiData[index]["createdAt"]),

              // safeText(apiData[index]["bookingId"]),
              // safeText(apiData[index]["tenantId"]),
              // safeText(apiData[index]["roomId"]),
              // safeText(apiData[index]["startDate"]),
              // safeText(apiData[index]["endDate"]),
              // safeText(apiData[index]["status"]),
              // safeText(apiData[index]["createdAt"]),

              // safeText(apiData[index]["complaintId"]),
              // safeText(apiData[index]["tenantId"]),
              // safeText(apiData[index]["roomId"]),
              // safeText(apiData[index]["description"]),
              // safeText(apiData[index]["status"]),
              // safeText(apiData[index]["createdAt"]),

              // safeText(apiData[index]["announcementId"]),
              // safeText(apiData[index]["adminId"]),
              // safeText(apiData[index]["title"]),
              // safeText(apiData[index]["message"]),
              // safeText(apiData[index]["targetAudience"]),
              // safeText(apiData[index]["createdAt"]),

              // safeText(apiData[index]["deviceId"]),
              // safeText(apiData[index]["roomId"]),
              // safeText(apiData[index]["deviceType"]),
              // safeText(apiData[index]["status"]),
              // safeText(apiData[index]["lastUpdated"]),
              SizedBox(height: 20),
            ],
          );
        },
      );
    }
  }
  // }

  Widget safeText(String? value) {
    //only show text if text != null
    if (value == null) return const SizedBox.shrink(); // return kosong
    final str = value.toString().trim();
    if (str.isEmpty)
      return const SizedBox.shrink(); // kalau kosong juga gak ditampilkan
    return Text(str);
  }

  Future<void> _pullRefresh() async {
    setState(() {});
  }
}
