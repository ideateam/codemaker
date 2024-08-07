


import 'package:shared_preferences/shared_preferences.dart';

/// 存储数据到本地
enum StoreKeys {
  token,
  historyKey,
  themeColorKey
}
enum StoreName{
  name,
}
enum StorePassword{
  password,
  lockPassword,
}

class Store {
  // static StoreKeys storeKeys;
  final SharedPreferences _store;
  static Future<Store> getInstance() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return Store._internal(preferences);
  }

  Store._internal(this._store);

  /// 保存token
  getString(StoreKeys key) async {
    return _store.get(key.toString());
  }

  setString(StoreKeys key, String value) async {
    return _store.setString(key.toString(), value);
  }

  /// 保存用户名
  getNameString(StoreName key) async {
    return _store.get(key.toString());
  }

  setNameString(StoreName key, String value) async {
    return _store.setString(key.toString(), value);
  }

  /// 保存密码

  getPasswordString(StorePassword key) async {
    return _store.get(key.toString());
  }

  setPasswordString(StorePassword key, String value) async {
    return _store.setString(key.toString(), value);
  }

  /// 保存锁屏密码

  getLockPasswordString(StorePassword key) async {
    return _store.get(key.toString());
  }

  setLockPasswordString(StorePassword key, String value) async {
    return _store.setString(key.toString(), value);
  }

  /// 保存主题背景颜色

  getScreenThemeColorString(StoreKeys key) async {
    return _store.get(key.toString());
  }

  setScreenThemeColorString(StoreKeys key, String value) async {
    return _store.setString(key.toString(), value);
  }

  /// 保存历史打开项目记录

  getHistoryListString(StoreKeys key) async {
    return _store.getStringList(key.toString());
  }

  setHistoryListString(StoreKeys key, List<String> value) async {
    return _store.setStringList(key.toString(), value);
  }

  addHistoryPathItem(StoreKeys key,String path) async {

   List<String> historyList = [];

   Future<dynamic> state = getHistoryListString(key);

   state.then((value){
      if(value != null){
        historyList = value;
        if(value.contains(path)){
          //存在
        }else{
          value.insert(0, path);
        }
        print("--1--addHistoryPathItem----$key------$path-----$historyList---");
        _store.setStringList(key.toString(), value);
      }else{
        historyList.insert(0, path);
        print("--2--addHistoryPathItem----$key------$path-----$historyList---");
        _store.setStringList(key.toString(), historyList);
      }
    });
  }

  deleteHistoryPathItem(StoreKeys key,String path) async {

    List<String> historyList = [];
    Future<dynamic> state = getHistoryListString(key);
    state.then((value){
      if(value != null){
        historyList = value;
        if(value.contains(path)){
          //存在
          historyList.remove(path);
          print("--1--addHistoryPathItem----$key------$path-----$historyList---");
          _store.setStringList(key.toString(), historyList);
        }
      }
    });
  }

  remove(StoreKeys key) async {
    return _store.remove(key.toString());
  }

  removelock(StorePassword key) async {
    return _store.remove(key.toString());
  }
}
