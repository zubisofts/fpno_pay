import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fpno_pay/src/blocs/app/app_bloc.dart';
import 'package:fpno_pay/src/blocs/auth/auth_bloc.dart';
import 'package:fpno_pay/src/blocs/data/data_bloc.dart';
import 'package:fpno_pay/src/model/fpn_user.dart';
import 'package:fpno_pay/src/pages/student/acceptance_fees_page.dart';
import 'package:fpno_pay/src/pages/student/dahsboard/dashboard.dart';
import 'package:fpno_pay/src/pages/student/microsoft_fee_page.dart';
import 'package:fpno_pay/src/pages/student/profile/profile_page.dart';
import 'package:fpno_pay/src/pages/student/school_fees_page.dart';
import 'package:fpno_pay/src/pages/student/tedc_feePage.dart';

final ValueNotifier<String> pageNotifier = ValueNotifier('Dashboard');
var selectedIndex = 0;
final Map<String, Widget> pages = {
  "Dashboard": StudentDashbaord(),
  "Acceptance Fees": AcceptanceFeePage(),
  "School Fees": SchoolFeePage(),
  "TEDC Fees": TEDCFeePage(),
  "Microsoft Fees": MicrosoftFeePage(),
};
final ValueNotifier<FPNUser?> userNotifier = ValueNotifier(null);

class StudentHomePage extends StatefulWidget {
  final String userId;

  const StudentHomePage({Key? key, required this.userId}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  FPNUser? user;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // SystemChrome.setSystemUIOverlayStyle(
    //     Theme.of(context).appBarTheme.systemOverlayStyle!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(Theme.of(context)
        .appBarTheme
        .systemOverlayStyle!
        .copyWith(statusBarColor: Colors.transparent));
    context.read<DataBloc>().add(FetchUserDetailsEvent(widget.userId));

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: ValueListenableBuilder<FPNUser?>(
          valueListenable: userNotifier,
          builder: (context, user, child) {
            return Drawer(
              child: Container(
                color: Colors.white,
                child: DrawerWidget(
                  user: user!,
                ),
              ),
            );
            // if (user != null) {
            //   return DrawerWidget(
            //     user: user,
            //   );
            // } else {
            //   return Container(
            //     color: Colors.white,
            //   );
            // }
          }),
      body: BlocConsumer<DataBloc, DataState>(
        buildWhen: (previous, current) => current is UserDetailsFetchedState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is UserDetailsFetchedState) {
            userNotifier.value = state.user;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 34.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // AnimatedIcon(
                    //   icon: AnimatedIcons.menu_close,
                    //   progress: null,),
                    IconButton(
                      onPressed: () {
                        _scaffoldKey.currentState!.openDrawer();
                        // print('Open');
                      },
                      icon: Icon(Icons.menu,
                          color: Theme.of(context).iconTheme.color),
                    ),
                    ValueListenableBuilder<String>(
                        valueListenable: pageNotifier,
                        builder: (context, value, child) {
                          return Text('$value',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  fontWeight: FontWeight.bold));
                        }),
                    Row(
                      children: [
                        // GFIconBadge(
                        //   child: GFIconButton(
                        //     onPressed: () {},
                        //     icon: Icon(Icons.notifications,
                        //         color: Theme.of(context).iconTheme.color),
                        //     type: GFButtonType.transparent,
                        //   ),
                        //   counterChild: GFBadge(
                        //     child: Text("2"),
                        //   ),
                        // ),
                        PopupMenuButton(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: InkWell(
                              // onTap: () {
                              //   context.read<AuthBloc>().add(LogoutEvent());
                              // },
                              borderRadius: BorderRadius.circular(50),
                              // child: SizedBox.shrink(),
                              child: CircleAvatar(
                                radius: 16.0,
                                backgroundImage: CachedNetworkImageProvider(
                                  state.user.photo,
                                ),
                              ),
                            ),
                          ),
                          // initialValue: 0,
                          onSelected: (value) {
                            if (value == 0) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProfilePage(user: state.user),
                              ));
                            } else {
                              context.read<AuthBloc>().add(LogoutUserEvent());
                            }
                          },
                          itemBuilder: (context) => [
                            // PopupMenuItem(
                            //   value: 0,
                            //   textStyle: TextStyle(
                            //       color: Theme.of(context).colorScheme.onPrimary),
                            //   child: Text(
                            //     'Settngs',
                            //   ),
                            // ),
                            PopupMenuItem(
                              value: 0,
                              textStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              child: Text('Profile'),
                            ),
                            PopupMenuItem(
                              value: 1,
                              textStyle: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                              child: Text('Logout'),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: pageNotifier,
                    builder: (context, value, child) => pages[value]!,
                  ),
                )
              ],
            );
          }
          return Center(
            child: SpinKitDualRing(
                size: 32.0,
                lineWidth: 2,
                color: Theme.of(context).colorScheme.secondary),
          );
        },
      ),
    );
  }
}

class DrawerWidget extends StatefulWidget {
  final FPNUser user;

