import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class DownloadingDialog extends StatefulWidget {
  const DownloadingDialog({Key? key}) : super(key: key);

  @override
  _DownloadingDialogState createState() => _DownloadingDialogState();
}

class _DownloadingDialogState extends State<DownloadingDialog> {
  Dio dio = Dio();

  double progress = 0.0;

  void startDownloading() async {
    String url =
        'http://aghasteel.us.tempcloudsite.com/ftp_ledger/0001002923202208.pdf';

    String fileName = 'TV.pdf';

    String path = await _getFilePath(fileName);

    await dio.download(
      url,
      Path,
      onReceiveProgress: (reciveBytes, totalBytes) {
        setState(() {
          progress = reciveBytes / totalBytes;
        });

        print(progress);
      },
      deleteOnError: true,
    ).then((_) {
      Navigator.pop(context);
    });
  }

  Future<String> _getFilePath(String filename) async {
    final dir = await getApplicationDocumentsDirectory();
    return "${dir.path}/$filename";
  }

  @override
  Widget build(BuildContext context) {
    String downloadingprogress = (progress * 100).toInt().toString();
    @override
    void initState() {
      super.initState();
      startDownloading();
    }

    return AlertDialog(
      backgroundColor: Colors.black,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator.adaptive(
            backgroundColor: Colors.white,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Downloading: $downloadingprogress%",
            style: TextStyle(color: Colors.white, fontSize: 17),
          )
        ],
      ),
    );
  }
}
