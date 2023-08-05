import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'dart:html';

import 'constant/value.dart';

class MegaMindBot extends StatefulWidget {
  const MegaMindBot({Key? key}) : super(key: key);

  @override
  State<MegaMindBot> createState() => _MegaMindBotState();
}

class _MegaMindBotState extends State<MegaMindBot> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  IO.Socket socket = IO.io('http://0.0.0.0:8080/sock');
  late Timer timer;

  String userText = '';
  String botText = '';

  String backImage = 'assets/starting.gif';

  int countDown = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    socket.onConnect((_) {
      // print('connected');
      showSnackBar(
          context,
          'ChatGPT Bot is starting \nIt will take $countDown second to start',
          countDown);
    });

    // update data
    socket.on('data_response', (data) {
      // print(data);
      userText = data['userText'];
      botText = data['botText'];
      backImage = userText.isEmpty
          ? "assets/wakeup.gif"
          : botText.isEmpty
              ? "assets/listening.gif"
              : "assets/answering.gif";
      setState(() {});
    });

    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => waitAndCount());
  }

  void waitAndCount() {
    // await Future.delayed(const Duration(seconds: 1));
    if (countDown == 0) {
      timer.cancel();
      backImage = 'wakeup.gif';
      setState(() {});
      return;
    }
    setState(() => countDown--);
  }

  @override
  Widget build(BuildContext context) {
    document.documentElement!.requestFullscreen();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: GestureDetector(
            onDoubleTap: () {
              document.documentElement!.requestFullscreen();
            },
            child: Stack(
              fit: StackFit.loose,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              children: [
                Image.asset(
                  backImage,
                  height: Size.infinite.height,
                  width: Size.infinite.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: size.width / 4.2,
                  right: size.width / 3.2,
                  top: size.height / 5.5,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(botText.isEmpty ? "" : userText,
                            style: const TextStyle(
                                fontSize: fontBig,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: size.width / 5,
                  right: size.width / 3.2,
                  top: size.height / 1.9,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(botText.isEmpty ? userText : botText,
                            style: const TextStyle(
                                fontSize: fontBig,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 18,
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        const Text("Powered by : ",
                            style: TextStyle(
                                fontSize: 20, fontFamily: "monospace")),
                        Image.asset(
                          "MegaMind_ai.png",
                          height: 60,
                          width: 120,
                          color: Colors.blue,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
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
