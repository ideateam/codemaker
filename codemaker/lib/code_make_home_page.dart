import 'dart:io';
import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui;
import 'package:codemaker/diy_file_expansiontitle_view.dart';
import 'package:codemaker/user_default_manager.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/xml.dart';
import 'package:kumi_popup_window/kumi_popup_window.dart';
import 'package:path/path.dart' as p;
import 'LocalFileManager.dart';
import 'common.dart';

import 'package:flutter_code_editor/flutter_code_editor.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

extension DarkMode on BuildContext {
  /// is dark mode currently enabled?
  bool get isDarkMode {
    final brightness = MediaQuery.of(this).platformBrightness;
    return brightness == Brightness.dark;
  }
}

class _HomePageState extends State<HomePage> {
  double titleBarHeight = 30;
  double defaultTopNavHeight = 40;
  double default_left_width = 180;
  double default_right_width = 180;
  double widthLeft = 180;
  double _lastWidthLeft = 180;
  static double left_frist_width = 30;
  static double separate_line_width = 80;

  //手指移动的位置
  double _lastMoveY = 0.0;
  String _pathToSave = "";
  double _fileLeftEdgDistance = 15;
  //error信息展示区域
  double _error_area_lastMoveY = 0.0;
  //拖动停止时的高度
  double _error_area_last_height = 0.0;
  double _error_area_height = 0;
  double _error_area_header_height = 0;
  bool _error_area_header_is_open_fold_bool = false;

  List<Widget> allFilesAndFolderWidgetArr = [];
  List<FileSystemEntity> currentFiles = [];
  List<Widget> fileListArr = [];

  late OverlayEntry overlayEntry;

  bool _current_file_or_folder_is_click_bool = false;
  String _current_choose_path_file_string = "";
  String _current_choose_code_file_string = "";

  //用户自动滚动到可视区域
  GlobalKey? dataKey = GlobalKey();

  // 需要滚动的条目的id或者其他标记
  String select = "";

  //不是代码文件
  bool isNotCodeFileBool = false;
  //点击了文件名 展示文件名列表
  //{"path":"","file_name":""}
  List clickFileNameList = [];
  //错误日志数组
  //{"path":"","time":"","error":""};
  List<Map> errorStringList = [];
  //文件不能够打开的数组记录
  //{"path"}
  List<String> fileOpenErrorList = [];
  //文件是否需要存储的状态
  final _fileSaveManager = FileSaveManager("", "", "", false, false);
  //移除开屏广告
  bool removeOpenScreenBool = false;
  //安全锁
  bool homeScreenIsLockBool = false;
  //安全锁有密码
  bool homeScreenHasPasswordBool = false;

  String currentSelectFileStyleTitle = Common.instance.allcreateFileSuffixTypeTitle[0];
  String currentSelectFileSavePath = "";
  String currentSelectFileName = "";
  int codeStrLength = 0;
  String currentSelectSettingTitle = Common.instance.settingTitleList[0];

  //主题背景颜色变化状态
  String colorState = "";
  //背景是否透明 用户选择图片背景
  bool transparentBGBool = false;
  //图片的默认高斯模糊值，用户可以自己调节
  double imageFilterValue = 10;

  //新建文件的错误提示
  String _createFileAddressChooseToSaveErrorText = "";

  List<String> historyList = [];

  TextEditingController fileNameTextController = TextEditingController(text: "test");

  final scrollController =  ScrollController(initialScrollOffset: 0.0,keepScrollOffset: true);
  final codeController = CodeController(language: xml,analyzer: DartPadAnalyzer(),);
  final demoCodeController = CodeController(language: xml,analyzer: DartPadAnalyzer());
  LocalFileStorageManager localFileStorageManager = LocalFileStorageManager();
  //计时器 计算用闲时操作 类如自动保存代码
  late Timer _timer;

  TextEditingController selectCreateFileNameTextController = TextEditingController();
  TextEditingController selectCreateDirNameTextController = TextEditingController();
  TextEditingController selectCreateFileSuffixNameTextController = TextEditingController();
  TextEditingController demoCreateContentFileTextController = TextEditingController();

  Widget _normalPopMenu(String title) {
    return Theme(
      data: Theme.of(context).copyWith(
        // cardColor: const Color.fromRGBO(68, 68, 68, 1),
          cardColor:Common.instance.systemModeColorChangeState(context,Colors.white,const Color.fromRGBO(68, 68, 68, 1))

      ),
      child: popupMenuItemArrayTitleWithString(title),
    );
  }

