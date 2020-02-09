import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qrreaderapp/src/bloc/scan_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/utils/scan_util.dart' as utils;

import '../pages/direcciones_page.dart';
import '../pages/mapas_page.dart';

import 'package:barcode_scan/barcode_scan.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scansBloc = new ScansBloc();
  int curreentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR SScanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: scansBloc.borrarScanTodos,
          )
        ],
      ),
      body: _callPage(curreentIndex),
      bottomNavigationBar: _crearBottonNovigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: ()=>_scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  _scanQR(BuildContext context) async {
    String futureString = '';

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {
      futureString = e.toString();
    }

    print('Future string: $futureString' );

    if(futureString != null){
      final scan = ScanModel(valor: futureString);
      scansBloc.agregarScan(scan);

      final scan2 = ScanModel(valor: 'geo:40.724233047051705,-74.00731459101564');
      scansBloc.agregarScan(scan2);

      if(Platform.isIOS){
        Future.delayed(Duration(milliseconds: 750), (){
          utils.abrirScan(scan, context);
        });
      }else{
         utils.abrirScan(scan, context);
      }
    }

  }

  Widget _crearBottonNovigationBar() {
    return BottomNavigationBar(
      currentIndex: curreentIndex,
      onTap: (index){
        setState(() {
          curreentIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas')
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_5),
          title: Text('Direcciones')
        ),
      ],
    );
  }

  Widget _callPage(int paginaActual) {
    switch(paginaActual){
      case 0: return MapasPage();
      case 1: return DireccionesPage();
      default: return MapasPage();
    }
  }
}