// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:codemaker/common.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:open_file/open_file.dart';
// import 'package:path/path.dart' as p;
// // import 'package:intl/intl.dart';
//
// import 'route_style.dart';
//
// /// 点击一个文件夹，传入文件夹的路径，显示该文件夹下的文件和文件夹
// /// 点击一个文件，打开
// /// 返回上一层，返回上一层目录路径 [dir.parent.path]
// class FileManager extends StatefulWidget {
//   const FileManager({required this.currentDirPath});
//
//   final String currentDirPath; // 当前路径
//
//   @override
//   _FileManagerState createState() => _FileManagerState();
// }
//
// class _FileManagerState extends State<FileManager> {
//   List<FileSystemEntity> currentFiles = []; // 当前路径下的文件夹和文件
//
//   @override
//   void initState() {
//     super.initState();
//     getCurrentPathFiles(widget.currentDirPath);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.currentDirPath == Common().rootPath ? 'SD Card' : p.basename(widget.currentDirPath),
//           style: const TextStyle(color: Colors.black),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color(0xffeeeeee),
//         elevation: 0.0,
//         leading: widget.currentDirPath == Common().rootPath
//             ? Container()
//             : IconButton(
//                 icon: const Icon(Icons.chevron_left, color: Colors.black),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//               ),
//       ),
//       body: currentFiles.isEmpty
//           ? const Center(child: Text('The folder is empty'))
//           : Scrollbar(
//               child: ListView(
//               physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
//               children: currentFiles.map((e) {
//                 if (FileSystemEntity.isFileSync(e.path)) {
//                   return _buildFileItem(e);
//                 } else {
//                   return _buildFolderItem(e);
//                 }
//               }).toList(),
//             )
//       ),
//     );
//   }
//
//   Widget _buildFileItem(FileSystemEntity file) {
//     // String modifiedTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN').format(file.statSync().modified.toLocal());
//
//     String modifiedTime = "";
//
//     return InkWell(
//       child: Container(
//         decoration: const BoxDecoration(
//           border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5))),
//         ),
//         child: ListTile(
//           leading: _buildImage(file.path),
//           title: Text(file.path.substring(file.parent.path.length + 1)),
//           subtitle: Text('$modifiedTime  ${Common().getFileSize(file.statSync().size)}', style: const TextStyle(fontSize: 12.0)),
//         ),
//       ),
//       onTap: () {
//         if ('.jpeg.jpg.png'.contains(p.extension(file.path.toLowerCase()))) {
//           var imgList = [];
//           for (var element in currentFiles) {
//             if ('.jpeg.jpg.png'.contains(p.extension(element.path.toLowerCase()))) {
//               imgList.add(element.path);
//             }
//           }
//           int index = imgList.indexOf(file.path);
//           Navigator.push(context, Scale(ImageView(imageList: imgList, index: index, key: null,), duration: const Duration(seconds: 1)));
//         } else {
//           OpenFile.open(file.path);
//         }
//       },
//       onLongPress: () {
//         showModalBottomSheet(
//           context: context,
//           builder: (_) => _buildModalBottomSheet(file),
//         );
//       },
//     );
//   }
//
//   Widget _buildImage(String path) {
//     path = path.toLowerCase();
//     switch (p.extension(path)) {
//       case '.jpg':
//       case '.jpeg':
//       case '.png':
//         return Image.file(
//           File(path),
//           width: 40.0,
//           height: 40.0,
//           // 解决加载大量本地图片可能会使程序崩溃的问题
//           cacheHeight: 90,
//           cacheWidth: 90,
//           fit: BoxFit.cover,
//           filterQuality: FilterQuality.none,
//         );
//       default:
//         return Image.asset(Common().selectIcon(p.extension(path)), width: 40.0, height: 40.0);
//     }
//   }
//
//   Widget _buildFolderItem(FileSystemEntity file) {
//     // String modifiedTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN').format(file.statSync().modified.toLocal());
//     String modifiedTime = "";
//
//     return InkWell(
//       child: Container(
//         decoration: const BoxDecoration(
//           border: Border(bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5))),
//         ),
//         child: ListTile(
//           leading: Image.asset('images/folder.png'),
//           title: Row(
//             children: <Widget>[
//               Expanded(child: Text(file.path.substring(file.parent.path.length + 1))),
//               Text(
//                 '${_calculateFilesCountByFolder(Directory(file.path))}项',
//                 style: const TextStyle(color: Colors.grey),
//               )
//             ],
//           ),
//           subtitle: Text(modifiedTime, style: const TextStyle(fontSize: 12.0)),
//           trailing: const Icon(Icons.chevron_right),
//         ),
//       ),
//       onTap: () {
//         Navigator.push(context, Fade(FileManager(currentDirPath: file.path), duration: const Duration(seconds: 1)));
//       },
//       onLongPress: () {
//         showModalBottomSheet(
//           context: context,
//           builder: (_) => _buildModalBottomSheet(file),
//         );
//       },
//     );
//   }
//
//   Widget _buildModalBottomSheet(FileSystemEntity file) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: <Widget>[
//         CupertinoButton(
//           pressedOpacity: 0.6,
//           child: const Text('重命名', style: TextStyle(color: Color(0xff333333))),
//           onPressed: () {
//             Navigator.pop(context);
//             renameFile(file);
//           },
//         ),
//         const Divider(height: 1.0),
//         CupertinoButton(
//           pressedOpacity: 0.6,
//           child: const Text('删除', style: TextStyle(color: Color(0xff333333))),
//           onPressed: () {
//             Navigator.pop(context);
//             deleteFile(file);
//           },
//         ),
//       ],
//     );
//   }
//
//   // 计算以 . 开头的文件、文件夹总数
//   int _calculatePointBegin(List<FileSystemEntity> fileList) {
//     int count = 0;
//     for (var v in fileList) {
//       if (p.basename(v.path).substring(0, 1) == '.') count++;
//     }
//
//     return count;
//   }
//
//   // 计算文件夹内 文件、文件夹的数量，以 . 开头的除外
//   int _calculateFilesCountByFolder(Directory path) {
//     var dir = path.listSync();
//     int count = dir.length - _calculatePointBegin(dir);
//
//     return count;
//   }
//
//   // 获取当前路径下的文件/文件夹
//   void getCurrentPathFiles(String path) {
//     try {
//       Directory currentDir = Directory(path);
//       List<FileSystemEntity> _files = [];
//       List<FileSystemEntity> _folder = [];
//
//       // 遍历所有文件/文件夹
//       for (var v in currentDir.listSync()) {
//         // 去除以 .开头的文件/文件夹
//         if (p.basename(v.path).substring(0, 1) == '.') {
//           continue;
//         }
//         if (FileSystemEntity.isFileSync(v.path)) {
//           _files.add(v);
//         } else {
//           _folder.add(v);
//         }
//       }
//
//       // 排序
//       _files.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
//       _folder.sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
//
//       currentFiles.clear();
//       currentFiles.addAll(_folder);
//       currentFiles.addAll(_files);
//     } catch (e) {
//       print(e);
//       print("Directory does not exist！");
//     }
//   }
//
//   // 删除文件
//   void deleteFile(FileSystemEntity file) {
//     showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: const Text('确认删除？'),
//           content: const Text('删除后不可恢复'),
//           actions: <Widget>[
//             CupertinoDialogAction(
//               child: const Text('取消', style: TextStyle(color: Colors.blue)),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             CupertinoDialogAction(
//               child: const Text('确定', style: TextStyle(color: Colors.red)),
//               onPressed: () {
//                 try {
//                   if (file.statSync().type == FileSystemEntityType.directory) {
//                     Directory directory = Directory(file.path);
//                     directory.deleteSync(recursive: true);
//                   } else if (file.statSync().type == FileSystemEntityType.file) {
//                     file.deleteSync();
//                   }
//                   getCurrentPathFiles(file.parent.path);
//                 } on FileSystemException catch (e) {
//                   Fluttertoast.showToast(msg: e.message, gravity: ToastGravity.CENTER);
//                 }
//
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // 重命名
//   void renameFile(FileSystemEntity file) {
//     TextEditingController _controller = TextEditingController();
//
//     showCupertinoDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Center(
//             child: CupertinoAlertDialog(
//               title: const Text('重命名'),
//               content: Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: TextField(
//                   controller: _controller,
//                   decoration: InputDecoration(
//                     focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
//                     hintText: '请输入新名称',
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
//                     contentPadding: const EdgeInsets.all(10.0),
//                   ),
//                 ),
//               ),
//               actions: <Widget>[
//                 CupertinoDialogAction(
//                   child: const Text('取消', style: TextStyle(color: Colors.blue)),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                 ),
//                 CupertinoDialogAction(
//                   child: const Text('确定', style: TextStyle(color: Colors.blue)),
//                   onPressed: () async {
//                     String newName = _controller.text;
//                     if (newName.trim().isEmpty) {
//                       Fluttertoast.showToast(msg: '名字不能为空', gravity: ToastGravity.CENTER);
//                       return;
//                     }
//
//                     String newPath = file.parent.path + '/' + newName + p.extension(file.path);
//                     file.renameSync(newPath);
//                     getCurrentPathFiles(file.parent.path);
//
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
// }
//
// class ImageView extends StatelessWidget {
//   const ImageView({Key? key, required this.index, required this.imageList}) : super(key: key);
//
//   final int index;
//   final List imageList;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: PageController(initialPage: index),
//         children: imageList.map((e) => Image.file(File(e))).toList(),
//       ),
//     );
//   }
// }