  PopupMenuButton popupMenuItemArrayTitleWithString(String title) {
    if (title == "新建") {
      return PopupMenuButton<String>(
        tooltip: title,
        padding: const EdgeInsets.all(20),
        onCanceled: () {},
        onSelected: (String value) {
          // setState(() {  });
        },
        offset: const Offset(0, 30),
        // offset: const Offset(0, 30)
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          const PopupMenuItem<String>(
            value: 'value02',
            height: 30,
            child: Text('新建.html文件'),
          ),
        ],
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    } else if (title == "配置") {
      return PopupMenuButton<String>(
        tooltip: title,
        onCanceled: () {},
        onSelected: (String value) {
          // setState(() {  });
        },
        offset: const Offset(0, 30),
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          const PopupMenuItem<String>(
              value: 'value01',
              height: 30,
              child: Text(
                '主题背景',
              )),
          const PopupMenuItem<String>(
            value: 'value02',
            height: 30,
            child: Text('文字颜色'),
          ),
          const PopupMenuItem<String>(
              value: 'value03', height: 30, child: Text('界面样式')),
          const PopupMenuItem<String>(
              value: 'value03', height: 30, child: Text('更多')),
          const PopupMenuItem<String>(
              value: 'value04', height: 30, child: Text('其他'))
        ],
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    } else if (title == "打开") {
      return PopupMenuButton<String>(
        color: Common.instance.systemModeColorChangeState(context,Colors.white, transparentBGBool ? const Color.fromRGBO(255, 255, 255,0.4) : const Color.fromRGBO(54, 54, 54,1)),
        tooltip: "",
        onCanceled: () {},
        onSelected: (String value) {
          // setState(() {  });
          if(value == 'value01'){
            //打开项目
            openProjectFilesAction("");
          }else if(value == 'value02'){
            //打开文件
            openSingleFileAction();
          }
        },
        offset: const Offset(0, 30),
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
           PopupMenuItem<String>(
              value: 'value01',
              height: 30,
              child: Text(
                '打开项目',style: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white),),)),
           PopupMenuItem<String>(
            value: 'value02',
            height: 30,
            child: Text('打开文件',style: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white),),),
          ),
          PopupMenuItem<String>(
            value: 'value03',
            height: 30,
            child: PopupMenuButton(
                tooltip: "",
                offset: const Offset(100, 0),
                onSelected: (String value) {
                  //打开项目
                  openProjectFilesAction(value);
              },
                child: const Row(
                  children: [
                    Padding(padding: EdgeInsets.only(right: 3),child: Icon(Icons.history,size: 16,color: Colors.grey,),),
                    Text("近期打开",style: TextStyle(color: Colors.grey,fontSize: 12),)
                ],),
                onCanceled: () {},
                itemBuilder: (BuildContext context) => historyList.map((e){
                  return  PopupMenuItem<String>(
                    value: e,
                    height: 30,
                    child: Text(e,style: const TextStyle(color: Colors.white60),),
                  );
                }).toList(),
            ),
          ),
        ],
        child: Row(
          children: [
            const Padding(padding: EdgeInsets.only(right: 3),child: Icon(Icons.folder_open,size: 18,color: Colors.blueAccent),),
            Text(
              title,
              style: TextStyle(color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white), fontSize: 12),
            )
          ],
        ),
      );
    } else {
      return PopupMenuButton<String>(
        tooltip: title,
        onCanceled: () {},
        onSelected: (String value) {
          // setState(() {  });
        },
        offset: const Offset(0, 30),
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          const PopupMenuItem<String>(
              value: 'value01',
              height: 30,
              child: Text(
                '未知',
                style: TextStyle(color: Colors.grey),
              )),
        ],
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      );
    }
  }

  Future<void> _onPointerDown(PointerDownEvent event) async {
    // Check if right mouse button clicked

    selectCreateDirNameTextController.text = "";
    selectCreateFileNameTextController.text = "";
    selectCreateFileSuffixNameTextController.text = "";

    String dir =  FileSystemEntity.isFileSync(_current_choose_path_file_string) ? File(_current_choose_path_file_string).parent.path : _current_choose_path_file_string;

    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          color: Common.instance.systemModeColorChangeState(context,Colors.white, const Color.fromRGBO(68, 68, 68, 1)),
          // shadowColor: Colors.white30,
          context: context,
          items: [
              PopupMenuItem(
              value: 2,
              height: 20,
              child: Text('重命名',style: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white)),),
            ),
             PopupMenuItem(
              value: 1,
              height: 20,
              child: Text('删除',style: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white)),),
            ),
            PopupMenuItem(
              value: 3,
              height: 20,
              child: PopupMenuButton(
                tooltip: "",
                padding: const EdgeInsets.all(0),
                position:PopupMenuPosition.over,
                offset: const Offset(100, 0),
                color: Common.instance.systemModeColorChangeState(context,Colors.white, const Color.fromRGBO(68, 68, 68, 1)),
                itemBuilder: (BuildContext context2){
                  return [
                     PopupMenuItem(
                      value: 31,
                      height: 60,
                       padding: const EdgeInsets.all(0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        color: Common.instance.systemModeColorChangeState(context,Colors.white, const Color.fromRGBO(68, 68, 68, 1)),
                        child: Column(
                          children: [
                             Row(
                              children: [
                                const Icon(Icons.file_copy_outlined,size: 13,color: Colors.blueAccent,),
                                Text(' 新建文件夹：',style: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.blueAccent),fontSize: 12)),
                                const Spacer(),
                              ],
                            ),
                            const Divider(color: Colors.white,height: 20,thickness: 0.2,),
                            Text("当前路径:$dir",style: TextStyle(fontSize: 8,color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white)),textAlign: TextAlign.left,),
                            const Divider(color: Colors.white,height: 20,thickness: 0.2,),
                            Container(
                              height: 30,
                              margin: const EdgeInsets.only(left: 0,right: 0),
                              color: Common.instance.systemModeColorChangeState(context,Colors.white, const Color.fromRGBO(68, 68, 68, 1)),
                              child:  TextField(
                                controller: selectCreateDirNameTextController,
                                decoration: InputDecoration(
                                    hintText: "请输入文件夹名称",
                                  hintStyle: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white),fontSize: 12)
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                if(!(selectCreateDirNameTextController.text.contains("."))){

                                  if(selectCreateDirNameTextController.text.isNotEmpty){

                                    createNewPathAndFileAction(dir, selectCreateDirNameTextController.text, "", "",true);
                                  }else{
                                    errorStringList.add({"path":_current_choose_path_file_string.toString(),"time":DateTime.now().toString().substring(0,19),"error":"新建文件夹失败：文件夹名称不能为空"});
                                    setState(() {});
                                  }
                                  Navigator.of(context).pop();
                                }
                              },
                              child: Container(
                                height: 20,
                                width: 100,
                                // color: Colors.red,
                                padding: const EdgeInsets.only(top: 5),
                                alignment: Alignment.center,
                                child: Text("确定",style: TextStyle(fontSize: 12,color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.blueAccent)),
                                ),
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                onSelected: (value){
                  Navigator.of(context).pop();
                },
                child: Text('新建文件夹',style: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white,)),),
              ),
            ),
            PopupMenuItem(
              value: 4,
              height: 20,
              child: PopupMenuButton(
                tooltip: "",
                padding: const EdgeInsets.all(0),
                position:PopupMenuPosition.over,
                offset: const Offset(100, 0),
                color: Common.instance.systemModeColorChangeState(context,Colors.white, const Color.fromRGBO(68, 68, 68, 1)),
                itemBuilder: (BuildContext context2){
                  return [
                    PopupMenuItem(
                      value: 31,
                      height: 60,
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        padding: const EdgeInsets.only(left: 10,right: 10),
                        color: Common.instance.systemModeColorChangeState(context,Colors.white, const Color.fromRGBO(68, 68, 68, 1)),
                        child: Column(
                          children: [
                             Row(
                              children: [
                                const Icon(Icons.file_copy_outlined,size: 13,color: Colors.blueAccent,),
                                Text(' 新建文件：',style: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.blueAccent),fontSize: 12),),
                                const Spacer()
                              ],
                            ),
                            const Divider(color: Colors.white,height: 20,thickness: 0.2,),
                            Text("当前路径:$dir",style: TextStyle(fontSize: 8,color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white)),textAlign: TextAlign.left,),
                            const Divider(color: Colors.white,height: 20,thickness: 0.2,),
                            Row(
                              children: [
                                Expanded(
                                    child: Container(
                                      height: 30,
                                      margin: const EdgeInsets.only(left: 0,right: 0),
                                      color: Common.instance.systemModeColorChangeState(context,Colors.white, const Color.fromRGBO(68, 68, 68, 1)),
                                      child:  TextField(
                                        controller: selectCreateFileNameTextController,
                                        decoration: InputDecoration(
                                            hintText: "请输入文件名",
                                            suffixText: ".",
                                            hintStyle: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white),fontSize: 12)
                                        ),
                                      ),
                                    ),
                                ),
                                Container(
                                  width: 20,
                                  height: 30,
                                  alignment: Alignment.bottomCenter,
                                  child: const Text(" . ",textAlign: TextAlign.center,),
                                ),
                                Container(
                                  height: 30,
                                  width: 80,
                                  margin: const EdgeInsets.only(left: 0,right: 0),
                                  child:  TextField(
                                    controller: selectCreateFileSuffixNameTextController,
                                    decoration:  InputDecoration(
                                        hintText: "文件后缀",
                                        hintStyle: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white),fontSize: 12)
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                                onTap: (){
                                  if(!(selectCreateFileNameTextController.text.contains(".")) && !(selectCreateFileSuffixNameTextController.text.contains("."))){
                                    if(selectCreateFileNameTextController.text.isNotEmpty && selectCreateFileSuffixNameTextController.text.isNotEmpty){

                                      createNewPathAndFileAction(dir, selectCreateFileNameTextController.text, ".${selectCreateFileSuffixNameTextController.text}", "//create time  ${DateTime.now().toString().substring(0,19)}",true);
                                    }else{
                                      errorStringList.add({"path":_current_choose_path_file_string.toString(),"time":DateTime.now().toString().substring(0,19),"error":"新建文件失败：文件名不能为空"});
                                      setState(() {});
                                    }
                                  }else{
                                    errorStringList.add({"path":_current_choose_path_file_string.toString(),"time":DateTime.now().toString().substring(0,19),"error":"新建文件失败：请使用标准的文件名,不要使用'.'作为名称"});
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                 height: 20,
                                 width: 100,
                              // color: Colors.red,
                                 padding: const EdgeInsets.only(top: 5),
                                 alignment: Alignment.center,
                                 child: const Text("确定",style: TextStyle(fontSize: 12,color: Colors.blueAccent),
                              ),
                            )
                            )
                          ],
                        ),
                      ),
                    ),
                  ];
                },
                onSelected: (value){
                  Navigator.of(context).pop();
                },
                child: Text('新建文件',style: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white))),
              ),
            ),
            // const PopupMenuItem(
            //   value: 5,
            //   height: 20,
            //   child: Text('解除项目关联'),
            // ),
          ],
          position: RelativeRect.fromSize(
              event.position & const Size(48.0, 48.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
            deleteFile(Directory(_current_choose_path_file_string));
          break;
        case 2:
          renameFile(Directory(_current_choose_path_file_string));
          break;
        case 3:
          //新建文件夹

          break;
        case 4:
          //新建文件

          break;
        // case 5:
        //   snackAlertFromBottomAction('解除关联成功  (不会删掉文件，只是在当前列表中不可见）');
        //   break;
        default:
      }
    }
  }

  void snackAlertFromBottomAction(String content) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          // width: 400,
          //  margin: EdgeInsets.only(right: 20,bottom: 50),
           showCloseIcon: true,
           closeIconColor: Colors.white,
           content: Text(content,style: const TextStyle(fontSize: 12),textAlign: TextAlign.left,),
           behavior: SnackBarBehavior.fixed
        )
    );
  }

  OverlayEntry createSelectPopupWindow(
      Size size, double width, double height, BuildContext winContext) {
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        width: size.width,
        height: size.height,
        child: Material(
          elevation: 1,
          shadowColor: Colors.white,
          color: Colors.transparent,
          borderOnForeground: false,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Color.fromRGBO(68, 68, 68, 0),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 205,
                    color: Colors.black,
                  ),
                ],
              )),
        ),
      );
    });
    return overlayEntry;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Store.getInstance().then((store){
      Future<dynamic> lockPasswordObj = store.getLockPasswordString(StorePassword.lockPassword);

      lockPasswordObj.then((value){
        print("-=-=-=initState-=-==-=-=$value");
        if(value != null){
          homeScreenHasPasswordBool = true;
        }else{
          homeScreenHasPasswordBool = false;
        }
        setState(() {});
      });
    });

    //视图全部加载完成后的的动作
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // do what you want here
      print("WidgetsBinding.instance.addPostFrameCallback");

      //加载默认文件夹
      normalStateUserShowWidget();

      historyDataLoadView();

      codeController.autocompleter.setCustomWords(Common.instance.isCodeLanguageType(".txt").codeKeywordsArr);
      _timer = Timer(const Duration(seconds: 5), () {
        print("-=-----000=-=time is come-=-=-=-=-=-=-");
        removeOpenScreenBool = true;
        setState(() {});
      });
    });

    Store.getInstance().then((value){
      value.removelock(StorePassword.lockPassword);
    });

    //监听系统颜色变化
    ui.PlatformDispatcher.instance.onPlatformBrightnessChanged = () {
      // 设置跟随系统主题变化
      if(ui.PlatformDispatcher.instance.platformBrightness == Brightness.dark) {
        // 系统已经转变为夜间模式
        // app跟随修改主题为夜间
        print("-------------1111111--------------");
      } else {
        // 系统已经转变为白天模式
        // app跟随修改主题为白天
        print("-------------2222222--------------");
      }

      setState(() {});
    };
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    print("-=-=-=-=dispose-=-=-=-");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    getScrollAnimateWidth(double dragValue) {
      if (widthLeft >
          width -
              left_frist_width -
              separate_line_width -
              default_right_width) {
        widthLeft = width -
            left_frist_width -
            separate_line_width -
            default_right_width;
      } else if (widthLeft >= default_left_width &&
          widthLeft <=
              width -
                  left_frist_width -
                  separate_line_width -
                  default_right_width) {
        widthLeft = _lastWidthLeft + dragValue;
        if (widthLeft >
            width -
                left_frist_width -
                separate_line_width -
                default_right_width) {
          widthLeft = width -
              left_frist_width -
              separate_line_width -
              default_right_width;
        }
        if (widthLeft < default_left_width) {
          widthLeft = default_left_width;
        }
      } else {
        widthLeft = default_left_width;
      }

      setState(() {});
    }

    return Scaffold(
      // backgroundColor: Color.fromRGBO(40, 37, 36, 1),
      backgroundColor: Common.instance.systemModeColorChangeState(context,Colors.white70,const Color.fromRGBO(40, 37, 36, 1)),
      // appBar: AppBar(
      //   title: Text("code maker"),
      // ),
      resizeToAvoidBottomInset: true,
      // bottomNavigationBar: Container(
      //     height: 30,
      //     // color: const Color.fromRGBO(40, 37, 36, 1),
      //     color: Common.instance.systemModeColorChangeState(context,Colors.white70,const Color.fromRGBO(40, 37, 36, 1)),
      //     child: Column(
      //       children: [
      //         Container(
      //           height: 0.5,
      //           width: width,
      //           // color: Colors.black,
      //           color: Common.instance.systemModeColorChangeState(context,Colors.black12,Colors.black),
      //         ),
      //         Container(
      //           height: 30 - 0.5,
      //           width: width,
      //           // color: Colors.red,
      //           padding: const EdgeInsets.only(left: 50),
      //           alignment: Alignment.centerLeft,
      //           child: (homeScreenIsLockBool || !removeOpenScreenBool)  ? Container(width: 0,height: 0,color: Colors.transparent,) : Row(
      //             children: [
      //               //999
      //               Text( _current_choose_path_file_string.isEmpty ? "" : "当前(current)： ",style: TextStyle(color:Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white),fontSize: 9),),
      //               Text( _current_choose_path_file_string.isEmpty ? "CopyRight ©feibaichen      ${DateTime.now().toString().substring(0,19)}" : "$_current_choose_path_file_string         文件大小：${Common.instance.getFileSize(File(_current_choose_path_file_string).statSync().size)}     　字符长度： $codeStrLength 字符",style:TextStyle(color: Common.instance.systemModeColorChangeState(context,Colors.black54,Colors.white60),fontSize: 9)),
      //             ],
      //           ),
      //         ),
      //       ],
      //     )),
      body: Stack(
        children: [
          !transparentBGBool ? Container() :
          Stack(
            children: [
              SizedBox(
                width: width,
                height: height,
                child: Image.asset("images/bg_type_test.jpg",width: width,height: height,fit: BoxFit.cover,colorBlendMode: BlendMode.srcOver,),
              ),
              BackdropFilter(
                /// 过滤器
                filter: ImageFilter.blur(sigmaX: imageFilterValue, sigmaY: imageFilterValue),
                /// 必须设置一个空容器
                child: Container(),
              ),
            ],
          ),
        SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                Container(
                  width: width,
                  alignment: Alignment.center,
                  height: titleBarHeight - 0.5,
                  color:Common.instance.systemModeColorChangeState(context,Colors.white70,Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.05 : 1)),
                  child: Row(
                      children: [
                        const Spacer(),
                        Image.asset("images/1024x1024icon3.png",width: 14,height: 14,),
                        const Text("  ",style: TextStyle(fontSize: 11)),
                        Text("Code Maker - 新一代编辑器",style: TextStyle(fontSize: 11,color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),),
                        const Spacer(),
                      ],
                  )
                ),
                Container(
                  height: 0.5,
                  width: width,
                  // color: Colors.black,
                  color: Common.instance.systemModeColorChangeState(context,Colors.black12,Colors.black),
                ),
                Container(
                  height: defaultTopNavHeight - 0.5,
                  width: width,
                  padding: const EdgeInsets.all(0),
                  // color: const Color.fromRGBO(40, 37, 36, 1),
                  color:Common.instance.systemModeColorChangeState(context,Colors.white70,Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.05 : 1)),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Container(
                            // color: Colors.red,
                            width: 50,
                            alignment: Alignment.center,
                            child: Row(
                              children: [
                                GestureDetector(
                                    onTap: (){
                                      showDialog(
                                          barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                              backgroundColor:Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(255, 255, 255, 1),const Color.fromRGBO(40, 37, 36, 1)),
                                              children: [
                                                Common.instance.buildOpenScreenContainer("0",500, 300,context, callBackListener: null),
                                              ],
                                            );
                                          });

                                    },
                                    child: Container(
                                      // color: Colors.red,
                                      margin:
                                      const EdgeInsets.only(left: 15, right: 10),
                                      width: 25,
                                      height: 25,
                                      child: Image.asset("images/1024x1024icon3.png"),//color: Colors.white70 color: Color.fromRGBO(255, 255, 255, 1)
                                    ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                            width: 70,
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                //保存文件
                                if(!fileOpenErrorList.contains(_fileSaveManager.path.toString())){
                                  if(_fileSaveManager.needSaveBool){
                                    writeIntoFile(_fileSaveManager.path,_fileSaveManager.fileNewContent);
                                  }
                                  _fileSaveManager.fileBecomeDefault();
                                }else{
                                  //文件无法保存
                                }
                                setState(() {});
                              },
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    // color: Colors.red,
                                    margin:
                                    const EdgeInsets.only(left: 1,bottom: 2, right: 5),
                                    width: 14,
                                    height: 14,
                                    alignment: Alignment.center,
                                    // child: Image.asset("images/savedisk.png"),
                                    child: const Icon(Icons.save,size: 17,color: Colors.blueAccent),
                                  ),
                                   Text(
                                    "保存",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 12, color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.red,
                              width: 72,
                              alignment: Alignment.center,
                              child: TextButton(
                                onPressed: () {
                                  showCreateFilePopupWindow(context);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      // color: Colors.red,
                                      margin: const EdgeInsets.only(left: 1, bottom: 4,right: 7),
                                      width: 14,
                                      height: 14,
                                      // child: Image.asset("images/txt.png"),
                                      child: const Icon(Icons.create_new_folder,size: 18,color: Colors.blueAccent,),
                                    ),
                                    Text("新建",style: TextStyle(fontSize: 12,color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),),
                                  ],
                                ),
                              )
                          ),
                          Container(
                            // color: Colors.red,
                            width: 55,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 5),
                            child: _normalPopMenu("打开"),
                          ),
                          Container(
                            // color: Colors.red,
                            width: 85,
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                homeScreenIsLockBool = true;
                                setState(() {});
                              },
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    // color: Colors.red,
                                    margin:
                                    const EdgeInsets.only(left: 1, right: 4),
                                    width: 16,
                                    height: 16,
                                    child: const Icon(Icons.lightbulb,color: Colors.green,size: 17,),
                                  ),
                                  Text(
                                    "安全锁",
                                    style: TextStyle(
                                        fontSize: 12, color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      Row(
                        children: [
                          const Spacer(),
                          // Container(
                          //     width: 95,
                          //     color: const Color.fromRGBO(40, 37, 36, 1),
                          //     alignment: Alignment.center,
                          //     child: TextButton(
                          //       onPressed: (){
                          //
                          //       },
                          //       child: const Row(
                          //         children: [
                          //           Padding(padding: EdgeInsets.only(left: 1,right: 4),child: Icon(Icons.feed,size: 18,),),
                          //           Text("意见反馈",style: TextStyle(color: Colors.white,fontSize: 12),),
                          //         ],
                          //       ),
                          //     )
                          // ),
                          // Container(
                          //   width: 95,
                          //   alignment: Alignment.center,
                          //   color: const Color.fromRGBO(40, 37, 36, 1),
                          //   child: TextButton(
                          //     child: const Row(
                          //       children: [
                          //         Padding(padding: EdgeInsets.only(right: 4),child: Icon(Icons.window_rounded,size: 18),),
                          //         Text("新建窗口",style: TextStyle(fontSize: 12,color: Colors.white))
                          //       ],
                          //     ),
                          //     onPressed: () async {
                          //       final window =
                          //       await DesktopMultiWindow.createWindow(
                          //           jsonEncode({
                          //             'args1': 'Sub window',
                          //             'args2': 100,
                          //             'args3': true,
                          //             'bussiness': 'bussiness_test',
                          //           }));
                          //       window
                          //         ..setFrame(
                          //             const Offset(0, 0) & const Size(1280, 720))
                          //         ..center()
                          //         ..setTitle('Another window')
                          //         ..show();
                          //     },
                          //   ),
                          // ),
                          // Container(
                          //   width: 65,
                          //   alignment: Alignment.center,
                          //   margin: const EdgeInsets.only(right: 10),
                          //   color: const Color.fromRGBO(40, 37, 36, 1),
                          //   child: TextButton(
                          //       onPressed: () {
                          //
                          //       },
                          //       child: const Row(
                          //         children: [
                          //           Padding(padding: EdgeInsets.only(right: 4),child: Icon(Icons.color_lens_outlined,size: 18),),
                          //           Text("主题",style: TextStyle(fontSize: 12,color: Colors.white))
                          //         ],
                          //       )
                          //   ),
                          // ),
                          Container(
                            width: 72,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 20),
                            // color: const Color.fromRGBO(40, 37, 36, 1),
                            color: Common.instance.systemModeColorChangeState(context,Colors.transparent, Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.05 : 1)),
                            child: TextButton(
                                onPressed: () {
                                  showSettingPopupWindow(context);
                                },
                                child: Row(
                                  children: [
                                    const Padding(padding: EdgeInsets.only(right: 4),child: Icon(Icons.settings,size: 18,color: Colors.blueAccent),),
                                    Text("设置",style: TextStyle(fontSize: 12,color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)))
                                  ],)
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 0.5,
                  width: width,
                  color: Common.instance.systemModeColorChangeState(context,Colors.black12,Colors.black),
                ),
                Row(
                  children: [
                    Container(
                      width: left_frist_width - 0.5,
                      height: height - 40 - 30 - titleBarHeight,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        // color: Color.fromRGBO(40, 37, 36, 1),
                        color: Common.instance.systemModeColorChangeState(context,Colors.white70,Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.05 : 1)),
                        borderRadius: const BorderRadius.all(Radius.circular(0)),

                      ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Padding(padding: const EdgeInsets.only(top: 10),
                                child: RotatedBox(
                                  quarterTurns: 4,
                                  child: TextButton(
                                    onPressed: () {
                                      _current_choose_path_file_string = "";
                                      _current_choose_code_file_string = "";
                                      _current_file_or_folder_is_click_bool = false;

                                      currentSelectFileSavePath = "";
                                      currentSelectFileName = "";
                                      codeStrLength = 0;

                                      currentFiles = [];
                                      clickFileNameList = [];
                                      errorStringList = [];
                                      allFilesAndFolderWidgetArr = [];
                                      fileOpenErrorList = [];

                                      //输出日志区域
                                      _error_area_header_height = 0;

                                      setState(() {});

                                      //加载默认文件夹
                                      normalStateUserShowWidget();
                                      historyDataLoadView();
                                    },
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.delete,
                                          size: 11,
                                            color: Colors.blueAccent,
                                        ),
                                        Text(
                                          "清空工作区",
                                          // textDirection: TextDirection.ltr,
                                          style: TextStyle(fontSize: 9, color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(padding: const EdgeInsets.only(top: 10),
                              //   child: RotatedBox(
                              //     quarterTurns: 4,
                              //     child: TextButton(
                              //       onPressed: () {},
                              //       child: const Column(
                              //         children: [
                              //           Icon(
                              //             Icons.search_sharp,
                              //             size: 14,
                              //           ),
                              //           Text(
                              //               "搜索",
                              //               // textDirection: TextDirection.ltr,
                              //               style: TextStyle(
                              //                   fontSize: 10, color: Colors.white),
                              //               textAlign: TextAlign.center
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Padding(padding: const EdgeInsets.only(top: 10),
                                child: RotatedBox(
                                  quarterTurns: 4,
                                  child: TextButton(
                                    onPressed: () {
                                      //保存文件
                                      if(!fileOpenErrorList.contains(_fileSaveManager.path.toString())){
                                        if(_fileSaveManager.needSaveBool){
                                          writeIntoFile(_fileSaveManager.path,_fileSaveManager.fileNewContent);
                                        }
                                        _fileSaveManager.fileBecomeDefault();
                                      }else{
                                        //文件无法保存
                                      }
                                      setState(() {});
                                    },
                                    child: Column(
                                      children: [
                                        const Icon(
                                          Icons.save,
                                          size: 11,
                                          color: Colors.blueAccent,
                                        ),
                                        Text(
                                            "保存项目",
                                            // textDirection: TextDirection.ltr,
                                            style: TextStyle(fontSize: 9, color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),
                                            textAlign: TextAlign.center
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              // Padding(padding: const EdgeInsets.only(top: 10),
                              //   child: RotatedBox(
                              //     quarterTurns: 4,
                              //     child: TextButton(
                              //       onPressed: () {},
                              //       child: const Text("其他",
                              //           // textDirection: TextDirection.ltr,
                              //           style:
                              //           TextStyle(fontSize: 10, color: Colors.white),
                              //           textAlign: TextAlign.center
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              const Spacer(),
                            ],
                          ),
                          Column(
                            children: [
                              const Spacer(),
                              Container(
                                // color: const Color.fromRGBO(40, 37, 36, 1),
                                color: Common.instance.systemModeColorChangeState(context,Colors.transparent,Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.05 : 1)),
                                child: Column(
                                  children: [
                                    // Padding(
                                    //   padding: const EdgeInsets.only(bottom: 15),
                                    //   child: RotatedBox(
                                    //     quarterTurns: 4,
                                    //     child: TextButton(
                                    //         onPressed: () {},
                                    //         child: const Column(
                                    //           children: [
                                    //             Icon(Icons.help,size: 14,),
                                    //             Text("帮助",textAlign: TextAlign.center,
                                    //                 style:
                                    //                 TextStyle(fontSize: 10, color: Colors.white)
                                    //             ),
                                    //           ],
                                    //         )
                                    //     ),
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: RotatedBox(
                                        quarterTurns: 4,
                                        child: TextButton(
                                            onPressed: () {
                                              showSettingPopupWindow(context);
                                            },
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.settings,size: 12,color: Colors.blueAccent,),
                                                Text("设置",textAlign: TextAlign.center,
                                                    style:
                                                    TextStyle(fontSize: 10, color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white))
                                                ),
                                              ],
                                            )
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: height - 40 - 30 - titleBarHeight,
                      width: 0.5,
                      color: Common.instance.systemModeColorChangeState(context,Colors.black12,Colors.black),
                    ),
                    Stack(
                      children: [
                        RotatedBox(
                          quarterTurns: 3,
                          child: Container(
                            width: height - 40 - 30 - titleBarHeight,
                            height: widthLeft,
                            alignment: Alignment.center,
                            color:Common.instance.systemModeColorChangeState(context,Colors.white,Colors.transparent),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                // Container(
                                //   // color: Colors.red,
                                //   margin:
                                //   const EdgeInsets.only(left: 5, right: 5),
                                //   width: 90,
                                //   height: 90,
                                //   child: Image.asset("images/1024x1024iconrotate.png"),
                                // ),
                                Container(
                                  width: 10,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "CODE MAKER",
                                    style: TextStyle(fontSize: 100, color:Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(0, 0, 0, 0.05),const Color.fromRGBO(255, 255, 255, 0.05))),
                                    textAlign: TextAlign.center,overflow: TextOverflow.clip,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: height - 40 - 30 - titleBarHeight,
                          width: widthLeft,
                          color: Common.instance.systemModeColorChangeState(context,Colors.transparent,Colors.transparent),
                          child: currentFiles.isEmpty ?
                          ListView(
                            scrollDirection: Axis.vertical,
                            children: [
                              Container(
                                height: 50,
                                // color: Colors.white38,
                                margin: const EdgeInsets.all(5),
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () {  },
                                  child: Text("欢迎到来!  welcome !",style: TextStyle(fontSize: 12,color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),),
                                ),
                              ),
                              Container(
                                height: 30,
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  color:Common.instance.systemModeColorChangeState(context,Colors.blueAccent,const Color.fromRGBO(255, 255, 255, 0.2)),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    openProjectFilesAction("");
                                  },
                                  child: Text("打开项目",style: TextStyle(fontSize: 12,color: Common.instance.systemModeColorChangeState(context,Colors.white,Colors.white)),),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  color: Common.instance.systemModeColorChangeState(context,Colors.blueAccent,const Color.fromRGBO(255, 255, 255, 0.2)),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    openSingleFileAction();
                                  },
                                  child: Text("打开文件",style: TextStyle(fontSize: 12,color: Common.instance.systemModeColorChangeState(context,Colors.white,Colors.white))),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  color: Common.instance.systemModeColorChangeState(context,Colors.blueAccent,const Color.fromRGBO(255, 255, 255, 0.2)),
                                ),
                                child: TextButton(
                                  onPressed: () {
                                    showCreateFilePopupWindow(context);
                                  },
                                  child: Text("新建",style: TextStyle(fontSize: 12,color: Common.instance.systemModeColorChangeState(context,Colors.white,Colors.white))),
                                ),
                              ),
                              historyList.isNotEmpty ? Container(
                                width: widthLeft,
                                // color: Colors.red,
                                padding: const EdgeInsets.only(left: 5,right: 5),
                                margin: const EdgeInsets.only(left: 5,right: 5,top: 60,bottom: 5),
                                child: const Text("近期打开(History)：",style:TextStyle(fontSize: 11,color: Colors.grey)),
                              ) : const SizedBox(width: 0,height: 0,),
                              historyList.isNotEmpty ? Column(
                                children: historyList.map((e){
                                  File file = File(e.toString());
                                  return GestureDetector(
                                    onTap: (){

                                      openProjectFilesAction(e.toString());

                                      // Directory defaultDirectory = Directory(e);
                                      // List<FileSystemEntity> defaultEntity = [
                                      //   defaultDirectory
                                      // ];
                                      // currentFiles.addAll(defaultEntity);
                                      // setState(() {});
                                    },
                                    child: Container(
                                      width: widthLeft,
                                      color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(0, 0, 0, 0.1),const Color.fromRGBO(255, 255, 255, 0.1)),
                                      height: 35,
                                      padding: const EdgeInsets.only(top: 5,left: 5,right: 5),
                                      margin: const EdgeInsets.only(left: 5,right: 5,bottom: 5),
                                      alignment: Alignment.centerLeft,
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(file.path.substring(file.parent.path.length + 1),style: TextStyle(fontSize: 12,color: Common.instance.systemModeColorChangeState(context,Colors.black87,Colors.white70)),maxLines: 1,overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,),
                                                ),),
                                              Expanded(
                                                child: Container(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(e.toString(),style: TextStyle(fontSize: 8,color: Common.instance.systemModeColorChangeState(context,Colors.black26,Colors.white54)),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                                ),
                                              )
                                            ],
                                          ),
                                          Positioned(
                                              right: 0,
                                              height: 35,
                                              width: 25,
                                              child:Container(
                                                // color: Colors.red,
                                                alignment: Alignment.center,
                                                padding: const EdgeInsets.only(bottom: 10),
                                                child: IconButton(onPressed: (){
                                                  // 删除某个历史
                                                    Store.getInstance().then((store){
                                                      Future<dynamic> state = store.deleteHistoryPathItem(StoreKeys.historyKey, e.toString());
                                                      state.then((value){
                                                        setState(() {
                                                          historyDataLoadView();
                                                        });
                                                      });
                                                    });
                                                }, icon: Icon(Icons.clear,size: 12,color: Common.instance.systemModeColorChangeState(context,Colors.black87,Colors.white70),),),
                                              )
                                          )
                                        ],
                                      )
                                    ),
                                  );
                                }).toList(),
                              ) : const SizedBox(width: 0,height: 0,)
                            ],
                          )
                              : Scrollbar(
                              child: ListView(
                                // controller: scrollController,
                                primary: true,
                                physics: const BouncingScrollPhysics(
                                    parent: AlwaysScrollableScrollPhysics()),
                                children: _sortCurrentFiles(currentFiles).map((e) {
                                  if (FileSystemEntity.isFileSync(e.path)) {
                                    return _buildFileExpansionTitle(
                                        e, _fileLeftEdgDistance,false);
                                  } else if(FileSystemEntity.isDirectorySync(e.path)){
                                    return _buildFolderExpansionTitle(
                                        e, _fileLeftEdgDistance);
                                  }else{
                                    return _buildFileExpansionTitle(
                                        e, _fileLeftEdgDistance,false);
                                  }
                                }).toList(),
                              )),
                        ),
                        Listener(
                          behavior: HitTestBehavior.translucent,
                          onPointerDown: (event){
                            fileNeedSaveAlert(context,false);
                          },
                          child: GestureDetector(
                            onTap: (){
                              // fileNeedSaveAlert(context,false);
                            },
                            child: Container(
                              width: _fileSaveManager.needSaveBool ? widthLeft : 0 ,
                              height: _fileSaveManager.needSaveBool ? height - 40 - 30 - titleBarHeight : 0,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: separate_line_width,
                      color: Common.instance.systemModeColorChangeState(context,Colors.white70,Colors.black45),
                      child: Row(
                        children: <Widget>[
                          MouseRegion(
                            //可拽动区域
                            cursor: SystemMouseCursors.resizeColumn,
                            child: GestureDetector(
                              onPanEnd: (DragEndDetails drag) {
                                _lastWidthLeft = widthLeft;
                              },
                              onPanUpdate: (DragUpdateDetails drag) {
                                _lastMoveY = drag.localPosition.dx;
                                getScrollAnimateWidth(_lastMoveY);
                              },
                              // },
                              child: Container(
                                color: Common.instance.systemModeColorChangeState(context,Colors.transparent,Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.05 : 1)),
                                width: 5,
                                height: height - 40 - 30 - titleBarHeight,
                              ),
                            ),
                          ),
                          //编程语言展示
                          Container(
                            width: 50,
                            height: height - 40 - 30 - titleBarHeight,
                            color: Common.instance.systemModeColorChangeState(context,Colors.transparent,Color.fromRGBO(0, 0, 0, transparentBGBool ? 0.05 : 1)),
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: Common.instance.languageTitleList.map((title) {
                                return Column(
                                  children: [
                                    title.toString() != "C" ? Container() :
                                    SizedBox(
                                      width: width,
                                      height: 8,
                                      child: Icon(Icons.circle,color: Common.instance.systemModeColorChangeState(context,Colors.white70,Colors.black) == Colors.white70 ? Common.instance.getRandomColor(0.8) : Common.instance.getRandomColor(0.5),size: 5,),
                                    ),
                                    Tooltip(
                                      triggerMode: TooltipTriggerMode.manual,
                                      richMessage: WidgetSpan(
                                          child:  SizedBox(
                                            width: 300,
                                            // height: 400,
                                            child:  Common.instance.languageTitleWidgetList(title),
                                          )
                                      ),
                                      // preferBelow: true,
                                      margin: const EdgeInsets.only(left: 260),
                                      // message: title,
                                      child: Container(
                                        width: width,
                                        height: 30,
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.all(0),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(6),
                                          ),
                                          color: Common.instance.systemModeColorChangeState(context,Colors.white70,Colors.black) == Colors.white70 ? Common.instance.getRandomColor(0.8) : Common.instance.getRandomColor(0.5),
                                        ),
                                        child: Text(
                                          title,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: title.length <= 7 ? 10 : 7,
                                              color: Common.instance.systemModeColorChangeState(context,Colors.white,Colors.white60),
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.visible),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width,
                                      height: 10,
                                      child: Icon(Icons.circle,color: Common.instance.systemModeColorChangeState(context,Colors.white70,Colors.black) == Colors.white70 ? Common.instance.getRandomColor(0.8) : Common.instance.getRandomColor(0.5),size: 5,),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //判断是否是code文件 还是文件夹
                    isNotCodeFileBool
                        ? Container(
                      height: height - 40 - 30 - titleBarHeight,
                      width: width - 30 - separate_line_width - widthLeft,
                      padding: const EdgeInsets.all(100),
                      child: Image.file(
                        File(_current_choose_path_file_string),
                        fit: BoxFit.contain,
                      ),
                    )
                        : SizedBox(
                      height: height - 40 - 30 - titleBarHeight,
                      width: width - 30 - separate_line_width - widthLeft,
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            padding: const EdgeInsets.all(0),
                            color: Common.instance.systemModeColorChangeState(context,Colors.white,Colors.black45),
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: buildClickCodeFileList(width - 30 - separate_line_width - widthLeft,context),
                            ),
                          ),
                        Container(
                            height: height - 40 - 30 - titleBarHeight - 35 - _error_area_header_height - _error_area_height,
                            width:
                            width - 30 - separate_line_width - widthLeft,
                            padding: const EdgeInsets.only(
                                top: 0, right: 0, bottom: 0),
                            margin: const EdgeInsets.all(0),
                            color: Common.instance.systemModeColorChangeState(context,Colors.white,Colors.transparent),
                            child: CodeTheme(
                              data: CodeThemeData(styles: monokaiSublimeTheme),
                              child: SingleChildScrollView(
                                child: CodeField(
                                  background: Common.instance.systemModeColorChangeState(context,Colors.white,Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.01 : 1)),
                                  textStyle: TextStyle(wordSpacing: 2,letterSpacing: 0.5,color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),
                                  readOnly:(clickFileNameList.isEmpty ? true : false),
                                  onChanged: (content){
                                    //文本改变的回调
                                    if (kDebugMode) {
                                      print('-=-=--=-CodeField=-onChanged=-=-$content=-=-=-=-=-');
                                    }

                                    compareCodeContentAndChangeState(content);
                                  },
                                  padding: const EdgeInsets.only(
                                      top: 10, right: 10, bottom: 10),
                                  controller: codeController,
                                  gutterStyle: const GutterStyle(
                                      showErrors: true,
                                      showFoldingHandles: true,
                                      showLineNumbers: true),
                                ),
                              ),
                            ),

                          ),
                          //输出日志区域
                          MouseRegion(
                            //可拽动区域
                            cursor: SystemMouseCursors.resizeRow,
                            child: GestureDetector(
                              onPanEnd: (DragEndDetails drag) {
                                //存储上一次的高度数据
                                _error_area_last_height = _error_area_height;
                              },
                              onPanUpdate: (DragUpdateDetails drag) {

                                if (kDebugMode) {
                                  print("drag.localPosition.d = ${drag.localPosition.dy}");
                                }
                                _error_area_lastMoveY = 0;
                                _error_area_lastMoveY = drag.localPosition.dy;
                                if(drag.localPosition.dy < 0){
                                  _error_area_height = _error_area_last_height -_error_area_lastMoveY;
                                  if(_error_area_height >= height - 40 - 30 - 35 - _error_area_header_height - 50){
                                    _error_area_height = height - 40 - 30 - 35 - _error_area_header_height - 50;
                                  }
                                }else{
                                  _error_area_height = _error_area_last_height - _error_area_lastMoveY;
                                  if(_error_area_height <= 0){
                                    _error_area_height = 0;
                                    _error_area_header_is_open_fold_bool = false;
                                  }
                                }
                                setState(() {});
                              },
                              // },
                              child: Container(
                                color: Colors.white10,
                                margin: const EdgeInsets.all(0),
                                width: width - 30 - separate_line_width - widthLeft,
                                height: _error_area_header_height,
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 1,
                                      padding: const EdgeInsets.only(left: 0,right: 0,top: 0),
                                      color: Common.instance.systemModeColorChangeState(context,Colors.black12, Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.05 : 1)),
                                    ),
                                    //删除日志
                                    Positioned(
                                      child: SizedBox(
                                        width: _error_area_header_height,
                                        height: _error_area_header_height,
                                        child: TextButton(
                                          child: Icon(Icons.delete_forever_outlined,size: 14,color: _error_area_header_height == 0 ? Colors.transparent : Colors.white60,), onPressed: () {
                                          errorStringList = [];
                                          _error_area_height = 0;
                                          _error_area_header_height = 0;
                                          _error_area_last_height = _error_area_height;
                                          _error_area_header_is_open_fold_bool = false;

                                          setState(() {});
                                        },
                                        ),
                                      ),
                                    ),
                                    //折叠
                                    Positioned(
                                      right: 12,
                                      child: SizedBox(
                                        width: _error_area_header_height,
                                        height: _error_area_header_height,
                                        child: TextButton(
                                          child: const Icon(Icons.unfold_less_outlined,size: 12,color: Colors.white,), onPressed: () {
                                          _error_area_header_is_open_fold_bool = !_error_area_header_is_open_fold_bool;

                                          _error_area_height = 0;
                                          _error_area_header_height = 20;
                                          if(_error_area_header_is_open_fold_bool){
                                            _error_area_height = 50;
                                          }
                                          _error_area_last_height = _error_area_height;
                                          setState(() {});
                                        },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          //error信息展示区域
                          Container(
                            color: Colors.black26,
                            width: width - 30 - separate_line_width - widthLeft,
                            padding: const EdgeInsets.only(top: 5),
                            height: _error_area_height,
                            child: ListView(
                              children: errorStringList.map((e){
                                String time = e["time"];
                                String errorString = e["error"];
                                return SizedBox(
                                  // height: 18,
                                  // color: Colors.purple,
                                  child: RichText(
                                    text: TextSpan(
                                      text: "  $time",
                                      style: const TextStyle(color: Colors.white30,fontSize: 12,fontWeight: FontWeight.bold),
                                      children: [
                                        const TextSpan(text: "      " ),
                                        TextSpan(
                                          text: errorString ,
                                          style: const TextStyle(color: Colors.white70,fontSize: 12,fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                    height: 30,
                    width: width,
                    // color: const Color.fromRGBO(40, 37, 36, 1),
                    color: Common.instance.systemModeColorChangeState(context,Colors.white70, Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.05 : 1)),
                    child: Column(
                      children: [
                        Container(
                          height: 0.5,
                          width: width,
                          // color: Colors.black,
                          color: Common.instance.systemModeColorChangeState(context,Colors.black12,Colors.black),
                        ),
                        Container(
                          height: 30 - 0.5,
                          width: width,
                          // color: Colors.red,
                          padding: const EdgeInsets.only(left: 50),
                          alignment: Alignment.centerLeft,
                          child: (homeScreenIsLockBool || !removeOpenScreenBool)  ? Container(width: 0,height: 0,color: Colors.transparent,) : Row(
                            children: [
                              //999
                              Expanded(child: Text( _current_choose_path_file_string.isEmpty ? "CopyRight ©feibaichen      ${DateTime.now().toString().substring(0,19)}" : "当前(current)： $_current_choose_path_file_string         文件大小：${Common.instance.getFileSize(File(_current_choose_path_file_string).statSync().size)}     　字符长度： $codeStrLength 字符",style: TextStyle(overflow: TextOverflow.ellipsis,color: Common.instance.systemModeColorChangeState(context,Colors.black54,Colors.white60),fontSize: 9),),),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            ),
          ),
          removeOpenScreenBool ? ( homeScreenIsLockBool ? Common.instance.buildLockScreenContainer(homeScreenHasPasswordBool,width, height,context,callBackListener: MyCallBackListener(myCallBack: (type,val2,val3){

            if(type == "0"){
              Store.getInstance().then((store){
                Future<dynamic> lockPasswordObj = store.getLockPasswordString(StorePassword.lockPassword);

                lockPasswordObj.then((value){
                  if(val2 == value.toString()){
                    homeScreenIsLockBool = false;
                  }
                  setState(() {});
                });
              });
            }else if(type == "1"){
              Store.getInstance().then((store){
                var state = store.setLockPasswordString(StorePassword.lockPassword,val2);
                state.then((value){

                  if(value){
                    homeScreenHasPasswordBool = true;
                  }else{
                    homeScreenHasPasswordBool = false;
                  }
                  setState(() {});
                });
              });
            }else if(type == "3"){

              homeScreenIsLockBool = false;
              setState(() {});
            }
          })) : Container(width: 0,height: 0,color: Colors.transparent,)) :
          Common.instance.buildOpenScreenContainer("1",width, height,context,callBackListener: MyCallBackListener(myCallBack: (type,val2,val3){
            if(type == "1"){
              removeOpenScreenBool = true;
              _timer.cancel();
              setState(() {});
            }
          }))
        ],
      ),
    );
  }
  //点击某些模块时 判断是否需要保存文件
  bool compareCodeContentAndChangeState(String content) {

    bool needSaveBool = false;

    if(!fileOpenErrorList.contains(_fileSaveManager.path.toString())){
      _fileSaveManager.path = _current_choose_path_file_string;
      if(_fileSaveManager.fileDefaultContent.toString() != content.toString()){
        _fileSaveManager.needSaveBool = true;
        _fileSaveManager.fileNewContent = content;
        needSaveBool = true;
      }else{
        _fileSaveManager.needSaveBool = false;
        _fileSaveManager.fileNewContent = "";
        needSaveBool = false;
      }
      setState(() {});
    }
    return needSaveBool;
  }

  //新建文件 或者项目
  void showCreateFilePopupWindow(BuildContext context) {

    demoCodeController.text = Common.instance.isCodeLanguageType(currentSelectFileStyleTitle.toString()).codeDemo;
    demoCodeController.language = Common.instance.isCodeLanguageType(currentSelectFileStyleTitle.toString()).mode;

    _createFileAddressChooseToSaveErrorText = "";

    showPopupWindow(
      context,
      gravity: KumiPopupGravity.center,
      //curve: Curves.elasticOut,
      bgColor: Colors.grey.withOpacity( transparentBGBool ? 0.2 : 0.0),
      clickOutDismiss: false,
      clickBackDismiss: false,
      customAnimation: false,
      customPop: false,
      customPage: false,
      //targetRenderBox: (btnKey.currentContext.findRenderObject() as RenderBox),
      //needSafeDisplay: true,
      underStatusBar: false,
      underAppBar: true,
      offsetX: 0,
      offsetY: 0,
      duration: const Duration(milliseconds: 200),
      onShowStart: (pop) {
        print("showStart");
      },
      onShowFinish: (pop) {
        print("showFinish");
      },
      onDismissStart: (pop) {
        print("dismissStart");
      },
      onDismissFinish: (pop) {
        print("dismissFinish");
      },
      onClickOut: (pop) {
        print("onClickOut");
      },
      onClickBack: (pop) {
        print("onClickBack");
      },
      childFun: (pop) {
        return StatefulBuilder(
            key: GlobalKey(),
            builder: (popContext,popState){
            return BackdropFilter(
                filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5
            ),
              child: Container(
                  key: GlobalKey(),
                  decoration: BoxDecoration(
                    boxShadow:  [
                      BoxShadow(
                        color: Colors.black.withOpacity(transparentBGBool ? 0.01 : 0.5),		// 阴影的颜色
                        offset: const Offset(10, 20),						// 阴影与容器的距离
                        blurRadius: 45.0,							// 高斯的标准偏差与盒子的形状卷积。
                        spreadRadius: 0.0,							// 在应用模糊之前，框应该膨胀的量。
                      ),
                    ],
                    border: Border.all(
                        color: Colors.white, //边框线颜色
                      width: 0.1, // 边框线粗细
                        style: BorderStyle.solid,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                    color:Common.instance.systemModeColorChangeState(context,Colors.white,transparentBGBool ? const Color.fromRGBO(255, 255, 255, 0.3) : const Color.fromRGBO(68, 68, 68, 1)),
                  ),
                  padding: const EdgeInsets.only(
                      top: 10,
                      left: 15,
                      right: 15,
                      bottom: 5),
                  height: 500,
                  width: 700,
                  child: SizedBox(
                    child: Column(
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            height: 25,
                            // color: Colors.red,
                            child: Row(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.file_copy,color: Common.instance.systemModeColorChangeState(context, const Color.fromRGBO(68, 68, 68, 1),Colors.white),size: 20,),
                                    Text(
                                      " 新建文件",
                                      style: TextStyle(
                                          color: Common.instance.systemModeColorChangeState(context, const Color.fromRGBO(68, 68, 68, 1),Colors.white),
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  _createFileAddressChooseToSaveErrorText,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 10),
                                ),
                                const Spacer(),
                                Container(
                                  height: 25,
                                  alignment: Alignment.topCenter,
                                  child: TextButton(onPressed: (){
                                    pop.dismiss(context);
                                  }, child: Icon(Icons.clear,color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(40, 37, 36, 1),Colors.white),size: 18,)),
                                ),
                              ],
                            )
                        ),
                        Container(
                          height: 400,
                          width: 670,
                          // color: Colors.blue,
                          margin: const EdgeInsets.only(top: 10),
                          child: Row(
                            children: [
                              SingleChildScrollView(
                                child: Container(
                                  color: transparentBGBool ? const Color.fromRGBO(0, 0, 0, 0.3) :  Colors.transparent,
                                  width: 100,
                                  // height: 420,
                                  child: Column(
                                    children: Common.instance.allcreateFileSuffixTypeTitle.asMap().keys
                                        .map((index) {
                                      String title = Common.instance.allcreateFileSuffixTypeTitle[index];
                                      return TextButton(
                                          key: GlobalObjectKey(index + 500),
                                          style:  currentSelectFileStyleTitle == title.toString() ? ButtonStyle(shape:MaterialStateProperty.all(const ContinuousRectangleBorder(borderRadius: BorderRadius.zero)),backgroundColor:MaterialStateProperty.all(Common().getRandomColor(0.8))) : ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.transparent)) ,
                                          onPressed: () {
                                            currentSelectFileStyleTitle = title.toString();
                                            //默认的demo文本
                                            demoCodeController.text = Common.instance.isCodeLanguageType(title.toString()).codeDemo;
                                            demoCodeController.language = Common.instance.isCodeLanguageType(title.toString()).mode;

                                            popState(() {
                                              Future.delayed(const Duration(milliseconds: 100), () {
                                                if (kDebugMode) {
                                                  print("延时1秒执行");
                                                }
                                                //滚动到可视区域
                                                if (GlobalObjectKey(index + 500).currentContext != null) {
                                                  Scrollable.ensureVisible(GlobalObjectKey(index + 500).currentContext!);
                                                }
                                              });
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              // Spacer(),
                                              Icon(
                                                Icons
                                                    .file_open_outlined,
                                                size: 14,
                                                color: currentSelectFileStyleTitle == title.toString() ? Colors
                                                    .white : Common.instance.systemModeColorChangeState(context, const Color.fromRGBO(68, 68, 68, 1),Colors.white),
                                              ),
                                              const Spacer(),
                                              Text(
                                                title,
                                                style: TextStyle(
                                                    color: currentSelectFileStyleTitle == title.toString() ? Colors
                                                        .white : Common.instance.systemModeColorChangeState(context, const Color.fromRGBO(68, 68, 68, 1),Colors.white)),
                                              ),
                                              const Spacer(),
                                              Icon(Icons.check,size: 14,
                                                color: currentSelectFileStyleTitle == title.toString() ? Colors
                                                    .white : Colors.transparent,
                                              ),
                                              const Spacer(),
                                            ],
                                          ));
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 550,
                                height: 420,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                                  color: Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.5 : 1)
                                ),
                                // color: Common.instance.systemModeColorChangeState(context,Colors.black45,const Color.fromRGBO(40, 37, 36, 1)),
                                child: CodeTheme(
                                  data:
                                  CodeThemeData(styles: monokaiSublimeTheme),
                                  child: SingleChildScrollView(
                                    child: CodeField(
                                      background: Colors.transparent,
                                      onChanged: (content){
                                        //文本改变的回调
                                      },
                                      padding: const EdgeInsets.only(
                                          top: 10, right: 10, bottom: 10),
                                      controller: demoCodeController,
                                      gutterStyle: const GutterStyle(
                                          showErrors: false,
                                          showFoldingHandles: false,
                                          showLineNumbers: true),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            alignment: Alignment.center,
                            // width: 60,
                            height: 35,
                            // color: Colors.red,
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                Container(
                                    height: 30,
                                    width:98,
                                    color: Common.instance.systemModeColorChangeState(context,Colors.black26,const Color.fromRGBO(40, 37, 36, 1)),
                                    alignment: Alignment.center,
                                    child: TextButton(
                                      onPressed: (){

                                        _createFileAddressChooseToSaveErrorText = "";

                                        Future<dynamic> path = _getSavePath();
                                        path.then((value){
                                          currentSelectFileSavePath = value;
                                          popState(() {});
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset("images/folder.png",width: 20,height: 20,),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 5),child: Text("选择路径",textAlign: TextAlign.center,style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),),
                                          )
                                        ],
                                      ),
                                    )
                                ),
                                Container(
                                  height: 28,
                                  width: 350,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(left: 10),
                                  child: TextField(
                                    // style: const TextStyle(color: Colors.white),
                                    style: TextStyle(color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),
                                    controller: TextEditingController(text: currentSelectFileSavePath),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Common.instance.systemModeColorChangeState(context,Colors.black26,Colors.white), width: 0.5)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Common.instance.systemModeColorChangeState(context,Colors.black26,Colors.white), width: 0.5),
                                        // borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      hintText: '请点击选择文件地址',
                                      hintStyle: TextStyle(color:Common.instance.systemModeColorChangeState(context,Colors.black26,Colors.white70),),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Common.instance.systemModeColorChangeState(context,Colors.black26,Colors.white), width: 0.5),
                                        // borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      contentPadding: const EdgeInsets.all(6),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  width: 25,
                                  alignment: Alignment.center,
                                  child: TextField(
                                    enabled: false,
                                    controller: TextEditingController(text: "/"),
                                    style: TextStyle(color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent, width: 0.5)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent, width: 0.5),
                                        // borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent, width: 0.5),
                                        // borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  width: 70,
                                  alignment: Alignment.center,
                                  child: TextField(
                                    controller: fileNameTextController,
                                    style: TextStyle(color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),
                                    decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Common.instance.systemModeColorChangeState(context,Colors.black26,Colors.white), width: 0.5)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Common.instance.systemModeColorChangeState(context,Colors.black26,Colors.white), width: 0.5),
                                        // borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      hintText: '文件名',
                                      hintStyle: TextStyle(color: Common.instance.systemModeColorChangeState(context,Colors.black26,Colors.white70),fontSize: 10),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Common.instance.systemModeColorChangeState(context,Colors.black26,Colors.white), width: 0.5),
                                        // borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      contentPadding: const EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 28,
                                  width: 50,
                                  alignment: Alignment.center,
                                  child: TextField(
                                    enabled: false,
                                    style: TextStyle(fontSize: 14,color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white)),
                                    controller: TextEditingController(text: currentSelectFileStyleTitle),
                                    decoration: const InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.transparent, width: 0.5)),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent, width: 0.5),
                                        // borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent, width: 0.5),
                                        // borderRadius: BorderRadius.circular(2.0)
                                      ),
                                      contentPadding: EdgeInsets.all(5),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  height: 28,
                                  // width: 400,
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    style: ButtonStyle(shape: MaterialStateProperty.all(const ContinuousRectangleBorder()),backgroundColor: MaterialStateProperty.all(Colors.blueAccent)),
                                    onPressed: () {

                                      if(currentSelectFileSavePath.isNotEmpty){
                                        createNewPathAndFileAction(currentSelectFileSavePath,fileNameTextController.text,currentSelectFileStyleTitle, demoCodeController.text,false);
                                        pop.dismiss(context);
                                      }else{
                                        _createFileAddressChooseToSaveErrorText = "温馨提示: 未选择保存地址 Please choose where to to save";
                                        popState(() {});
                                      }

                                    },
                                    child: const Text(
                                      "确定",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                        ),
                      ],
                    ),
                  ))
            );
        });
      },
    );
  }

  //设置中心
  void showSettingPopupWindow(BuildContext context) {

    KumiPopupWindow window = showPopupWindow(
      context,
      gravity: KumiPopupGravity.center,
      //curve: Curves.elasticOut,
      bgColor: Colors.grey.withOpacity(0.0),
      clickOutDismiss: false,
      clickBackDismiss: false,
      customAnimation: false,
      customPop: false,
      customPage: false,
      //targetRenderBox: (btnKey.currentContext.findRenderObject() as RenderBox),
      //needSafeDisplay: true,
      underStatusBar: false,
      underAppBar: true,
      offsetX: 0,
      offsetY: 0,
      duration: const Duration(milliseconds: 200),
      onShowStart: (pop) {
        print("showStart");
      },
      onShowFinish: (pop) {
        print("showFinish");

        //修改上次设置的系统颜色记录
        Store.getInstance().then((store){
          Future<dynamic> themeColorStringObj =  store.getScreenThemeColorString(StoreKeys.themeColorKey);

          themeColorStringObj.then((value) {

            if (value == "1"){
              //暗黑色
              colorState = "1";
            }else if (value == "2"){
              //浅色
              colorState = "2";
            }else{
              //跟随系统
              colorState = "";
            }
            setState(() {

            });
          });
        });
      },
      onDismissStart: (pop) {
        print("dismissStart");
      },
      onDismissFinish: (pop) {
        print("dismissFinish");
      },
      onClickOut: (pop) {
        print("onClickOut");
      },
      onClickBack: (pop) {
        print("onClickBack");

      },
      childFun: (pop) {
        return StatefulBuilder(
            key: GlobalKey(),
            builder: (popContext,popState){
              return BackdropFilter(
                  filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5
                ),
                child: Container(
                    key: GlobalKey(),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(12)),
                        color: Common.instance.systemModeColorChangeState(context,Colors.white, transparentBGBool ? const Color.fromRGBO(255, 255, 255, 0.40) : const Color.fromRGBO(68, 68, 68,1)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(transparentBGBool ? 0.01 : 0.5),		// 阴影的颜色
                            offset: const Offset(10, 20),						// 阴影与容器的距离
                            blurRadius: 45.0,							// 高斯的标准偏差与盒子的形状卷积。
                            spreadRadius: 0.0,							// 在应用模糊之前，框应该膨胀的量。
                          ),
                        ],
                        border: Border.all(
                          color: Colors.white, //边框线颜色
                          width: 0.1, // 边框线粗细
                          style: BorderStyle.solid,
                        )
                    ),
                    padding: const EdgeInsets.only(
                        top: 10,
                        left: 15,
                        right: 15,
                        bottom: 5),
                    height: 500,
                    width: 700,
                    child: SizedBox(
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              height: 25,
                              // color: Colors.red,
                              child: Row(
                                children: [
                                  const Icon(Icons.settings,color: Colors.blueAccent,size: 22,),
                                  RichText(
                                    text: TextSpan(
                                      text: " 设置",
                                      style: TextStyle(color:Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1), Colors.white),fontSize: 18,fontWeight: FontWeight.bold),
                                      children: [
                                        TextSpan(
                                          text: "  (Setting)" ,
                                          style: TextStyle(color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1), Colors.white),fontSize: 10,fontWeight: FontWeight.normal),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  Container(
                                    height: 25,
                                    alignment: Alignment.topRight,
                                    child: TextButton(onPressed: (){
                                      pop.dismiss(context);
                                    }, child: Icon(Icons.clear,color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1), Colors.white),size: 18,)),
                                  ),
                                ],
                              )
                          ),
                          Container(
                            height: 400,
                            width: 670,
                            // color: Colors.blue,
                            alignment: Alignment.topCenter,
                            margin: const EdgeInsets.only(top: 10),
                            child: Row(
                              children: [
                                SizedBox(
                                  // color: const Color.fromRGBO(40, 37, 36, 1),
                                  width: 94,
                                  // height: 420,
                                  child: Column(
                                    children: Common.instance.settingTitleList.asMap().keys
                                        .map((index) {
                                      String title = Common.instance.settingTitleList[index];
                                      List iconList = const [Icons.interpreter_mode_rounded,Icons.color_lens_outlined,Icons.help,Icons.comment,Icons.other_houses];
                                      return TextButton(
                                          clipBehavior: Clip.antiAlias,
                                          key: GlobalObjectKey(index + 100),
                                          style:  currentSelectSettingTitle == title.toString() ? ButtonStyle(backgroundColor:MaterialStateProperty.all(Common.instance.systemModeColorChangeState(context,Colors.black12,Color.fromRGBO(40, 37, 36, transparentBGBool ? 0.2 : 1)))) : ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.transparent)) ,
                                          // style:  currentSelectSettingTitle == title.toString() ? ButtonStyle(backgroundColor:MaterialStateProperty.all(Common().getRandomColor(0.8))) : ButtonStyle(backgroundColor:MaterialStateProperty.all(Colors.transparent)) ,
                                          onPressed: () {
                                            currentSelectSettingTitle = title.toString();

                                            popState(() {});
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                iconList[index],
                                                size: 14,
                                                color: currentSelectSettingTitle == title.toString() ? Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white) : Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white),
                                              ),
                                              Container(width: 5,),
                                              Text(
                                                title,
                                                style: TextStyle(
                                                    color: currentSelectSettingTitle == title.toString() ? Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white) : Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(68, 68, 68, 1),Colors.white),
                                                    fontSize: 12
                                                ),
                                              ),
                                            ],
                                          ));
                                    }).toList(),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    width: 550,
                                    height: 420,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                                      color: Common.instance.systemModeColorChangeState(context,const Color.fromRGBO(40, 37, 36,0.1),Color.fromRGBO(40, 37, 36,transparentBGBool ? 0.6 : 1)),
                                    ),
                                    child:Common.instance.settingWidgetList(currentSelectSettingTitle,context,colorState, callBackListener: MyThemeCallBackListener(myCallBack: (type){
                                      if(type == "1"){
                                        colorState = "1";
                                      }else if(type == "2"){
                                        colorState = "2";
                                      }else{
                                        colorState = "";
                                      }
                                      print("-=-=-=88888-=--==-=$colorState-------------");

                                      //设置主题背景颜色
                                      Store.getInstance().then((store){
                                        store.setScreenThemeColorString(StoreKeys.themeColorKey, colorState);
                                      });

                                      popState(() {});

                                      setState(() {

                                      });
                                    },)
                                    )
                                ),
                              ],
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              // width: 60,
                              height: 35,
                              // color: Colors.red,
                              margin: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  // Container(
                                  //     height: 30,
                                  //     width:90,
                                  //     color: const Color.fromRGBO(
                                  //         40, 37, 36, 1),
                                  //     alignment: Alignment.center,
                                  //     child: TextButton(
                                  //       onPressed: (){
                                  //
                                  //       },
                                  //       child: Row(
                                  //         children: [
                                  //           Image.asset("images/folder.png",width: 20,height: 20,),
                                  //           const Padding(
                                  //             padding: EdgeInsets.only(left: 5),child: Text("恢复默认",textAlign: TextAlign.center,style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 12,
                                  //           ),),
                                  //           )
                                  //         ],
                                  //       ),
                                  //     )
                                  // ),
                                  const Spacer(),
                                  SizedBox(
                                    width: 570,
                                    height: 30,
                                    // color: Colors.red,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          height: 30,
                                          width: 80,
                                          // margin: EdgeInsets.only(left: 10),
                                          color: Common.instance.systemModeColorChangeState(context,Colors.transparent,const Color.fromRGBO(40, 37, 36, 1)),
                                          alignment: Alignment.center,
                                          child: TextButton(
                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Common.instance.systemModeColorChangeState(context,Colors.black12,const Color.fromRGBO(40, 37, 36, 1)))),
                                            onPressed: () {
                                              pop.dismiss(context);

                                            },
                                            child: Text(
                                              "取消",
                                              style: TextStyle(
                                                color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 30,
                                          width: 80,
                                          margin: const EdgeInsets.only(right: 10),
                                          color: Common.instance.systemModeColorChangeState(context,Colors.transparent,const Color.fromRGBO(40, 37, 36, 1)),
                                          alignment: Alignment.center,
                                          child: TextButton(
                                            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Common.instance.systemModeColorChangeState(context,Colors.black12,const Color.fromRGBO(40, 37, 36, 1)),)),
                                            onPressed: () {
                                              createNewPathAndFileAction(currentSelectFileSavePath,fileNameTextController.text,currentSelectFileStyleTitle, demoCodeController.text,false);
                                              pop.dismiss(context);

                                            },
                                            child: Text(
                                              "确定",
                                              style: TextStyle(
                                                color: Common.instance.systemModeColorChangeState(context,Colors.black,Colors.white),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    )),
              );
            });
      },
    );
  }

  //创建点击的显示标题视图
  List<Tooltip> buildClickCodeFileList(double width,BuildContext topContext) {

    if(clickFileNameList.isEmpty){

      Color randColor = Common.instance.getRandomColor(0.5);
      String clickFileName = "欢 迎 使 用  CODE  MAKER !          TALK IS CHEAP , SHOW ME YOUR CODE !        废话少说,给我看看你的代码";
      Tooltip item = Tooltip(
        margin: const EdgeInsets.only(left: 250),
        message: clickFileName,
        child:  Column(
          children: [
            GestureDetector(
              onTap: () {
                //点击了当前的路径文件
              },
              child: Container(
                height: 28,
                color: randColor,
                width: width,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 2,top: 2,right: 2),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Text(
                    clickFileName,
                    maxLines: 1,
                    style:
                    const TextStyle(color: Colors.white, fontSize: 12,overflow: TextOverflow.clip),
                  ),
                ),
              ),
            ),
            //倒三角形
            Container(
              width: 0,
              height: 5,
              decoration: BoxDecoration(
                border: Border(
                  // 四个值 top right bottom left
                  bottom: BorderSide(
                      color: randColor,
                      // 朝上; 其他的全部透明transparent或者不设置
                      width: 5,
                      style: BorderStyle.solid),
                  right: const BorderSide(
                      color: Colors.transparent, // 朝左;  把颜色改为目标色就可以了；其他的透明
                      width: 5,
                      style: BorderStyle.solid),
                  left: const BorderSide(
                      color: Colors.transparent, // 朝右；把颜色改为目标色就可以了；其他的透明
                      width: 5,
                      style: BorderStyle.solid),
                  top: const BorderSide(
                      color: Colors.transparent, // 朝下;  把颜色改为目标色就可以了；其他的透明
                      width: 5,
                      style: BorderStyle.solid),
                ),
              ),
            ),
          ],
        ),
      );
      // widgetList.add(item);
      List<Tooltip> widgetList = [item];
      return widgetList;
    }else{
      List<Tooltip> widgetList = clickFileNameList.asMap().keys.map((index) {
        Map dic = clickFileNameList[index];
        String clickFileName = dic['file_name'];
        String clickFilePathString = dic['path'];
        Color randColor = Common.instance.getRandomColor(0.7);
        //当前点击的文件
        return Tooltip(
          margin: const EdgeInsets.only(left: 250),
          message: clickFilePathString,
          key: GlobalObjectKey(index),
          child: Column(
            children: [
              Container(
                width: 30,
                // margin: const EdgeInsets.all(0),
                padding: const EdgeInsets.only(left: 0),
                // margin: EdgeInsets.all(0),
                height: 2,
                color: !(FileSystemEntity.isFileSync(
                    _current_choose_path_file_string))
                    ? (_current_choose_code_file_string ==
                    clickFilePathString
                    ? Common.instance.systemModeColorChangeState(context,Colors.red,Colors.orangeAccent)
                    : Colors.transparent)
                    : (_current_choose_path_file_string ==
                    clickFilePathString
                    ? Common.instance.systemModeColorChangeState(context,Colors.red,Colors.orangeAccent)
                    : Colors.transparent),
                alignment: Alignment.centerLeft,
              ),
              GestureDetector(
                onTap: () {

                  if(!fileNeedSaveAlert(topContext,true)){

                    //点击了当前的路径文件
                    _current_choose_path_file_string = clickFilePathString;
                    _current_choose_code_file_string = clickFilePathString;

                    //滚动到可视区域
                    if (GlobalObjectKey(index).currentContext != null) {
                      Scrollable.ensureVisible(
                          GlobalObjectKey(index).currentContext!);
                    }

                    //更换编辑区内容
                    //是文件
                    tryToOpenFileMethodWithPath(_current_choose_path_file_string);

                    setState(() {});
                  }
                },
                child: Container(
                  height: 28,
                  color:Common.instance.systemModeColorChangeState(context,Common.instance.getRandomColor(1),Common.instance.getRandomColor(0.5)),
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 2,top: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 3),
                        child: Text(
                          clickFileName,
                          style:
                          const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      Container(
                        width: 25,
                        height: 25,
                        // color: Colors.red,
                        alignment: Alignment.center,
                        child: IconButton(
                          onPressed: () {
                            //判断是非有文件需要保存
                            if(!fileNeedSaveAlert(topContext,true)){

                              //点击了移除文件
                              bool hasContainElementBool = false;
                              for (var e in clickFileNameList) {
                                String fileNameStr = e['path'].toString();
                                if (fileNameStr == clickFilePathString.toString()) {
                                  hasContainElementBool = true;
                                  break;
                                }
                              }
                              //存在该文件
                              if (hasContainElementBool) {
                                clickFileNameList.remove(dic);
                                //存在就删除
                                //然后编辑器内容更换为上一个文件内容

                                if (clickFileNameList.isNotEmpty) {
                                  //不是空的就打开最后一个文件
                                  Map aheadDic = clickFileNameList.last;
                                  String aheadPath = aheadDic['path'];
                                  _current_choose_path_file_string = aheadPath;
                                  _current_choose_code_file_string = aheadPath;
                                  //打开文件的操作
                                  tryToOpenFileMethodWithPath(aheadPath);
                                }
                                setState(() {});
                              }
                              //默认状态的下的显示视图
                              normalStateUserShowWidget();
                            }
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //倒三角形
              Container(
                width: 0,
                height: 5,
                decoration: BoxDecoration(
                  border: Border(
                    // 四个值 top right bottom left
                    bottom: BorderSide(
                        color: !(FileSystemEntity.isFileSync(
                            _current_choose_path_file_string))
                            ? (_current_choose_code_file_string ==
                            clickFilePathString
                            ? randColor
                            : Colors.transparent)
                            : (_current_choose_path_file_string ==
                            clickFilePathString
                            ? randColor
                            : Colors.transparent),
                        // 朝上; 其他的全部透明transparent或者不设置
                        width: 5,
                        style: BorderStyle.solid),
                    right: const BorderSide(
                        color: Colors.transparent, // 朝左;  把颜色改为目标色就可以了；其他的透明
                        width: 5,
                        style: BorderStyle.solid),
                    left: const BorderSide(
                        color: Colors.transparent, // 朝右；把颜色改为目标色就可以了；其他的透明
                        width: 5,
                        style: BorderStyle.solid),
                    top: const BorderSide(
                        color: Colors.transparent, // 朝下;  把颜色改为目标色就可以了；其他的透明
                        width: 5,
                        style: BorderStyle.solid),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();

      Future.delayed(const Duration(milliseconds: 500), () {
        if (kDebugMode) {
          print("延时1秒执行");
        }
        for (int i = 0; i < clickFileNameList.length; i++) {
          String pathStr = clickFileNameList[i]["path"];
          if (_current_choose_path_file_string == pathStr.toString()) {
            //滚动到可视区域
            if (GlobalObjectKey(i).currentContext != null) {
              Scrollable.ensureVisible(GlobalObjectKey(i).currentContext!);
              break;
            }
          }
        }
      });
      return widgetList;
    }
  }

  //读文件内容
  void tryToOpenFileMethodWithPath(String path) {

    _fileSaveManager.path = path;
    //尝试打开文件
    try {
      File file = File(path);
      var result = file.readAsString().then((value) {
        codeStrLength = value.length;
        codeController.text = value;
        _fileSaveManager.fileDefaultContent = value;
        codeController.language = Common.instance
            .isCodeLanguageType(
            path).mode;

      });

      result.onError((error, stackTrace){
        if (kDebugMode) {
          print("-=-=-=-=-=-=-=-FileSystemException---error=$error-------");
        }
        codeStrLength = 0;
        errorsCollectAction(error,"");
        codeController.text = errorOpenFileTextRefer();
        _fileSaveManager.fileDefaultContent = "";
        codeController.language = Common.instance
            .isCodeLanguageType(path).mode;

        fileOpenErrorList.add(path.toString());
      });
    } on FileSystemException {
      if (kDebugMode) {
        print(
          "-=-=-=-=-=-=-=-FileSystemException----------");
      }
    }
  }

  bool fileNeedSaveAlert(BuildContext context,bool noActionBool) {
    print(
        "-=-=-=-=-=-=-=-fileNeedSaveAlert------${_fileSaveManager.path}----");
    if(!fileOpenErrorList.contains(_fileSaveManager.path.toString())){
      //不存在打不开的情况simpleDialog
      _fileSaveManager.canOpenBool = true;
      if(_fileSaveManager.needSaveBool){
        Common.instance.simpleDialog(context,_fileSaveManager).then((value) {
            if(value){
              //保存文件
              writeIntoFile(_fileSaveManager.path, _fileSaveManager.fileNewContent);
            }else{
              //文件不保存
            }
            _fileSaveManager.fileBecomeDefault();

            setState(() {});
        });
        if(noActionBool){
          return noActionBool;
        }
      }
    }
    return false;
  }

  String errorOpenFileTextRefer() => "//  Ops ! Sorry !  打开未知文件错误，无法打开\n//  Error open unknow file , path : '$_current_choose_path_file_string'";
//默认状态的下的显示视图
  void normalStateUserShowWidget() {
    if(clickFileNameList.isEmpty){
      //加载默认文件夹
      rootBundle.loadString("images/myWelcome.txt").then((value){
        codeController.text = value;
        codeController.autocompleter.setCustomWords(Common.instance.isCodeLanguageType(".txt").codeKeywordsArr);
        //刷新
        setState(() {});
      });
    }
  }

  void errorsCollectAction(Object? error,String? success) {
    if(_error_area_height == 0){
      _error_area_header_height = 20;
      _error_area_height = 50;
      _error_area_last_height = 50;
      _error_area_header_is_open_fold_bool = true;
    }
    String? showString = "";
    if(error != null){
      showString = error.toString();
    }else if(success != null){
      showString = success;
    }else{
      return;
    }
    errorStringList.add({"path":_current_choose_path_file_string.toString(),"time":DateTime.now().toString().substring(0,19),"error":showString});
    setState(() {});
  }

  List _sortCurrentFiles(List currentFiles) {
    List defaultList = [];
    //排序 文件在后 文件夹在前
    late List fileList = [];
    late List foldList = [];

    for (var element in currentFiles) {
      String pathString = element.path;
      String fileTitle = pathString.substring(element.parent.path.length + 1);
      //剔除 带 （.git等隐藏文件）
      if(!fileTitle.startsWith(".")){
        if (FileSystemEntity.isFileSync(pathString)) {
          fileList.add(element);
        } else if (FileSystemEntity.isDirectorySync(pathString)){
          foldList.add(element);
        }else{
          fileList.add(element);
        }
      }
    }
    //添加文件
    if (foldList.isNotEmpty) {
      defaultList.addAll(foldList);
    }
    if (fileList.isNotEmpty) {
      defaultList.addAll(fileList);
    }
    return defaultList;
  }

  //建立文件夹视图
  Widget _buildFolderExpansionTitle(
      FileSystemEntity file, double leftDistance) {
    var directory = Directory(file.path);
    List myCurrentFiles = directory.listSync();

    return Theme(data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: FileExpansionTile(
          onExpansionChanged: (onExpansionChanged) {
            // if (kDebugMode) {
            //   print("-=-=-=-=-onExpansionChanged=$onExpansionChanged=-=-=-=-=-");
            // }

            _current_choose_path_file_string = file.path;
            _current_file_or_folder_is_click_bool = true;
            setState(() {});
          },
          trailing: const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.circle,
              size: 5,
            ),
          ),
          // subtitle: Text(Common.instance.getFileSize(file.statSync().size)),
          tilePadding: const EdgeInsets.all(0),
          childrenPadding: const EdgeInsets.all(0),
          title: Stack(
            children: [
              Container(
                height: 20,
                padding: const EdgeInsets.all(0),
                color: (_current_file_or_folder_is_click_bool &&
                    _current_choose_path_file_string == file.path)
                    ? Common.instance.getRandomColor(0.8)
                    : Colors.transparent,
              ),
              Listener(
                onPointerDown: (event){

                  _current_choose_path_file_string = file.path.toString();
                  _current_file_or_folder_is_click_bool = true;

                  if (Common.instance.isImageBool(_current_choose_path_file_string)) {
                    //是图片
                    isNotCodeFileBool = true;
                  }else{
                    isNotCodeFileBool = false;
                  }

                  _onPointerDown(event);

                  setState(() {});
                },
                child: Row(
                  children: [
                    Container(
                      // color: Colors.red,
                      margin: const EdgeInsets.only(left: 8, top: 2, right: 5),
                      width: 16,
                      height: 16,
                      child: Image.asset("images/folder.png"),
                    ),
                    Expanded(
                      child: SizedBox(
                        height: 16,
                        // color: Colors.purple,
                        child: Text(
                          file.path.substring(file.parent.path.length + 1),
                          style:TextStyle(fontSize: 14, color:Common.instance.systemModeColorChangeState(context,(_current_file_or_folder_is_click_bool &&
                              _current_choose_path_file_string == file.path) ? Colors.white :Colors.black87,Colors.white)),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: _sortCurrentFiles(myCurrentFiles).map((e) {
            Widget myWidget; //返回最终视图
            bool isFolderBool = false; //是否是文件夹
            if (FileSystemEntity.isFileSync(e.path)) {
              myWidget = Padding(
                padding: EdgeInsets.only(left: leftDistance),
                child: _buildFileExpansionTitle(e, leftDistance,true),
              );
            } else {
              //是文件夹
              if(FileSystemEntity.isDirectorySync(e.path)){
                isFolderBool = true;
                myWidget = Padding(
                  padding: EdgeInsets.only(left: leftDistance),
                  child: _buildFolderExpansionTitle(e, leftDistance),
                );

              }else {
                myWidget = Padding(
                  padding: EdgeInsets.only(left: leftDistance),
                  child: _buildFileExpansionTitle(e, leftDistance,true),
                );
              }
            }
            return Stack(
              children: [
                !isFolderBool
                    ? myWidget
                    :
                GestureDetector(
                  onTap: () async {
                    _current_choose_path_file_string = e.path;
                    _current_file_or_folder_is_click_bool = true;

                    if (Common.instance.isImageBool(_current_choose_path_file_string)) {
                      //是图片
                      isNotCodeFileBool = true;
                    }else{
                      isNotCodeFileBool = false;
                    }
                    setState(() {});
                  },
                  child: myWidget,
                ),
              ],
            );
          }).toList(),
        )
    );
  }

  //建立文件视图
  Widget _buildFileExpansionTitle(FileSystemEntity file, double leftDistance,bool foldInsideFileBool) {

    Widget currentWidget = GestureDetector(
      child: Stack(
        children: [
          Container(
            height: 20,
            padding: const EdgeInsets.all(0),
            color: (_current_file_or_folder_is_click_bool &&
                _current_choose_path_file_string == file.path)
                ? Common.instance.getRandomColor(0.8)
                : Colors.transparent,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: 15,
                height: 20,
                margin:
                EdgeInsets.only(right: 5, left: leftDistance / 2, top: 0),
                alignment: Alignment.center,
                child: _buildImage(file.path),
              ),
              Expanded(
                child: Container(
                  height: 20,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    file.path.substring(file.parent.path.length + 1),
                    style: TextStyle(
                      fontSize: 12,
                      color:Common.instance.systemModeColorChangeState(context,(_current_file_or_folder_is_click_bool &&
                          _current_choose_path_file_string == file.path) ? Colors.white : Colors.black87,Colors.white),
                    ),
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      onTap: () {

        _current_choose_path_file_string = file.path;
        _current_file_or_folder_is_click_bool = true;

        if (kDebugMode) {
          print("-=-=-=-=-=-=-=-88888=----------");
        }
        //是文件 点击了左边的文件系统列表
        clickLeftFileSystemListAction(file);
      },
    );

    return Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (event){

          _current_choose_path_file_string = file.path.toString();
          _current_file_or_folder_is_click_bool = true;

          _onPointerDown(event);

          if(!FileSystemEntity.isDirectorySync(file.path)){
            clickLeftFileSystemListAction(file);
          }
        },
        child: currentWidget
    );
  }
  //点击了左边的文件系统列表
  void clickLeftFileSystemListAction(FileSystemEntity file) {
    _current_choose_code_file_string = file.path;
    if (Common.instance.isImageBool(_current_choose_path_file_string)) {
      //是图片
      isNotCodeFileBool = true;
    } else {
      isNotCodeFileBool = false;

      Map dicMap = {
        "path": _current_choose_path_file_string,
        "file_name": File(_current_choose_path_file_string).path.substring(
            File(_current_choose_path_file_string).parent.path.length + 1)
      };
      //去重
      bool hasContainElementBool = false;
      for (var e in clickFileNameList) {
        String fileNameStr = e['path'].toString();
        if (fileNameStr == _current_choose_path_file_string.toString()) {
          hasContainElementBool = true;
          break;
        }
      }
      if (!hasContainElementBool) {
        //不存在该文件
        clickFileNameList.add(dicMap);
      }
      tryToOpenFileMethodWithPath(_current_choose_path_file_string);
      //是文件
    }
    setState(() {});
  }

  _getDirectPath(String initPath) async {
    // if(kIsWeb){
    //   Future<String?> path = FileSelectorWeb().getDirectoryPath(confirmButtonText: "请选择一个保存地址");
    //   return path;
    // }else {
    Future<String?> path = FileSelectorPlatform.instance
        .getDirectoryPath(confirmButtonText: "打开",initialDirectory: initPath);
    return path;
    // }
  }

  //选择一个文件保存地址
  _getSavePath() async {

    Future<String?> path = FileSelectorPlatform.instance
        .getSavePath(confirmButtonText: "保存到",suggestedName: "codeMaker");

    path.then((value){
      print("-=-=-=-=getSavePath-=--$value-=-=-=-");
    });

    return path;
  }

  Future<List<XFile>?> _openFilesPath() async {
    Future<List<XFile>?> listPath = FileSelectorPlatform.instance.openFiles();
    return listPath;
  }

  Widget _buildImage(String path) {
    path = path.toLowerCase();
    switch (Common.instance.isImageBool(path)) {
      case true:
        return Image.file(
          File(path),
          width: 14.0,
          height: 14.0,
          // 解决加载大量本地图片可能会使程序崩溃的问题
          // cacheHeight: 14,
          // cacheWidth: 14,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.none,
        );
      default:
        return Image.asset(Common.instance.selectIcon(p.extension(path)),
            width: 14.0, height: 14.0);
    }
  }

  // 计算以 . 开头的文件、文件夹总数
  int _calculatePointBegin(List<FileSystemEntity> fileList) {
    int count = 0;
    for (var v in fileList) {
      if (p.basename(v.path).substring(0, 1) == '.') count++;
    }
    return count;
  }

  // 计算文件夹内 文件、文件夹的数量，以 . 开头的除外
  int _calculateFilesCountByFolder(Directory path) {
    var dir = path.listSync();
    int count = dir.length - _calculatePointBegin(dir);

    return count;
  }

  // 获取当前路径下的文件/文件夹
  void getCurrentPathFiles(String path) {
    try {
      Directory currentDir = Directory(path);
      List<FileSystemEntity> files = [];
      List<FileSystemEntity> folder = [];

      // 遍历所有文件/文件夹
      for (var v in currentDir.listSync()) {
        // 去除以 .开头的文件/文件夹
        if (p.basename(v.path).substring(0, 1) == '.') {
          continue;
        }
        if (FileSystemEntity.isFileSync(v.path)) {
          files.add(v);
        } else if(FileSystemEntity.isDirectorySync(v.path)){
          folder.add(v);
        }else{
          files.add(v);
        }
      }
      // 排序
      files
          .sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
      folder
          .sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));

      currentFiles.clear();
      currentFiles.addAll(folder);
      currentFiles.addAll(files);
    } catch (e) {
      print(e);
      print("Directory does not exist！");
    }
  }

  //打开单个文件
  void openSingleFileAction(){

    Future<List<XFile>?> path = _openFilesPath();
    path.then((value) {
      print("-=-=-=-=-=-value=$value=-=-=-=-=-=-=-=-=-=-=");
      _fileLeftEdgDistance = 15;

      List<XFile>? fileArray = value;

      if (fileArray!.isNotEmpty) {
        for (var x in fileArray) {
          XFile xFile = x;

          if (xFile.path.isEmpty) {
            _pathToSave = '';
            return;
          } else {
            _pathToSave = xFile.path;

            Directory defaultDirectory =
            Directory(_pathToSave);
            List<FileSystemEntity> defaultEntity = [
              defaultDirectory
            ];

            bool existBool = false;
            if (currentFiles.isNotEmpty) {
              for(FileSystemEntity entity in currentFiles){
                if(entity.path.toString() == defaultDirectory.path.toString()){
                  existBool = true;
                  break;
                }
              }
              if(!existBool){
                currentFiles.addAll(defaultEntity);
                addHistoryPathItemAction(defaultDirectory.path.toString());
              }else{
                errorsCollectAction(null,"当前文件已经打开，请勿重复打开 ： ${defaultDirectory.toString()}");
              }
            } else {
              currentFiles = defaultEntity;
              addHistoryPathItemAction(defaultDirectory.path.toString());
            }
            print("-=-=-listSync=-=-=--$currentFiles=-=-=-=-=-=-=-=-=-=-=");
          }
        }
        setState(() {});
      }
    });
  }

  //打开项目文件夹
  void openProjectFilesAction(String initPath){

    Future<dynamic> path = _getDirectPath(initPath);
    path.then((value) {
      print("-=-=-=-=-=-value=$value=-=-=-=-=-=-==-=-=");
      _fileLeftEdgDistance = 15;
      if (value == null) {
        _pathToSave = '';
        return;
      } else {
        _pathToSave = value;
        // FileSystemEntity defaultEntity = FileSystemEntity(Directory:);
        Directory defaultDirectory =
        Directory(_pathToSave);
        List<FileSystemEntity> defaultEntity = [
          defaultDirectory
        ];
        bool existBool = false;
        if (currentFiles.isNotEmpty) {
          for(FileSystemEntity entity in currentFiles){
            if(entity.path.toString() == defaultDirectory.path.toString()){
              existBool = true;
              break;
            }
          }
          if(!existBool){
            currentFiles.addAll(defaultEntity);
            addHistoryPathItemAction(defaultDirectory.path.toString());
          }else{
            errorsCollectAction(null,"当前文件已经打开，请勿重复打开 ： ${defaultDirectory.toString()}");
          }
        } else {
          currentFiles = defaultEntity;
          addHistoryPathItemAction(defaultDirectory.path.toString());
        }
        print("-=-=-listSync=-=-=--$currentFiles=-=-=-=-=-=-=-=");
        setState(() {});
      }
    });
  }

  void addHistoryPathItemAction(String item) {
    Store.getInstance().then((store){
      store.addHistoryPathItem(StoreKeys.historyKey, item.toString());
    });
  }

  // 删除文件
  void deleteFile(FileSystemEntity file) {

    var result = showDialog(
        barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            title: const Column(
              children: [
                Text("删除文件",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.blueAccent)),
                Text("delete file",textAlign: TextAlign.center,style: TextStyle(fontSize: 10,color: Colors.grey)),
              ],
            ),
            backgroundColor: const Color.fromRGBO(62, 62, 62, 0.9),
            children: [
              const Divider(color: Colors.white,height: 20,thickness: 0.2,),
              SizedBox(
                width: 250,
                // padding: const EdgeInsets.only(left: 20,right: 20),
                child: Text("确定删除 ${file.path.substring(file.parent.path.length + 1)} 文件吗?\n文件将无法恢复",textAlign: TextAlign.center,style: const TextStyle(fontSize: 12,color: Colors.white),),
              ),
              const Divider(color: Colors.white,height: 20,thickness: 0.2),
              SizedBox(
                height: 24,
                // padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                      // color: Colors.red,
                      child: TextButton(
                        onPressed: () {
                          print("取消(No)");
                          Navigator.pop(context, "不保存");
                        },
                        child: const Text("取消(No)",style: TextStyle(fontSize: 12,color: Colors.blueAccent)),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                      // color: Colors.red,
                      child: TextButton(
                        onPressed: () {

                          try {
                            Directory directory = Directory(file.path);
                            if (file.statSync().type == FileSystemEntityType.directory) {
                              directory.deleteSync(recursive: true);
                            } else if (file.statSync().type ==
                                FileSystemEntityType.file) {
                              directory.deleteSync(recursive: true);

                              //删除右侧栏目的文件显示
                              int idx = -1;
                              for(int i=0;i<clickFileNameList.length;i++){
                                Map dic = clickFileNameList[i];
                                String clickFileName = dic['file_name'];
                                String clickFilePathString = dic['path'];
                                if(clickFilePathString == file.path.toString()) {
                                  idx = i;
                                }
                              }
                              //有就删除
                              if(idx >= 0){
                                clickFileNameList.removeAt(idx);

                                if (clickFileNameList.isNotEmpty) {
                                  //不是空的就打开最后一个文件
                                  Map aheadDic = clickFileNameList.last;
                                  String aheadPath = aheadDic['path'];
                                  _current_choose_path_file_string = aheadPath;
                                  _current_choose_code_file_string = aheadPath;
                                  //打开文件的操作
                                  tryToOpenFileMethodWithPath(aheadPath);
                                }
                                //文件删除写进日志
                                errorsCollectAction(null,"文件删除成功 ： ${file.path.toString()}");
                              }
                            }
                            setState(() {});

                          } on FileSystemException {
                            errorsCollectAction(null,"文件删除失败 ： ${file.path.toString()}");
                          }

                          Navigator.pop(context);

                          //刷新右侧编辑栏目的显示
                        },
                        child: const Text("确认(Yes)",style: TextStyle(fontSize: 12,color: Colors.blueAccent)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  // 重命名
  void renameFile(FileSystemEntity file) {
    TextEditingController controller = TextEditingController();

    var result = showDialog(
        barrierDismissible: false, //表示点击灰色背景的时候是否消失弹出框
        context: context,
        builder: (context) {
          return SimpleDialog(
            titlePadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            title: const Column(
              children: [
                Text("文件重命名",textAlign: TextAlign.center,style: TextStyle(fontSize: 16,color: Colors.blueAccent)),
                Text("file rename",textAlign: TextAlign.center,style: TextStyle(fontSize: 10,color: Colors.grey)),
              ],
            ),
            backgroundColor:  transparentBGBool ?  const Color.fromRGBO(62, 62, 62,0.8) : const Color.fromRGBO(62, 62, 62,0.95),
            children: [
              const Divider(color: Colors.transparent,height: 5,),
              SizedBox(
                width: 350,
                // padding: const EdgeInsets.only(left: 20,right: 20),
                child: Text("当前：${file.path.substring(file.parent.path.length + 1)}",textAlign: TextAlign.left,style: const TextStyle(fontSize: 12,color: Colors.white),),
              ),
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 300,
                    padding: const EdgeInsets.only(left: 0,top: 10,bottom: 10,right: 0),
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 0.5)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0.5),
                          // borderRadius: BorderRadius.circular(2.0)
                        ),
                        hintText: '请输入新名称，无需修改文件后缀',
                        hintStyle: TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 0.5),
                          // borderRadius: BorderRadius.circular(2.0)
                        ),
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    // width: 100
                    child: Text(p.extension(file.path),style: const TextStyle(color: Colors.white,fontSize: 12),),
                  ),
                ],
              ),
              const Divider(color: Colors.transparent,height: 5,),
              SizedBox(
                height: 24,
                // padding: EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 24,
                      // color: Colors.red,
                      child: TextButton(
                        onPressed: () {
                          print("取消(No)");
                          Navigator.pop(context, "不保存");
                        },
                        child: const Text("取消(No)",style: TextStyle(fontSize: 12,color: Colors.blueAccent)),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                      // color: Colors.red,
                      child: TextButton(
                        onPressed: () {

                          String newName = controller.text;

                          if (newName.trim().isEmpty) {
                            Common.instance.displaySuccessMotionToast(context);
                            return;
                          }
                          if(FileSystemEntity.isDirectorySync(file.path)){

                            Directory directory = Directory(file.path);
                            String newPath = '${file.parent.path}/$newName';
                            try {
                              var result = directory.rename(newPath).then((value){});
                              result.onError((error, stackTrace){
                                errorsCollectAction(error,"");
                                codeController.text = errorOpenFileTextRefer();
                                codeController.language = Common.instance
                                    .isCodeLanguageType(_current_choose_path_file_string).mode;
                              });

                            } on FileSystemException {
                              Common.instance.displaySuccessMotionToast(context);
                            }
                          }else if(FileSystemEntity.isFileSync(file.path)){
                            var renameFile = File(file.path);
                            String newPath = '${file.parent.path}/$newName${p.extension(file.path)}';

                            try {
                              var result = renameFile.rename(newPath).then((value){});
                              result.onError((error, stackTrace){
                                errorsCollectAction(error,"");
                                codeController.text = errorOpenFileTextRefer();
                                codeController.language = Common.instance
                                    .isCodeLanguageType(_current_choose_path_file_string).mode;
                              });

                            } on FileSystemException {
                              Common.instance.displaySuccessMotionToast(context);
                            }
                          }
                          setState(() {});

                          Navigator.pop(context);

                        },
                        child: const Text("确认(Yes)",style: TextStyle(fontSize: 12,color: Colors.blueAccent)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  //需要保存的文件进行异步写入操作
  void writeIntoFile(String path,String content) async{

    //尝试写入文件
    try {
      File file = File(path);
      var result = file.writeAsString(content).then((value) {
        errorsCollectAction(null,"文件保存成功 ： $path");
        // snackAlertFromBottomAction('$path  文件保存成功');
      });

      result.onError((error, stackTrace){
        if (kDebugMode) {
          print("-=-=-=-=-=-=-=-FileSystemException---error=$error-------");
        }
        errorsCollectAction(error,"");
        if(error != null){
          // snackAlertFromBottomAction('$path  文件保存失败');
        }
      });
    } on FileSystemException {
      if (kDebugMode) {
        print(
            "-=-=-=-=-=-=-=-FileSystemException----------");
      }
    }
  }

  //用户新建文件和路径
  createNewPathAndFileAction(String path,String fileName,String fileSuffix, String content,bool insideCurrentDirBool){
    Directory dir = Directory(path);
    String finalFilePath = "$path/$fileName$fileSuffix";
    File file = File(finalFilePath);

    if(path.isEmpty){
      return;
    }

    if(dir.existsSync()){

      //存在路径
      if(file.existsSync()){
        //存在文件 就直接写入
        var result = file.writeAsString(content).then((value){
          //写入成功
          errorsCollectAction(null,"文件创建成功 ： $path");
          // snackAlertFromBottomAction('$path  文件创建成功');
        });

        result.onError((error, stackTrace){
          if(error != null){
            errorsCollectAction(null,"文件创建失败 ： $path");
            // snackAlertFromBottomAction('$path  文件创建失败');
          }
        });
      }else{

        if(insideCurrentDirBool){
          Directory cDir = Directory(finalFilePath);
          if(!(cDir.existsSync()) && fileSuffix.isEmpty){
            cDir.create();
            setState(() {});
          }
        }

        file.create().then((newFile){
          var result = newFile.writeAsString(content).then((value){
            //写入成功
            errorsCollectAction(null,"文件创建成功 ： $path");
            // snackAlertFromBottomAction('$path  文件创建成功');

            setState(() {});
          });

          result.onError((error, stackTrace){
            if(error != null){
              errorsCollectAction(null,"文件创建失败 ： $path");
              // snackAlertFromBottomAction('$path  文件创建失败');
            }
            setState(() {});
          });
        });
      }

      if(!insideCurrentDirBool){
        //刷新路径
        Directory defaultDirectory =
        Directory(path);
        List<FileSystemEntity> defaultEntity = [
          defaultDirectory
        ];

        if(dir.existsSync()){
          bool existBool = false;
          for(FileSystemEntity entity in currentFiles){
            if(entity.path.toString() == defaultDirectory.path.toString()){
              existBool = true;
              break;
            }
          }
          if(!existBool){
            currentFiles.addAll(defaultEntity);
            addHistoryPathItemAction(defaultDirectory.path.toString());
          }else {
            errorsCollectAction(null,
                "当前文件已经打开，请勿重复打开 ： ${defaultDirectory
                    .toString()}");
          }
        }else{
          bool existBool = false;
          if (currentFiles.isNotEmpty) {
            for(FileSystemEntity entity in currentFiles){
              if(entity.path.toString() == defaultDirectory.path.toString()){
                existBool = true;
                break;
              }
            }
            if(!existBool){
              currentFiles.addAll(defaultEntity);
              addHistoryPathItemAction(defaultDirectory.path.toString());
            }else{
              errorsCollectAction(null,"当前文件已经打开，请勿重复打开 ： ${defaultDirectory.toString()}");
            }
          } else {
            currentFiles = defaultEntity;
            addHistoryPathItemAction(defaultDirectory.path.toString());
          }
        }
        print("-=-=-listSync=-=-=--$currentFiles=-=-=-=-=-=-=-=");
      }
      setState(() {});

    }else{
      print("-=-=-888888888888-=-=-=-=-=-=-=");
      //不存在路径 就先创建路径 再创建文件 再写入
      dir.create().then((newDir){

        if(fileSuffix.isEmpty){
          setState(() {});
          return;
        }
        file.create().then((newFile){
          var result = newFile.writeAsString(content).then((value){
            //写入成功
            print("-=-=-6666666-=-=-=-=-=-=-=");
            errorsCollectAction(null,"文件创建成功 ： $path");
            // snackAlertFromBottomAction('$path  文件创建成功');

            setState(() {});
          });

          result.onError((error, stackTrace){
            if(error != null){
              print("-=-=-${newFile.path}=-=-=--$error-=-=-=-=-=-=-=");
              errorsCollectAction(null,"文件创建失败 ： $path");
              // snackAlertFromBottomAction('$path  文件创建失败');
            }
            setState(() {});
          });

          if(!insideCurrentDirBool){
            //刷新路径
            Directory defaultDirectory =
            Directory(path);
            List<FileSystemEntity> defaultEntity = [
              defaultDirectory
            ];

            if(dir.existsSync()){

              bool existBool = false;
              for(FileSystemEntity entity in currentFiles){
                if(entity.path.toString() == defaultDirectory.path.toString()){
                  existBool = true;
                  break;
                }
              }
              if(!existBool){
                currentFiles.addAll(defaultEntity);
                addHistoryPathItemAction(defaultDirectory.path.toString());
              }else {
                errorsCollectAction(null,
                    "当前文件已经打开，请勿重复打开 ： ${defaultDirectory
                        .toString()}");
              }
            }else{
              bool existBool = false;
              if (currentFiles.isNotEmpty) {
                for(FileSystemEntity entity in currentFiles){
                  if(entity.path.toString() == defaultDirectory.path.toString()){
                    existBool = true;
                    break;
                  }
                }
                if(!existBool){
                  currentFiles.addAll(defaultEntity);
                  addHistoryPathItemAction(defaultDirectory.path.toString());
                }else{
                  errorsCollectAction(null,"当前文件已经打开，请勿重复打开 ： ${defaultDirectory.toString()}");
                }
              } else {
                currentFiles = defaultEntity;
                addHistoryPathItemAction(defaultDirectory.path.toString());
              }
            }
            print("-=-=-listSync=-=-=--$currentFiles=-=-=-=-=-=-=-=");
          }
          setState(() {});
        });
      });
    }
  }

   historyDataLoadView(){

    Store.getInstance().then((store){
      Future<dynamic> state = store.getHistoryListString(StoreKeys.historyKey);
      state.then((data){

        if(data != null){
          historyList = data;
          print("--------historyList---------$data-----------------");
          setState(() {});
        }
      });
    });
  }
}