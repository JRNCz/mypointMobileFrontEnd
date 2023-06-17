import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:http/http.dart';
import 'package:mypointfrontend/appData/provider/userdata.dart';
import 'package:provider/provider.dart';

import '../appData/provider/rendermap.dart';

class SideMenu extends StatelessWidget {
  const SideMenu(ClusterManager<ClusterItem> manager, List<Facility> args, {Key? key})
      : _manager = manager,
        _args = args,
        super(key: key);

  final ClusterManager<ClusterItem> _manager;
  final List<Facility> _args;

  @override
  Widget build(BuildContext context) {
    print('drawer');
    return Drawer(
      width: 150,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder<Response>(
              future: context.read<User>().checkLogIn(),
              builder: (BuildContext context, AsyncSnapshot<Response?> snapshot) {
                String username = 'Anonymous';
                if (snapshot != null) {
                  var responseCode = snapshot.data?.statusCode;
                  bool loggedIn = false;
                  if (responseCode == 200) {
                    loggedIn = true;
                    context.read<User>().ChangeLoginState(true);

                    var jsonData =
                        jsonDecode(utf8.decode(snapshot.data!.bodyBytes, allowMalformed: false));
                    return menuHeader(context, loggedIn, jsonData['username']);
                  } else {
                    loggedIn = false;
                    context.read<User>().ChangeLoginState(false);
                    return menuHeader(context, loggedIn, username);
                  }
                } else {
                  return menuHeader(context, context.read<User>().wasLoggedIn, username);
                }
              },
            ),
            menuUser(context, _manager, _args),
            menuFeedback(context, _manager, _args),
          ],
        ),
      ),
    );
  }
}

Widget menuHeader(BuildContext context, bool loggedIn, String username) {
  return Container(
    color: Colors.grey[600],
    padding: EdgeInsets.only(top: 25 + MediaQuery.of(context).padding.top, bottom: 25),
    child: Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 40,
          backgroundImage:
              loggedIn ? AssetImage('assets/chosen.png') : AssetImage('assets/anonymous.png'),
        ),
        SizedBox(height: 12),
        loggedIn
            ? Text(username, style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Oswald'))
            : Text('Anonymous',
                style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Oswald')),
      ],
    ),
  );
}

Widget menuUser(BuildContext context, ClusterManager<ClusterItem> manager, List<Facility> args) {
  return Container(
    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top - 5),
    child: Column(
      children: [
        ListTile(
          visualDensity: VisualDensity(vertical: -3, horizontal: -4),
          // to compact
          leading: const Icon(Icons.home_outlined),
          title: const Text('Home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          child: ListTile(
            visualDensity: VisualDensity(vertical: -3, horizontal: -4), // to compact
            leading: const Icon(Icons.account_box),
            title: const Text('Account'),
            onTap: () async {
              var token = await context.read<User>().getAcessToken();
              Response response = await get(
                  Uri.parse('http://${FlutterConfig.get('API_ADDRESS')}/api/client/account/'),
                  headers: {'Authorization': 'Bearer ' + token!});
              var jsonData = jsonDecode(response.body);
              if (response.statusCode == 200) {
                Navigator.pushNamed(context, '/account', arguments: jsonData);
              } else {
                Navigator.pushNamed(context, '/register');
              }
            },
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 400),
          child: ListTile(
            visualDensity: VisualDensity(vertical: -3, horizontal: -4),
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () async {
              final loggedIn =
                  context.read<User>().wasLoggedIn; // Use a default value if snapshot.data is null

              if (loggedIn) {
                Map m = await Navigator.pushNamed(context, '/shop') as Map;
                print(m['Itemname']);
                if (m['Itemname'] == 'error') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: Text('The QR Code is invalid \n'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Log In to do this operation\n'),
                      actions: [
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
          ),
        ),
        ListTile(
          visualDensity: VisualDensity(vertical: -3, horizontal: -4),
          leading: const Icon(Icons.settings),
          title: const Text('Settings'),
          onTap: () {
            Navigator.pushNamed(context, '/settings');
          },
        ),
        ListTile(
          visualDensity: VisualDensity(vertical: -3, horizontal: -4),
          leading: const Icon(Icons.info),
          title: const Text('About us'),
          onTap: () {
            Navigator.pushNamed(context, '/about');
          },
        ),
      ],
    ),
  );
}

Widget menuFeedback(BuildContext context, ClusterManager<ClusterItem> manager, List<Facility> args) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start, // add this line
    crossAxisAlignment: CrossAxisAlignment.start, // add this line
    children: [
      Divider(
        color: Colors.grey[300],
        thickness: 1,
      ),
      ListTile(
        visualDensity: VisualDensity(vertical: -3, horizontal: -4),
        leading: const Icon(Icons.local_parking),
        title: const Text('Car park'),
        onTap: () {
          if (manager.items.isNotEmpty) {
            List<Facility> newItems = [];
            manager.setItems(newItems);
            for (int i = 0; i < args.length; i++) {
              print(args[i].asset_type);
              if (args[i].asset_type == 'Car Park') {
                newItems.add(args[i]);
              }
            }

            manager.setItems(newItems);
            Navigator.pop(context);
          }
        },
      ),
      ListTile(
          visualDensity: VisualDensity(vertical: -3, horizontal: -4),
          leading: const Icon(Icons.support_agent),
          title: const Text('Mobility Station'),
          onTap: () {
            if (manager.items.isNotEmpty) {
              List<Facility> newItems = [];
              manager.setItems(newItems);
              for (int i = 0; i < args.length; i++) {
                print(args[i].asset_type);
                if (args[i].asset_type == 'Mobility Station') {
                  newItems.add(args[i]);
                }
              }

              manager.setItems(newItems);
              Navigator.pop(context);
            }
          }),
      ListTile(
        visualDensity: VisualDensity(vertical: -3, horizontal: -4),
        leading: const Icon(Icons.bus_alert),
        title: const Text('Bus stops'),
        onTap: () {
          if (manager.items.isNotEmpty) {
            List<Facility> newItems = [];
            manager.setItems(newItems);
            for (int i = 0; i < args.length; i++) {
              print(args[i].asset_type);
              if (args[i].asset_type == 'Bus stop') {
                newItems.add(args[i]);
              }
            }

            manager.setItems(newItems);
            Navigator.pop(context);
          }
        },
      ),
      ListTile(
        visualDensity: VisualDensity(vertical: -3, horizontal: -4),
        leading: const Icon(Icons.visibility),
        title: const Text('Show all'),
        onTap: () {
          List<Facility> newItems = [];
          manager.setItems(newItems);
          manager.setItems(args);
          Navigator.pop(context);
        },
      ),
    ],
  );
}
