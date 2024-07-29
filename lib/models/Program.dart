
import 'package:flutter/material.dart';


class ProgramInfo {
  final String? svgSrc, title, type ,totalStorage;
  final Color? color;

  ProgramInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.type,
    this.color,
  });
}

List demoMyFiles = [
  ProgramInfo(
    title: "CII Certificate",
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "100 percent",
    color: Colors.green,
    type: 'CII program',
  ),
  ProgramInfo(
    title: "CII Diploma",
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "50 percent",
    color: Colors.red,
    type: 'CII program',
  ),
  ProgramInfo(
    title: "CISI",
    svgSrc: "assets/icons/Documents.svg",
    totalStorage: "0 percent",
    color: Colors.orange,
    type: 'CISI program' ,
  ),

];
