import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mynotes/helpers/loading/loading_screen_controller.dart';
import 'package:mynotes/views/thank_youpage.dart';

class LoadingScreen {
  // singleton
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show ({
    required BuildContext context,
    required String text,
  }){
    if (controller?.update(text) ?? false){
      return;
    }else{
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide () {
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text
  }) {
    final texT = StreamController<String>();
    texT.add(text);
    final state = Overlay.of(context); // this create an overlay state
    


    final overlay = OverlayEntry(
      builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 280,
              maxHeight: 280,
             // minWidth: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0)
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                   mainAxisSize: MainAxisSize.min,
                   mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const LottieAni(),
                  const SizedBox(height: 20),
                  StreamBuilder(
                    stream: texT.stream,
                    builder:(context, snapshot) {
                      if (snapshot.hasData){
                        return Text(
                          snapshot.data as String,
                          textAlign: TextAlign.center,
                        );
                      }else{
                        return Container();
                      }
                    }, 
                  )
                ],
                )
              ),
            ),
          ),
        ),
      );
    },
  );

    state?.insert(overlay); // this add to entire overlay state 

    return LoadingScreenController(
      close: () {
        texT.close();
        overlay.remove();
        return true;
      },
      update: (text) {
        texT.add(text);
        return true;
      },
    );   
  }
}