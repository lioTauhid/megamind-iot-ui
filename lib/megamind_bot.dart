import 'dart:html';

import 'package:flutter/material.dart';
import 'package:megamind_iot_ui/constant/color.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';
import 'constant/value.dart';
import 'drawer.dart';

class MegaMindBot extends StatefulWidget {
  const MegaMindBot({Key? key}) : super(key: key);

  @override
  State<MegaMindBot> createState() => _MegaMindBotState();
}

class _MegaMindBotState extends State<MegaMindBot> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  IO.Socket socket = IO.io(baseUrl + '/sock');
  late Timer timer;
  bool _isFullScreen = false;

  String userText = '';
  String botText = '';
  String animatedBotText = '';
  String backImage = 'assets/starting.gif';
  String status = 'Starting MegaMind: Customer Service Bot';

  int countDown = 4;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    socket.onConnect((_) {
      // print('connected');
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

    timer = Timer.periodic(const Duration(seconds: 1), (t) => waitAndCount());
  }

  Future<void> updateState() async {
    setState(() {
      if (userText.isEmpty) {
        backImage = "assets/wakeup.gif";
        status = 'Ready to help: Say "MegaMind” to start';
      } else {
        if (botText.isEmpty) {
          if (userText == "Hello! How can i assist you?") {
            backImage = "assets/after-wakeup.gif";
            status = 'Listening: New Conversation';
          } else {
            backImage = "assets/listening.gif";
            status = 'Listening: Continuing the Conversation';
          }
        } else {
          backImage = "assets/answering.gif";
          _typingAnimation();
          status = 'Responding: Continuing Conversation';
        }
      }
    });
  }

  void waitAndCount() {
    if (countDown == 0) {
      timer.cancel();
      backImage = 'assets/wakeup.gif';
      status = 'Ready to help: Say "MegaMind” to start';
      setState(() {});
      _typingAnimation();
      return;
    }
    setState(() => countDown--);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      endDrawer: sideDrawer(context),
      body: SizedBox(
        height: size.height,
        width: size.width,
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
                      decoration: botText.isEmpty
                          ? const BoxDecoration()
                          : BoxDecoration(
                              color: primaryBackground,
                              boxShadow: const [
                                BoxShadow(
                                  color: textSecondary,
                                  blurRadius: 4,
                                  offset: Offset(1, 1), // Shadow position
                                ),
                              ],
                              borderRadius: BorderRadius.circular(20)),
                      child: Text(botText.isEmpty ? "" : userText,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                              // fontSize: fontBig,
                              fontSize: 35,
                              wordSpacing: 10,
                              height: 1.5,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: size.width / 5.8,
              right: size.width / 3.5,
              top: size.height / 2.5,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: botText.isEmpty
                        ? (userText.isEmpty // remove duplicate condition later
                            ? const BoxDecoration()
                            : const BoxDecoration())
                        : BoxDecoration(
                            color: primaryBackground,
                            boxShadow: const [
                              BoxShadow(
                                color: textSecondary,
                                blurRadius: 4,
                                offset: Offset(1, 1), // Shadow position
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20)),
                    child: Text(botText.isEmpty ? userText : animatedBotText,
                        style: const TextStyle(
                            // fontSize: fontBig,
                            fontSize: 26,
                            wordSpacing: 10,
                            height: 1.5,
                            fontWeight: FontWeight.bold)),
                  )),
                ],
              ),
            ),
            Positioned(
                right: 0,
                top: size.height / 4,
                child: Container(
                  height: 100,
                  width: 25,
                  margin: EdgeInsets.zero,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30)),
                    color: primaryColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          scaffoldKey.currentState!.openEndDrawer();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: white,
                          size: 26,
                        ),
                        padding: const EdgeInsets.only(right: 0),
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (_isFullScreen) {
                            document.exitFullscreen();
                            _isFullScreen = false;
                          } else {
                            document.documentElement!.requestFullscreen();
                            _isFullScreen = true;
                          }
                        },
                        child: const Icon(
                          Icons.fullscreen_rounded,
                          color: white,
                          size: 27,
                        ),
                        padding: const EdgeInsets.all(0),
                      )
                    ],
                  ),
                )),
            Positioned(
                left: 8,
                top: 8,
                child: Text(status,
                    style: const TextStyle(
                        color: textSecondary,
                        fontSize: fontMediumExtra,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
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
  void dispose() {
    timer.cancel();
    socket.dispose();
    super.dispose();
  }
}
