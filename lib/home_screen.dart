import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:apiassignment/data_model.dart';
import 'dart:convert';
import 'package:apiassignment/single_data.dart';

class ApiData extends StatefulWidget {
  const ApiData({super.key});

  @override
  State<ApiData> createState() => _ApiDataState();
}

class _ApiDataState extends State<ApiData> {
  List<GetDataModel> mydata = [];
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Gallery App"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: mydata.length,
        itemBuilder: (context, index) {
          return _listData(mydata[index]);
        },
      ),
    );
  }

  Widget _listData(GetDataModel data) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          String url, title, id;
          url = data.url.toString();
          title = data.title.toString();
          id = data.id.toString();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SingleData(url: url, title: title, id: id);
          }));
        },
        child: ListTile(
          leading: Image.network(data.thumbnailUrl.toString()),
          title: Wrap(children: [Text(data.title.toString())]),
        ),
      ),
    );
  }

  Future<void> getData() async {
    mydata.clear();
    String Url = 'https://jsonplaceholder.typicode.com/photos';
    Uri uri = Uri.parse(Url);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      final decodeData = jsonDecode(response.body);
      final List getData = decodeData;
      for (Map i in getData) {
        mydata.add(GetDataModel.fromJson(i));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Unable to get data')));
    }

    setState(() {});
  }
}
