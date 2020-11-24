import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

class UpgradeDialog extends StatefulWidget {
  final key;
  final version;
  final url;
  final upgradeType;

  UpgradeDialog({
    this.key,
    this.version,
    this.url,
    this.upgradeType,
  });

  @override
  State<StatefulWidget> createState() =>
      new UpgradeDialogState(url: url, upgradeType: upgradeType);
}

class UpgradeDialogState extends State<UpgradeDialog> {
  var _downloadProgress = 0.0;
  final url;
  final upgradeType;
  bool isTempDirInitialized = false;

  UpgradeDialogState({this.url, this.upgradeType});

  @override
  void initState() {
    super.initState();
    initTempDir();
  }

  Future initTempDir() async {
    await DirectoryUtil.initTempDir();
    setState(() {
      isTempDirInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildUpgradeDialogContent();
  }

  Widget _buildUpgradeDialogContent() {
    var _textStyle =
        new TextStyle(color: Theme.of(context).textTheme.body1.color);

    return WillPopScope(
      onWillPop: () async {
        return upgradeType != 2;
      },
      child: new AlertDialog(
        title: new Text(
          "有新的更新",
          style: _textStyle,
        ),
        content: _downloadProgress == 0.0
            ? new Text(
                "版本${widget.version}",
                style: _textStyle,
              )
            : new LinearProgressIndicator(
                value: _downloadProgress,
              ),
        actions: <Widget>[
          new Opacity(
            opacity: isTempDirInitialized ? 1 : 0.5,
            child: new FlatButton(
              child: new Text(
                '更新',
                style: _textStyle,
              ),
              onPressed: isTempDirInitialized ? _upgradeBtnPressed : null,
            ),
          ),
          upgradeType == 2
              ? null
              : new FlatButton(
                  child: new Text('取消'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
        ],
      ),
    );
  }

  void _upgradeBtnPressed() {
    if (_downloadProgress != 0.0) {
      //提示不要重复下载
      Fluttertoast.showToast(
        msg: "正在更新中",
        gravity: ToastGravity.CENTER,
      );
      return;
    }

    //下载apk，完成后打开apk文件，建议使用dio+open_file插件
    String savePath = DirectoryUtil.getTempPath(
        category: "Download", fileName: EncryptUtil.encodeMd5(url) + ".apk");
    if (_downloadProgress == 0.0) {
      downloadApk(url, savePath);
    } else if (_downloadProgress == 1) {
      OpenFile.open(savePath);
    }
  }

  Future<void> downloadApk(String url, String savePath) async {
    try {
      Response response = await Dio().download(url, savePath,
          onReceiveProgress: (int count, int total) {
        LogUtil.v("downloadApk 下载中 ${count} / ${total}");

        _downloadProgress = count / total;
        if (_downloadProgress == 0.0) {
          return;
        } else if (_downloadProgress == 1) {
          OpenFile.open(savePath);
        } else {
          setState(() {});
        }
      });
      LogUtil.v("downloadApk成功 res=" + response.toString());
    } catch (e) {
      LogUtil.e("downloadApk error=" + e.toString());
    }
  }
}
