import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xbox_minecraft_tools/data/main_list.dart';
import 'package:xbox_minecraft_tools/ffi/channel.dart';
import 'package:xbox_minecraft_tools/io/hive.dart';
import 'package:xbox_minecraft_tools/ui/proxy_UI.dart';

class MainUI extends StatefulWidget {
  const MainUI({Key? key}) : super(key: key);

  @override
  _MainUIState createState() => _MainUIState();
}

class _MainUIState extends State<MainUI> {
  bool? ffiOK = null;
  List<MainListData>? list = null;

  @override
  void initState() {
    ffiOK = CoreLibChannel.Ping() == "ok";
    _loadData();
    super.initState();
  }

  _loadData() async {
    list = await HiveDB.getMainServerList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          if (ffiOK != true) {
            return makeFFIStatus();
          }
          return Scaffold(
            appBar: AppBar(
              title: Text("XMT"),
              actions: [
                IconButton(
                    tooltip: "Add Server",
                    onPressed: () {
                      _showAddServerDialog(context);
                    },
                    icon: Icon(Icons.add)),
                IconButton(
                  onPressed: () {
                    _openUrl("https://github.com/xkeyC/xbox_minecraft_tools");
                  },
                  icon: Icon(Icons.info),
                  tooltip: "About",
                )
              ],
            ),
            body: list == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : (list!.length == 0
                    ? Center(
                        child: Text("Add A Server to Start."),
                      )
                    : ListView.builder(
                        itemCount: list!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final data = list![index];
                          return Card(
                            child: ListTile(
                              title: Text(
                                data.title,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${data.host}:${data.port}"),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  list!.remove(data);
                                  list = await HiveDB.saveMainServerList(list!);
                                  setState(() {});
                                },
                              ),
                              onTap: () {
                                _goProxyUI(context, data);
                              },
                            ),
                          );
                        },
                      )),
          );
        },
      ),
    );
  }

  _goProxyUI(BuildContext context, MainListData data) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return ProxyUI(data: data);
    }));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
  }

  _showAddServerDialog(BuildContext context) async {
    final name = TextEditingController();
    final host = TextEditingController();
    final port = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Add Minecraft Server"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: InputDecoration(
                      labelText: "Server Name", hintText: "A Server"),
                ),
                TextField(
                  controller: host,
                  decoration: InputDecoration(
                      labelText: "Minecraft Server Host/IP",
                      hintText: "192.168.0.1"),
                ),
                TextField(
                  controller: port,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      labelText: "Minecraft Server Port", hintText: "19132"),
                ),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (name.text == "" || host.text == "" || port.text == "") {
                      return;
                    }
                    list!.add(MainListData(name.text, host.text, port.text));
                    list = await HiveDB.saveMainServerList(list!);
                    Navigator.pop(context);
                    setState(() {});
                  },
                  child: Text("OK")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("CANCEL")),
            ],
          );
        });
  }

  _openUrl(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : print('Could not launch $_url');

  Widget makeFFIStatus() {
    return Center(
      child: Text(ffiOK == null ? "Initializing..." : "FFI Check Failure!"),
    );
  }
}
