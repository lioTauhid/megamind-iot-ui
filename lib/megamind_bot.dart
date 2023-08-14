import 'package:flutter/material.dart';
import 'package:megamind_iot_ui/constant/color.dart';
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
  String animatedBotText = '';
  String backImage = 'assets/starting.gif';

  int countDown = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    socket.onConnect((_) {
      // print('connected');
      // showSnackBar(
      //     context,
      //     'Connected. ChatGPT Bot is starting \nIt will take $countDown second to start',
      //     countDown);
    });

    // update data
    socket.on('data_response', (data) {
      // print(data);
      setState(() {
        userText = data['userText'];
        botText = data['botText'];
      });
      updateState();
    });

    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => waitAndCount());
  }

  Future<void> updateState() async {
    setState(() {
      if (userText.isEmpty) {
        backImage = "assets/wakeup.gif";
      } else {
        if (botText.isEmpty) {
          if (userText == "Hello! How can i assist you?") {
            backImage = "assets/after-wakeup.gif";
          } else {
            backImage = "assets/listening.gif";
          }
        } else {
          backImage = "assets/answering.gif";
          _typingAnimation();
        }
      }
    });
  }

  void waitAndCount() {
    // await Future.delayed(const Duration(seconds: 1));
    if (countDown == 0) {
      timer.cancel();
      backImage = 'assets/wakeup.gif';
      setState(() {});
      _typingAnimation();
      return;
    }
    setState(() => countDown--);
  }

  Future<void> _typingAnimation() async {
    animatedBotText = "";
    final List<String> _strings = botText.split(".");
    int _currentIndex = 0;

    for (String s in _strings) {
      if (_currentIndex < _strings.length) {
        List<String> words = "$s.".split(" ");
        for (String w in words) {
          await Future.delayed(const Duration(milliseconds: 120))
              .whenComplete(() {
            setState(() {
              animatedBotText = animatedBotText + w + " ";
            });
          });
        }
        _currentIndex++;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    document.documentElement!.requestFullscreen();
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      body: SizedBox(
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
                height: size.height,
                width: size.width,
                fit: BoxFit.fill,
              ),
              Positioned(
                left: size.width / 30,
                right: size.width / 3,
                top: size.height / 5.5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(botText.isEmpty ? "" : "GUEST :  ",
                        style: const TextStyle(
                            fontSize: fontVeryBig,
                            fontWeight: FontWeight.bold,
                            color: primaryColor)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: botText.isEmpty
                                ? Colors.transparent
                                : const Color(0xffe9e9e9),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(botText.isEmpty ? "" : userText,
                            textAlign: TextAlign.justify,
                            style: const TextStyle(
                                fontSize: fontBig,
                                wordSpacing: 10,
                                height: 1.5,
                                fontWeight: FontWeight.bold)),
                      ),
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
                        child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: botText.isEmpty
                              ? (userText.isEmpty
                                  ? Colors.transparent
                                  : const Color(0xffe9e9e9))
                              : const Color(0xffe9e9e9),
                          borderRadius: BorderRadius.circular(20)),
                      // child: Text(botText.isEmpty ? userText : botText,
                      child: Text(botText.isEmpty ? userText : animatedBotText,
                          style: const TextStyle(
                              fontSize: fontBig,
                              wordSpacing: 10,
                              height: 1.5,
                              fontWeight: FontWeight.bold)),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void showSnackBar(BuildContext context, String message, int duration) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text(
  //       message,
  //       style: const TextStyle(color: Colors.white),
  //     ),
  //     behavior: SnackBarBehavior.floating,
  //     // padding: EdgeInsets.all(20),
  //     margin: const EdgeInsets.fromLTRB(600, 20, 20, 20),
  //     duration: Duration(seconds: duration),
  //     backgroundColor: Colors.lightBlue,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     action: SnackBarAction(
  //       label: 'Ok',
  //       textColor: Colors.white,
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //     ),
  //   ));
  // }

  @override
  void dispose() {
    timer.cancel();
    socket.dispose();
    super.dispose();
  }
}
