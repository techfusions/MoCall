import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saw/Page/HomePage.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewScreen extends StatefulWidget {
  const PDFViewScreen({super.key, required this.title, required this.url});
  final String title;
  final String url;
  @override
  State<PDFViewScreen> createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  double? _progress;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFFF0000),
            title: Row(
              children: [
                SizedBox(),
                Icon(
                  FontAwesomeIcons.filePdf,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  widget.title,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          body: FutureBuilder<String>(
            future: _reloadPdf(widget.url),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                return SfPdfViewer.file(File(snapshot.data!));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    FontAwesomeIcons.home,
                    color: Color(0xFF1877F2),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => HomePage()),
                        (route) => false);
                  }),
              SizedBox(
                height: 10,
              ),
              FloatingActionButton(
                  backgroundColor: Colors.white,
                  tooltip: 'Download PDF',
                  child: _progress != null
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Color(0xFF1877F2), size: 30.0)
                      : Icon(
                          FontAwesomeIcons.download,
                          color: Color(0xFF1877F2),
                        ),
                  onPressed: () {
                    // file downloader function area
                    FileDownloader.downloadFile(
                        url: '${widget.url}',
                        onProgress: (name, progress) {
                          setState(() {
                            _progress = progress;
                          });
                        },
                        onDownloadCompleted: (value) {
                          print('path  $value ');
                          setState(() {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.bottomSlide,
                              title: 'Download Complete',
                              desc: 'The PDF has been downloaded successfully.',
                              btnOkOnPress: () {},
                            )..show();
                            _progress = null;
                          });
                        });

                    // end downloader function area
                  }),
            ],
          )),
    );
  }
}

Future<String> _reloadPdf(String url) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/${url.split('/').last}';
  final file = File(filePath);

  if (!file.existsSync()) {
    // ignore: unused_local_variable
    final response = await Dio().download(url, filePath);
  }

  return filePath;
}
