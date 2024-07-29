
import 'package:flutter/material.dart';

import '../constants.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "(Wo1 Award in General Insurance)",
    numOfFiles: 1328,
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "100 percent",
    color: primaryColor,
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Underwriting Procedure)",
    numOfFiles: 1328,
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "50 percent",
    color: primaryColor,
    percentage: 50,
  ),
  CloudStorageInfo(
    title: "Claims procedure",
    numOfFiles: 1328,
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "0 percent",
    color: primaryColor,
    percentage: 0 ,
  ),

];
