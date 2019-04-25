import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BlocUI extends BaseBloc {
  final _modelController = PublishSubject<ListCard>();
  ListCard _list = ListCard();
  List _colors = [
    Colors.blue,
    Colors.deepPurple,
    Colors.greenAccent,
    Colors.redAccent
  ];
  Random random = new Random();

  Observable<ListCard> get modelStream => _modelController.stream;

  BlocUI() {
    loadData();
  }

  void loadData() async {
    print('BlocUI.loadData');
    List<CardModel> temp = await initAndAddList();
    await addData(temp);
  }

  Future<List<CardModel>> initAndAddList() async {
    print('BlocUI.initAndAddList');
    List<CardModel> temp = List();
    temp = new List<CardModel>.generate(10, (i) {
      return CardModel(color: _colors[random.nextInt(3)], count: 0);
    });
    return temp;
  }

  Future<void> addData(List<CardModel> temp) async {
    _list = ListCard(list: temp);
    _modelController.sink.add(_list);
  }

  void dispose() {
    print('BlocUI.dispose');
    _modelController.close();
  }

  void incCountCard(int index) {
    print('BlocUI.incCountCard');
    _list.list[index].incCount();
    _modelController.sink.add(_list);
  }
}

class ListCard {
  List<CardModel> list;

  ListCard({this.list});
}

class CardModel {
  Color color;
  int count;

  CardModel({this.color, this.count});

  void incCount() {
    count++;
  }
}

abstract class BaseBloc {
  ///Called if the BlocProvider gets disposed
  void dispose() {}
}
