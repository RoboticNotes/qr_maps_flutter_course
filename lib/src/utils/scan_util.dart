import 'package:url_launcher/url_launcher.dart';

import 'package:qrreaderapp/src/providers/db_provider.dart';

import 'package:flutter/material.dart';

abrirScan(ScanModel scan, BuildContext context) async {

  if(scan.tipo=='http'){
    if (await canLaunch(scan.valor)) {
      await launch(scan.valor);
    } else {
      throw 'No se puede abrir: ${scan.valor}';
    }
  }else{
    Navigator.pushNamed(context, 'mapa', arguments: scan);
  }
}