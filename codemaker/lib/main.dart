
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'code_make_home_page.dart';
import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:collection/collection.dart';
import 'package:window_manager/window_manager.dart';
import 'common.dart';
import 'event_widget.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main(List<String> args) async {
  //修改状态栏的颜色
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor:Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

  if (args.firstOrNull == 'multi_window') {
    final windowId = int.parse(args[1]);
    final argument = args[2].isEmpty
        ? const {}
        : jsonDecode(args[2]) as Map<String, dynamic>;
    runApp(_ExampleSubWindow(
      windowController: WindowController.fromWindowId(windowId),
      args: argument,
    ));
  }else{
    WidgetsFlutterBinding.ensureInitialized();

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(800, 600),
      size: Size(1080, 720),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    runApp(const MyApp());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {

  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _init();
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowClose() async{
    bool isPreventClose = await windowManager.isPreventClose();

    BuildContext context = navigatorKey.currentState!.overlay!.context;
    if (isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
              contentPadding:const EdgeInsets.all(0),
            backgroundColor: Common.instance.systemModeColorChangeState(context,Colors.white, const Color.fromRGBO(68, 68, 68, 1)),
            title: const Text('Are you sure you want to close this window?\n确定关闭当前应用程序吗？',style: TextStyle(fontSize: 14,color: Colors.white),),
            actions: [
              const Spacer(),
              TextButton(
                child: const Text('取消（No）',style: TextStyle(color: Colors.white,fontSize: 12),),
                onPressed: () {
                  if (context.mounted){
                    Navigator.of(context).pop();
                  }
                },
              ),
              const Spacer(),
              TextButton(
                child: const Text('确定（Yes）',style: TextStyle(color: Colors.blueAccent,fontSize: 12),),
                onPressed: () async {
                  if (context.mounted){
                    Navigator.of(context).pop();
                  }
                  await windowManager.destroy();
                },
              ),
              const Spacer(),
            ],
          );
        },
      );
    }
  }


  @override
  void onWindowFocus() {
    // do something
  }

  @override
  void onWindowBlur() {
    // do something
  }

  @override
  void onWindowMaximize() {
    // do something
  }

  @override
  void onWindowUnmaximize() {
    // do something
  }

  @override
  void onWindowMinimize() {
    // do something
  }

  @override
  void onWindowRestore() {
    // do something
  }

  @override
  void onWindowResize() {
    // do something
  }

  @override
  void onWindowMove() {
    // do something
  }

  @override
  void onWindowEnterFullScreen() {
    // do something
  }

  @override
  void onWindowLeaveFullScreen() {
    // do something
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
      color: const Color.fromRGBO(40, 37, 36, 1),
      debugShowCheckedModeBanner:false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        // fontFamily: "Courier Prime",
        // fontFamily: "siYuan",
        // fontFamily: "SourceCodePro",
        appBarTheme: const AppBarTheme(color: Color.fromRGBO(40, 37, 36, 1), ),
        secondaryHeaderColor:const Color.fromRGBO(40, 37, 36, 1),
        primaryColor: const Color.fromRGBO(40, 37, 36, 1),
          primaryColorLight:const Color.fromRGBO(40, 37, 36, 1),
        primaryColorDark: const Color.fromRGBO(40, 37, 36, 1),
        scaffoldBackgroundColor: const Color.fromRGBO(40, 37, 36, 1),
        textTheme:  const TextTheme(
          // TextField输入文字颜色
          titleMedium: TextStyle(color: Colors.white,fontSize: 12),
          // 这里用于小文字样式
          titleSmall: TextStyle(color: Colors.black,fontSize: 12),
        ),
      ),
      home: const HomePage()
    );
  }
}

class _ExampleMainWindow extends StatefulWidget {
  const _ExampleMainWindow({Key? key}) : super(key: key);

  @override
  State<_ExampleMainWindow> createState() => _ExampleMainWindowState();
}

class _ExampleMainWindowState extends State<_ExampleMainWindow> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            TextButton(
              onPressed: () async {
                final window =
                await DesktopMultiWindow.createWindow(jsonEncode({
                  'args1': 'Sub window',
                  'args2': 100,
                  'args3': true,
                  'bussiness': 'bussiness_test',
                }));
                window
                  ..setFrame(const Offset(0, 0) & const Size(1280, 720))
                  ..center()
                  ..setTitle('Another window')
                  ..show();
              },
              child: const Text('Create a new World!'),
            ),
            TextButton(
              child: const Text('Send event to all sub windows'),
              onPressed: () async {
                final subWindowIds =
                await DesktopMultiWindow.getAllSubWindowIds();
                for (final windowId in subWindowIds) {
                  DesktopMultiWindow.invokeMethod(
                    windowId,
                    'broadcast',
                    'Broadcast from main window',
                  );
                }
              },
            ),
            Expanded(
              child: EventWidget(controller: WindowController.fromWindowId(0)),
            )
          ],
        ),
      ),
    );
  }
}
//第二个window
class _ExampleSubWindow extends StatelessWidget {
  const _ExampleSubWindow({
    Key? key,
    required this.windowController,
    required this.args,
  }) : super(key: key);

  final WindowController windowController;
  final Map? args;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner:false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryColor: const Color.fromRGBO(40, 37, 36, 1),
          textTheme: const TextTheme(
            // TextField输入文字颜色
            titleMedium: TextStyle(color: Colors.white,fontSize: 12),
            // 这里用于小文字样式
            titleSmall: TextStyle(color: Colors.black,fontSize: 12),
          ),
        ),
      home: const HomePage()


      // Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Plugin example app'),
      //   ),
      //   body: Column(
      //     children: [
      //       if (args != null)
      //         Text(
      //           'Arguments: ${args.toString()}',
      //           style: const TextStyle(fontSize: 20),
      //         ),
      //       ValueListenableBuilder<bool>(
      //         valueListenable: DesktopLifecycle.instance.isActive,
      //         builder: (context, active, child) {
      //           if (active) {
      //             return const Text('Window Active');
      //           } else {
      //             return const Text('Window Inactive');
      //           }
      //         },
      //       ),
      //       TextButton(
      //         onPressed: () async {
      //           windowController.close();
      //         },
      //         child: const Text('Close this window'),
      //       ),
      //       Expanded(child: EventWidget(controller: windowController)),
      //     ],
      //   ),
      // ),
    );
  }
}