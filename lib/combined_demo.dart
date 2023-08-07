// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'dart:async';
// import 'dart:html';
//
// class HomePageWidget extends StatefulWidget {
//   const HomePageWidget({Key? key}) : super(key: key);
//
//   @override
//   _HomePageWidgetState createState() => _HomePageWidgetState();
// }
//
// class _HomePageWidgetState extends State<HomePageWidget>
//     with TickerProviderStateMixin {
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   IO.Socket socket = IO.io('http://0.0.0.0:8080/sock');
//   late TabController tabController;
//   late Timer timer;
//
//   String userText = 'Say, Hi MegaMind to wakeup bot';
//   String botText = '';
//   String genderType = 'loading';
//   Map productMap = {};
//   int maskState = 2;
//
//   // int countDown = 60;
//   int countDown = 0;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     tabController = TabController(length: 4, vsync: this);
//
//     socket.onConnect((_) {
//       // print('connected');
//       // socket.emit('data_event', {
//       //   'mask': '2',
//       //   'botText': '',
//       //   'userText': 'Say, Hi MegaMind to wakeup bot',
//       //   'genderType': genderType,
//       // });
//       showSnackBar(context,
//           'ChatGPT Bot is starting \nIt will take 10 second to start', 10);
//       // socket.emit('app_event', {'app': '0'});
//     });
//
//     // update data
//     socket.on('data_response', (data) {
//       print(data);
//       // maskState = int.parse(data['mask']);
//       userText = data['userText'];
//       botText = data['botText'];
//       genderType = data['genderType'];
//       setState(() {});
//     });
//     // socket.on('product_response', (data) {
//     //   print(data);
//     //   productMap = data;
//     //   setState(() {});
//     // });
//
//     // // switching app
//     // socket.on('app_response', (data) {
//     //   // print(data);
//     //   maskState = 2;
//     //   timer.cancel();
//     //   int index = int.parse(data['app']);
//     //   setState(() => tabController.index = index);
//     //   if (index == 0) {
//     //     countDown = 60;
//     //     showSnackBar(context,
//     //         'Mask Detection is starting \nIt will take 60 second to start');
//     //     timer = Timer.periodic(
//     //         const Duration(seconds: 1), (Timer t) => waitAndCount());
//     //   } else if (index == 1) {
//     //     countDown = 80;
//     //     showSnackBar(context,
//     //         'Gesture Detection is starting \nIt will take 80 second to start');
//     //     timer = Timer.periodic(
//     //         const Duration(seconds: 1), (Timer t) => waitAndCount());
//     //   } else {
//     //     countDown = 14;
//     //     showSnackBar(context,
//     //         'Robo Receptionist is starting \nIt will take 14 second to start');
//     //     timer = Timer.periodic(
//     //         const Duration(seconds: 1), (Timer t) => waitAndCount());
//     //   }
//     // });
//
//     timer =
//         Timer.periodic(const Duration(seconds: 1), (Timer t) => waitAndCount());
//   }
//
//   void waitAndCount() {
//     // await Future.delayed(const Duration(seconds: 1));
//     if (countDown == 0) {
//       timer.cancel();
//       setState(() {});
//       return;
//     }
//     setState(() => countDown--);
//   }
//
//   void showSnackBar(BuildContext context, String message, int duration) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(
//         message,
//       ),
//       behavior: SnackBarBehavior.floating,
//       // padding: EdgeInsets.all(20),
//       margin: const EdgeInsets.fromLTRB(600, 0, 20, 20),
//       duration: Duration(seconds: duration),
//       backgroundColor: Colors.blue,
//       action: SnackBarAction(
//         label: 'Ok',
//         textColor: Colors.white,
//         onPressed: () {
//           // Some code to undo the change.
//         },
//       ),
//     ));
//   }
//
//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     document.documentElement!.requestFullscreen();
//
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           margin: const EdgeInsetsDirectional.all(10),
//           decoration: BoxDecoration(
//             color: const Color(0xFFEEEEEE),
//             borderRadius: BorderRadius.circular(10),
//             shape: BoxShape.rectangle,
//             border: Border.all(
//               color: Colors.black,
//               width: 6,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Image.network(
//                   'https://i0.wp.com/megamindtech.com/wp-content/uploads/2022/03/logo-1.png?fit=390%2C79&ssl=1',
//                   width: 180,
//                   height: 40,
//                   fit: BoxFit.contain,
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsetsDirectional.only(top: 8),
//                     child: DefaultTabController(
//                       length: 3,
//                       initialIndex: 0,
//                       child: Column(
//                         children: [
//                           TabBar(
//                             controller: tabController,
//                             labelColor: Colors.indigo,
//                             labelStyle: const TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 15,
//                                 fontWeight: FontWeight.bold),
//                             indicatorColor: Colors.lightBlueAccent,
//                             tabs: const [
//                               Tab(
//                                 text: 'AI Smart Sign',
//                               ),
//                               Tab(
//                                 text: 'ChatGPT Bot',
//                               ),
//                               Tab(
//                                 text: 'Mask Detection',
//                               ),
//                               Tab(
//                                 text: 'Robo Reciptionist',
//                               ),
//                             ],
//                           ),
//                           Expanded(
//                             child: TabBarView(
//                               controller: tabController,
//                               children: [
//                                 Container(
//                                     width: 100,
//                                     height: 100,
//                                     margin:
//                                         const EdgeInsetsDirectional.fromSTEB(
//                                             20, 20, 20, 10),
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFEEEEEE),
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(
//                                         width: 6,
//                                       ),
//                                     ),
//                                     child: countDown == 0
//                                         ? Column(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 flex: 10,
//                                                 child: ClipRRect(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                   child: Image.asset(
//                                                     "assets/$genderType.gif",
//                                                     height:
//                                                         Size.infinite.height,
//                                                     // width:
//                                                     //     Size.infinite.width,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 ),
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(5.0),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.end,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     const Icon(
//                                                         Icons.camera_alt),
//                                                     Text(
//                                                       genderType,
//                                                       style: const TextStyle(
//                                                           fontSize: 22,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         : Text(
//                                             "$countDown",
//                                             style: const TextStyle(
//                                                 fontSize: 40,
//                                                 fontWeight: FontWeight.bold),
//                                           )),
//                                 Container(
//                                     width: 100,
//                                     height: 100,
//                                     margin:
//                                         const EdgeInsetsDirectional.fromSTEB(
//                                             20, 20, 20, 10),
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFEEEEEE),
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(
//                                         width: 6,
//                                       ),
//                                     ),
//                                     child: countDown == 0
//                                         ? Column(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               if (botText.isEmpty)
//                                                 Expanded(
//                                                   flex: 10,
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.only(
//                                                             top: 20,
//                                                             bottom: 10),
//                                                     child: ClipRRect(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       child: Image.asset(
//                                                         "assets/bot_listen.gif",
//                                                         height: Size
//                                                             .infinite.height,
//                                                         // width:
//                                                         //     Size.infinite.width,
//                                                         fit: BoxFit.cover,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               Expanded(
//                                                 flex: 3,
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsetsDirectional
//                                                               .fromSTEB(
//                                                           10, 20, 10, 0),
//                                                   child: Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .center,
//                                                     crossAxisAlignment:
//                                                         CrossAxisAlignment
//                                                             .start,
//                                                     children: [
//                                                       const Icon(Icons.mic),
//                                                       Text(
//                                                         userText,
//                                                         // textAlign: TextAlign.center,
//                                                         style: const TextStyle(
//                                                             fontSize: 22,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ),
//                                               if (botText.isNotEmpty)
//                                                 Expanded(
//                                                   flex: 6,
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsetsDirectional
//                                                                 .fromSTEB(
//                                                             10, 20, 10, 0),
//                                                     child: Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         const Icon(Icons.chat),
//                                                         Expanded(
//                                                           child: Text(
//                                                             botText,
//                                                             // textAlign: TextAlign.center,
//                                                             style: const TextStyle(
//                                                                 fontSize: 22,
//                                                                 fontWeight:
//                                                                     FontWeight
//                                                                         .bold),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                             ],
//                                           )
//                                         : Text(
//                                             "$countDown",
//                                             style: const TextStyle(
//                                                 fontSize: 40,
//                                                 fontWeight: FontWeight.bold),
//                                           )),
//                                 Padding(
//                                   padding: const EdgeInsetsDirectional.fromSTEB(
//                                       70, 20, 70, 10),
//                                   child: Container(
//                                     width: 100,
//                                     height: 100,
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       // color: const Color(0xFFEEEEEE),
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(
//                                         width: 6,
//                                       ),
//                                     ),
//                                     child: Padding(
//                                       padding:
//                                           const EdgeInsetsDirectional.fromSTEB(
//                                               0, 10, 0, 10),
//                                       child: maskState == 2
//                                           ? Text(
//                                               countDown == 0
//                                                   ? "Detecting..."
//                                                   : "$countDown",
//                                               style: const TextStyle(
//                                                   fontSize: 40,
//                                                   fontWeight: FontWeight.bold),
//                                             )
//                                           : Image.asset(maskState == 1
//                                               ? "assets/with_mask.gif"
//                                               : "assets/no_mask.gif"),
//                                     ),
//                                   ),
//                                 ),
//                                 Container(
//                                     width: 100,
//                                     height: 100,
//                                     margin:
//                                         const EdgeInsetsDirectional.fromSTEB(
//                                             70, 20, 70, 10),
//                                     alignment: Alignment.center,
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFEEEEEE),
//                                       borderRadius: BorderRadius.circular(10),
//                                       border: Border.all(
//                                         width: 6,
//                                       ),
//                                     ),
//                                     child: countDown == 0
//                                         ? Column(
//                                             mainAxisSize: MainAxisSize.max,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.center,
//                                             children: [
//                                               Expanded(
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsetsDirectional
//                                                               .fromSTEB(
//                                                           0, 10, 0, 10),
//                                                   child: Image.asset(
//                                                       "assets/bot_listen.gif"),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 1,
//                                                 child: Padding(
//                                                   padding:
//                                                       const EdgeInsetsDirectional
//                                                               .fromSTEB(
//                                                           10, 20, 10, 0),
//                                                   child: Text(
//                                                     botText,
//                                                     textAlign: TextAlign.center,
//                                                     style: const TextStyle(
//                                                         fontSize: 20,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                 flex: 5,
//                                                 child: ListView.builder(
//                                                   scrollDirection:
//                                                       Axis.horizontal,
//                                                   shrinkWrap: true,
//                                                   itemCount: productMap.length,
//                                                   itemBuilder:
//                                                       (BuildContext context,
//                                                           int index) {
//                                                     return Container(
//                                                       width: 200,
//                                                       height:
//                                                           Size.infinite.height,
//                                                       margin:
//                                                           const EdgeInsets.all(
//                                                               10),
//                                                       padding:
//                                                           const EdgeInsets.all(
//                                                               10),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius:
//                                                             BorderRadius
//                                                                 .circular(8),
//                                                         color: Colors.white,
//                                                       ),
//                                                       child: Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .end,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .center,
//                                                         children: [
//                                                           Image.network(
//                                                             productMap.values
//                                                                 .elementAt(
//                                                                     index)
//                                                                 .toString()
//                                                                 .split('|')[0],
//                                                             height: 200,
//                                                           ),
//                                                           Text(
//                                                               "\$${productMap.values.elementAt(index).toString().split('|')[1]}",
//                                                               style: const TextStyle(
//                                                                   fontSize: 15,
//                                                                   color: Colors
//                                                                       .green)),
//                                                           Text(
//                                                               productMap.keys
//                                                                   .elementAt(
//                                                                       index)
//                                                                   .toString(),
//                                                               style:
//                                                                   const TextStyle(
//                                                                       fontSize:
//                                                                           14)),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                               ),
//                                             ],
//                                           )
//                                         : Text(
//                                             "$countDown",
//                                             style: const TextStyle(
//                                                 fontSize: 40,
//                                                 fontWeight: FontWeight.bold),
//                                           )),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
