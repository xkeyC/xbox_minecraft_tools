import 'package:flutter/material.dart';
import 'package:xbox_minecraft_tools/data/main_list.dart';
import 'package:xbox_minecraft_tools/ffi/channel.dart';

class ProxyUI extends StatefulWidget {
  final MainListData data;

  const ProxyUI({Key? key, required this.data}) : super(key: key);

  @override
  _ProxyUIState createState() => _ProxyUIState();
}

class _ProxyUIState extends State<ProxyUI> {
  @override
  void initState() {
    _openUDPProxy();
    super.initState();
  }

  _openUDPProxy() async {
    final result =
        await CoreLibChannel.StartUDPProxy(widget.data.host, widget.data.port);
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
              child: Icon(Icons.close),
              onPressed: () {
                CoreLibChannel.StopUDPProxy();
              }),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.data.title,
                  style: TextStyle(fontSize: 28),
                ),
                SizedBox(
                  height: 14,
                ),
                Text(
                  "${widget.data.host}:${widget.data.port}",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(
                  height: 14,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 28, right: 28),
                  child: Text(
                    "Now, open your Xbox, start your Minecraft, switch to the friends page, surprise!",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          return false;
        });
  }
}
