import 'package:flutter/material.dart';
import 'dart:typed_data';

class ExportedDataPage extends StatelessWidget {
  final ByteData? originalImageByteData;
  final ByteData? drawingsByteData;

  ExportedDataPage({
    required this.originalImageByteData,
    required this.drawingsByteData,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exported Data Page'),
      ),
      body: Center(
        child: Stack(
          children: [
            if (originalImageByteData != null)
              Center(
                child: Image.memory(
                  Uint8List.view(originalImageByteData!.buffer),
                ),
              ),
            if (drawingsByteData != null)
              Center(
                child: Image.memory(
                  Uint8List.view(drawingsByteData!.buffer),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
