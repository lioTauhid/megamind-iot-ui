import 'package:flutter/material.dart';
import 'package:megamind_iot_ui/api_client.dart';
import '../../../constant/color.dart';
import '../../../constant/value.dart';

Widget sideDrawer(BuildContext context) {
  return Drawer(
    backgroundColor: primaryBackground,
    child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserAccountsDrawerHeader(
          currentAccountPicture: Image.asset("assets/logo.png"),
          accountName: const Text(
            appName,
            style: TextStyle(color: Colors.white, fontSize: fontMedium),
          ),
          accountEmail: const Text(
            appVersion,
            style: TextStyle(color: Colors.white, fontSize: fontMedium),
          ),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/bg.jpg"), fit: BoxFit.fill)),
        ),
        // ListTile(
        //   title: const Text("Toggle Full-Screen",
        //       style: TextStyle(color: primaryText, fontSize: fontMedium)),
        //   onTap: () {},
        //   leading: const Icon(Icons.fullscreen_rounded),
        // ),
        ListTile(
          title: const Text("Shut down",
              style: TextStyle(color: primaryText, fontSize: fontMedium)),
          onTap: () {
            // call action api
            Map body = {"action": "shutdown -h now"};
            ApiClient().post("/action", (body)).then((value) {
              Navigator.of(context).pop();
            });
          },
          leading: const Icon(Icons.power_settings_new, color: red),
        ),
        ListTile(
          title: const Text("Restart Device",
              style: TextStyle(color: primaryText, fontSize: fontMedium)),
          onTap: () {
            // call action api
            Map body = {"action": "reboot"};
            ApiClient().post("/action", (body)).then((value) {
              Navigator.of(context).pop();
            });
          },
          leading: const Icon(Icons.refresh_rounded, color: red),
        ),
        ListTile(
          title: const Text("Settings",
              style: TextStyle(color: primaryText, fontSize: fontMedium)),
          onTap: () {},
          leading: const Icon(Icons.settings),
        ),
        const Divider(),
        ListTile(
          title: const Text(
            'About Us',
            style: TextStyle(color: primaryText, fontSize: fontMedium),
          ),
          leading: const Icon(Icons.info_outline_rounded),
          onLongPress: () {},
        ),
        ListTile(
          title: const Text('Support',
              style: TextStyle(color: primaryText, fontSize: fontMedium)),
          leading: const Icon(Icons.contact_support_outlined),
          onLongPress: () {},
        ),
        ListTile(
          title: const Text("Close",
              style: TextStyle(color: primaryText, fontSize: fontMedium)),
          onTap: () {
            Navigator.of(context).pop();
          },
          leading: const Icon(Icons.close),
        ),
      ],
    ),
  );
}
