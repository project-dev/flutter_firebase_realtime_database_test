//import 'dart:html';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// ログクラス
class Logger{

  static List<String> logList = [];

  static String _applicationName = "";

  /// ログに出力するアプリ名を設定する
  static void setApplicationName(String applicationName){
    _applicationName = applicationName;
  }

  /// アプリの情報を取得する
  static void _getAppInfo() async {
    if(_applicationName == '' || _applicationName == 'UNKNOWN'){
      try{
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        _applicationName = packageInfo.appName;
      }catch(e){
        _applicationName = 'UNKNOWN';
      }
    }
  }

  /// インフォメーションログを出力する
  static info(String log){
    String stackTrace = StackTrace.current.toString();
    var stackTraceList = stackTrace.split("#1");
    String topStack = stackTraceList.length >= 2 ? stackTrace.split("#1")[1].split("#2")[0] : "";

    _getAppInfo();

    var msg = topStack.isEmpty ?
      "[INFO ][${DateTime.now()}][(UNKNOWN)] $log" :
      "[INFO ][${DateTime.now()}][${topStack.substring(0, topStack.indexOf(")")).trim()}] $log";
    logList.add(msg);
    while(logList.length > 1000){
      logList.removeAt(logList.length - 1);
    }
    //print(msg);
    developer.log(msg,
        name: _applicationName,
    );
  }

  /// デバッグログを出力する
  static debug(String log){
    if(kReleaseMode){
      return;
    }
    String stackTrace = StackTrace.current.toString();
    var stackTraceList = stackTrace.split("#1");
    String topStack = stackTraceList.length >= 2 ? stackTrace.split("#1")[1].split("#2")[0] : "";

    _getAppInfo();

    var msg = topStack.isEmpty ?
      "[DEBUG][${DateTime.now()}][(UNKNOWN)] $log" :
      "[DEBUG][${DateTime.now()}][${topStack.substring(0, topStack.indexOf(")")).trim()}] $log";

    logList.add(msg);
    while(logList.length > 1000){
      logList.removeAt(logList.length - 1);
    }
    //print(msg);
    developer.log(msg,
      name: _applicationName,
    );
  }

  /// 警告ログを出力する
  static warn(String log){
    String stackTrace = StackTrace.current.toString();
    var stackTraceList = stackTrace.split("#1");
    String topStack = stackTraceList.length >= 2 ? stackTrace.split("#1")[1].split("#2")[0] : "";

    _getAppInfo();

    var msg = topStack.isEmpty ?
      "[WARN ][${DateTime.now()}][(UNKNOWN)] $log" :
      "[WARN ][${DateTime.now()}][${topStack.substring(0, topStack.indexOf(")")).trim()}] $log";

    logList.add(msg);
    while(logList.length > 1000){
      logList.removeAt(logList.length - 1);
    }
    //print(msg);
    developer.log(msg,
        name: _applicationName,
    );
  }

  /// エラーログを出力する
  static error(String log, {Object? exception, StackTrace? stacktrace}){
    String? stackTrace = StackTrace.current.toString();
    if(stackTrace.isEmpty){
      stackTrace = null;
    }
    var stackTraceList = stackTrace?.split("#1");
    String? topStack = (stackTraceList?.length ?? 0)  >= 2 ? stackTrace?.split("#1")[1].split("#2")[0] : "";

    _getAppInfo();

    //print("[${DateTime.now()}][${topStack.substring(0, topStack.indexOf(")")).trim()}][ERROR] $log");

    var msg = (topStack?.isEmpty ?? true) ?
      "[ERROR][${DateTime.now()}][(UNKNOWN)] $log" :
      "[ERROR][${DateTime.now()}][${topStack?.substring(0, topStack.indexOf(")")).trim()}] $log";

    logList.add(msg);
    while(logList.length > 1000){
      logList.removeAt(logList.length - 1);
    }

    if(null != exception){
      if(exception is Error){
        Error error = exception;
        stacktrace = error.stackTrace;
/*
      }else if(exception is ProgressEvent){
        ProgressEvent progress = exception;

        exception = "bubbles = ${progress.bubbles}, "
            "cancelable = ${progress.cancelable}, "
            "composed = ${progress.composed}, "
            "currentTarget = ${progress.currentTarget.toString()}, "
            "eventPhase = ${progress.eventPhase}, "
            "isTrusted = ${progress.isTrusted}, "
            "lengthComputable = ${progress.lengthComputable}, "
            "loaded = ${progress.loaded}, "
            "total = ${progress.total}, "
            "type = ${progress.type}, "
            "composedPath = ${progress.composedPath().map<String>((EventTarget e)=> e.toString()).join(",")}, "
            "target = ${progress.target.toString()}";
 */
      }
      developer.log("$msg\n${exception.toString()}",
        name: _applicationName,
        error: exception,
        stackTrace: stacktrace ?? StackTrace.current,
      );

    }else{
      developer.log(msg,
        name: _applicationName,
        stackTrace: stacktrace ?? StackTrace.current,
      );
    }
  }
}