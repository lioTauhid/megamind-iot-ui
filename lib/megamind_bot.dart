import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fullscreen_window/fullscreen_window.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'dart:html';

class MegaMindBot extends StatefulWidget {
  const MegaMindBot({Key? key}) : super(key: key);

  @override
  State<MegaMindBot> createState() => _MegaMindBotState();
}

class _MegaMindBotState extends State<MegaMindBot> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  IO.Socket socket = IO.io('http://0.0.0.0:8080/sock');
  late Timer timer;

  String userText = 'Say, Hi MegaMind to wakeup bot';
  String botText = '';
  String genderType = 'loading';
  Map productMap = {};
  int maskState = 2;

  int countDown = 5;

  // int countDown = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    socket.onConnect((_) {
      // print('connected');
      // socket.emit('data_event', {
      //   'mask': '2',
      //   'botText': '',
      //   'userText': 'Say, Hi MegaMind to wakeup bot',
      //   'genderType': genderType,
      // });
      showSnackBar(context,
          'ChatGPT Bot is starting \nIt will take 10 second to start', 10);
      // socket.emit('app_event', {'app': '0'});
    });

    // update data
    socket.on('data_response', (data) {
      print(data);
      // maskState = int.parse(data['mask']);
      userText = data['userText'];
      botText = data['botText'];
      genderType = data['genderType'];
      setState(() {});
    });

    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => waitAndCount());
  }

  void waitAndCount() {
    // await Future.delayed(const Duration(seconds: 1));
    if (countDown == 0) {
      timer.cancel();
      setState(() {});
      showSnackBar(context,
          'ChatGPT Bot is starting \nIt will take 10 second to start', 10);
      return;
    }
    setState(() => countDown--);
  }

  @override
  Widget build(BuildContext context) {
    document.documentElement!.requestFullscreen();

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onDoubleTap: () {
              document.documentElement!.requestFullscreen();
            },
            child: Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                Image.asset(
                  "assets/starting.gif",
                  height: Size.infinite.height,
                  width: Size.infinite.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 8,
                  right: 18,
                  child: Container(
                    height: 30,
                    padding: EdgeInsets.zero,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.volume_off,
                          color: Colors.blue, size: 20),
                      label: const Text(
                        "UNMUTE",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message, int duration) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating,
      // padding: EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(600, 20, 20, 20),
      duration: Duration(seconds: duration),
      backgroundColor: Colors.lightBlue,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      action: SnackBarAction(
        label: 'Ok',
        textColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