  const DrawerWidget({Key? key, required this.user}) : super(key: key);

  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    // context.read<AuthBloc>().add(GetCurrentUserEvent());
    // print('Drawer');
    return Container(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(user: userNotifier.value!),
                          ));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.fromBorderSide(
                                BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 2.0,
                                ),
                              ),
                              shape: BoxShape.circle),
                          child: CircleAvatar(
                            radius: 32.0,
                            // backgroundColor: Colors.black,
                            backgroundImage:
                                CachedNetworkImageProvider(widget.user.photo),
                          ),
                        ),
                      ),
                      // Text('Good ${AppUtils.greet},',
                      //     style: TextStyle(
                      //         color: Theme.of(context).colorScheme.secondary,
                      //         fontSize: 20.0,
                      //         fontWeight: FontWeight.bold)),
                      // SizedBox(height: 8.0,),
                      Text('${widget.user.firstName} ${widget.user.lastName}',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                      Text('Student',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.5),
                              fontSize: 16.0,
                              fontWeight: FontWeight.w100)),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: selectedIndex == 0
                        ? Theme.of(context).colorScheme.secondary.withAlpha(40)
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50.0)),
                    // borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(50.0),
                    //     bottomRight: Radius.circular(50.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.dashboard_outlined,
                      color: selectedIndex == 0
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(
                      'Dashboard',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedIndex == 0
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    // selected: true,
                    // tileColor:
                    //     Theme.of(context).colorScheme.secondary.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0))),
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                        pageNotifier.value = pages.keys.toList()[selectedIndex];
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: selectedIndex == 1
                        ? Theme.of(context).colorScheme.secondary.withAlpha(40)
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50.0)),
                    // borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(50.0),
                    //     bottomRight: Radius.circular(50.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.event_seat_outlined,
                      color: selectedIndex == 1
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(
                      'Acceptance Fees',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedIndex == 1
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    // selected: true,
                    // tileColor:
                    //     Theme.of(context).colorScheme.secondary.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0))),
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                        pageNotifier.value = pages.keys.toList()[selectedIndex];
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: selectedIndex == 2
                        ? Theme.of(context).colorScheme.secondary.withAlpha(40)
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50.0)),
                    // borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(50.0),
                    //     bottomRight: Radius.circular(50.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.school_outlined,
                      color: selectedIndex == 2
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(
                      'School Fees',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedIndex == 2
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    // selected: true,
                    // tileColor:
                    //     Theme.of(context).colorScheme.secondary.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0))),
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                        pageNotifier.value = pages.keys.toList()[selectedIndex];
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: selectedIndex == 3
                        ? Theme.of(context).colorScheme.secondary.withAlpha(40)
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50.0)),
                    // borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(50.0),
                    //     bottomRight: Radius.circular(50.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.wysiwyg_outlined,
                      color: selectedIndex == 3
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(
                      'TEDC Fees',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedIndex == 3
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    // selected: true,
                    // tileColor:
                    //     Theme.of(context).colorScheme.secondary.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0))),
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                        pageNotifier.value = pages.keys.toList()[selectedIndex];
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: selectedIndex == 4
                        ? Theme.of(context).colorScheme.secondary.withAlpha(40)
                        : Colors.transparent,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50.0)),
                    // borderRadius: BorderRadius.only(
                    //     topRight: Radius.circular(50.0),
                    //     bottomRight: Radius.circular(50.0)),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.account_tree_outlined,
                      color: selectedIndex == 4
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(
                      'Microsoft Fees',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: selectedIndex == 4
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    // selected: true,
                    // tileColor:
                    //     Theme.of(context).colorScheme.secondary.withAlpha(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0))),
                    onTap: () {
                      setState(() {
                        selectedIndex = 4;
                        pageNotifier.value = pages.keys.toList()[selectedIndex];
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 12.0,
                ),
                // Container(
                //   margin: const EdgeInsets.only(right: 16.0, bottom: 8.0),
                //   decoration: BoxDecoration(
                //     color: selectedIndex == 5
                //         ? Theme.of(context).colorScheme.secondary.withAlpha(40)
                //         : Colors.transparent,
                //     borderRadius: BorderRadius.only(
                //         topRight: Radius.circular(50),
                //         bottomRight: Radius.circular(50.0)),
                //     // borderRadius: BorderRadius.only(
                //     //     topRight: Radius.circular(50.0),
                //     //     bottomRight: Radius.circular(50.0)),
                //   ),
                //   child: ListTile(
                //     leading: Icon(
                //       Icons.logout,
                //       color: selectedIndex == 5
                //           ? Theme.of(context).colorScheme.secondary
                //           : Theme.of(context).colorScheme.onPrimary,
                //     ),
                //     title: Text(
                //       'Logout',
                //       style: TextStyle(
                //         fontWeight: FontWeight.bold,
                //         color: selectedIndex == 5
                //             ? Theme.of(context).colorScheme.secondary
                //             : Theme.of(context).colorScheme.onPrimary,
                //       ),
                //     ),
                //     // selected: true,
                //     // tileColor:
                //     //     Theme.of(context).colorScheme.secondary.withAlpha(50),
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.only(
                //             topRight: Radius.circular(50.0),
                //             bottomRight: Radius.circular(50.0))),
                //     onTap: () {
                //       setState(() {
                //         // Navigator.of(context).pop();
                //         // context.read<AuthBloc>().add(LogoutEvent());
                //         // _showLoadingDialog(context);
                //       });
                //     },
                //   ),
                // ),
              ],
            ),
          ),
          Divider(
            height: 0.1,
            color: Colors.blueGrey[350],
          ),
          Container(
              color: Theme.of(context).cardTheme.color,
              child: ListTile(
                title: Text('Dark Theme',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary)),
                trailing: BlocBuilder<AppBloc, AppState>(
                  buildWhen: (previous, current) =>
                      current is ThemeRetrievedState,
                  builder: (context, state) {
                    bool isDarkTheme = false;
                    if (state is ThemeRetrievedState) {
                      isDarkTheme = state.isDarkTheme;
                    }
                    return Switch.adaptive(
                      inactiveTrackColor: Colors.grey,
                      inactiveThumbColor: Colors.white,
                      onChanged: (bool value) {
                        // print('Theme switching:$value');
                        context
                            .read<AppBloc>()
                            .add(SwitchThemeEvent(isDarkTheme: value));
                      },
                      value: isDarkTheme,
                    );
                  },
                ),
                onTap: () {},
              ))
        ],
      ),
    );
  }
}
