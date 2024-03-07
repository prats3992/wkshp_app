// ignore_for_file: prefer_const_constructors

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

import 'package:share_plus/share_plus.dart';

class CardPage extends StatelessWidget {
  CardPage({super.key, required this.name, required this.birthDay});

  final DateTime birthDay;
  final String name;

  final GlobalKey genKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    var myWidth = MediaQuery.of(context).size.width - 20;
    int ageYears = (DateTime.now().year - birthDay.year);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text("Birthday Card Generator"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: RepaintBoundary(
                key: genKey,
                child: Stack(
                  children: [
                    SizedBox(
                      height: myWidth,
                      width: myWidth,
                      child: Container(
                        color: Colors.pink.shade400,
                      ),
                    ),
                    Positioned(
                        top: 100,
                        left: 10,
                        child: Text(
                          "Happy Birthday",
                          style: TextStyle(
                              fontSize: 25.0, color: Colors.blue.shade900),
                        )),
                    Positioned(
                        top: 135,
                        left: 10,
                        child: Text(
                          name,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold),
                        )),
                        Positioned(
                        top: 165,
                        left: 10,
                        child: Text(
                          "You are $ageYears years old",
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.blue.shade900,),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text("Share Card"),
              onPressed: () async {
                RenderRepaintBoundary? boundary = genKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;

                if (boundary == null) {
                  return;
                }

                ui.Image image = await boundary.toImage(pixelRatio: 4.0);
                ByteData? bytes = await image.toByteData(format: ui.ImageByteFormat.png);
                Uint8List actualImage = bytes!.buffer.asUint8List();
                
                Directory tempDir = await Directory.systemTemp.createTemp();
                File file = File('${tempDir.path}/image.png');
                await file.writeAsBytes(actualImage);

                await Share.shareXFiles([XFile("${tempDir.path}/image.png")]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
