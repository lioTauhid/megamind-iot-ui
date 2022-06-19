import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(const MaterialApp(
    home: HomePageWidget(),
  ));
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  IO.Socket socket = IO.io('http://0.0.0.0:8080/sock');
  late TabController tabController;
  late Timer timer;

  String botText = 'Say, Hi MegaMind to wakeup bot';
  int maskState = 2;
  int countDown = 60;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);

    socket.onConnect((_) {
      // print('connected');
      socket.emit('data_event',
          {'mask': '2', 'botText': 'Say, Hi MegaMind to wakeup bot'});
      showSnackBar(context,
          'Mask Detection is starting \nIt will take 50 second to start');
      // socket.emit('app_event', {'app': '0'});
    });

    // change data
    socket.on('data_response', (data) {
      // print(data);
      setState(() => maskState = int.parse(data['mask']));
      setState(() => botText = data['botText']);
    });

    // switching app
    socket.on('app_response', (data) {
      // print(data);
      maskState = 2;
      timer.cancel();
      int index = int.parse(data['app']);
      setState(() => tabController.index = index);
      if (index == 0) {
        countDown = 60;
        showSnackBar(context,
            'Mask Detection is starting \nIt will take 60 second to start');
        timer = Timer.periodic(
            const Duration(seconds: 1), (Timer t) => waitAndCount());
      } else if (index == 1) {
        countDown = 80;
        showSnackBar(context,
            'Gesture Detection is starting \nIt will take 80 second to start');
        timer = Timer.periodic(
            const Duration(seconds: 1), (Timer t) => waitAndCount());
      } else {
        countDown = 14;
        showSnackBar(context,
            'Robo Receptionist is starting \nIt will take 14 second to start');
        timer = Timer.periodic(
            const Duration(seconds: 1), (Timer t) => waitAndCount());
      }
    });

    timer =
        Timer.periodic(const Duration(seconds: 1), (Timer t) => waitAndCount());
  }

  void waitAndCount() {
    // await Future.delayed(const Duration(seconds: 1));
    if (countDown == 0) {
      timer.cancel();
      setState(() {});
      return;
    }
    setState(() => countDown--);
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
      behavior: SnackBarBehavior.floating,
      // padding: EdgeInsets.all(20),
      margin: const EdgeInsets.fromLTRB(600, 0, 20, 20),
      duration: const Duration(seconds: 8),
      backgroundColor: Colors.blue,
      action: SnackBarAction(
        label: 'Ok',
        textColor: Colors.white,
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    ));
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFEEEEEE),
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
                border: Border.all(
                  color: Colors.black,
                  width: 6,
                ),
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://sp-ao.shortpixel.ai/client/to_webp,q_glossy,ret_img,w_390/https://megamindtech.com/wp-content/uploads/2022/03/logo-1.png',
                      width: 180,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: DefaultTabController(
                          length: 3,
                          initialIndex: 0,
                          child: Column(
                            children: [
                              TabBar(
                                controller: tabController,
                                labelColor: Colors.indigo,
                                labelStyle: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                                indicatorColor: Colors.lightBlueAccent,
                                tabs: const [
                                  Tab(
                                    text: 'Mask Detection',
                                  ),
                                  Tab(
                                    text: 'Gesture Recognision',
                                  ),
                                  Tab(
                                    text: 'Robo Reciptionist',
                                  ),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: tabController,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              70, 20, 70, 10),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          // color: const Color(0xFFEEEEEE),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 6,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 0, 10),
                                          child: maskState == 2
                                              ? Text(
                                                  countDown == 0
                                                      ? "Detecting..."
                                                      : "$countDown",
                                                  style: const TextStyle(
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              : Image.asset(maskState == 1
                                                  ? "assets/with_mask.gif"
                                                  : "assets/no_mask.gif"),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              70, 20, 70, 10),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEEEEEE),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                            width: 6,
                                          ),
                                        ),
                                        child: Text(
                                          countDown == 0
                                              ? "Detecting..."
                                              : "$countDown",
                                          style: const TextStyle(
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              70, 20, 70, 10),
                                      child: Container(
                                          width: 100,
                                          height: 100,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEEEEEE),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                              width: 6,
                                            ),
                                          ),
                                          child: countDown == 0
                                              ? Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                0, 10, 0, 10),
                                                        child: Image.asset(
                                                            "assets/bot_listen.gif"),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              10, 0, 10, 10),
                                                      child: Text(
                                                        botText,
                                                        style: const TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Text(
                                                  "$countDown",
                                                  style: const TextStyle(
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
