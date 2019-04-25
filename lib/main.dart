import 'package:flutter/material.dart';
import 'package:mobile_dev_challenge/bloc.dart';
import 'package:mobile_dev_challenge/bloc_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenge - MaiDucDuy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<BlocUI>(builder: () => BlocUI(), child: ChallengeUI()),
    );
  }
}

class ChallengeUI extends StatefulWidget {
  @override
  _ChallengeUIState createState() => _ChallengeUIState();
}

class _ChallengeUIState extends State<ChallengeUI> {
  BlocUI _bloc;
  int _indexChoose;

  @override
  void initState() {
    _bloc = BlocProvider.of<BlocUI>(context);
    super.initState();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge - MaiDucDuy'),
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: <Widget>[
            StreamBuilder<ListCard>(
                stream: _bloc.modelStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    ListCard data = snapshot.data;
                    return Column(
                      children: <Widget>[
                        _buildListView(data),
                        _buildContainerDetail(data),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildContainerDetail(ListCard data) {
    return _indexChoose != null
        ? Center(
            child: Container(
              width: 200,
              height: 200,
              child: _buildItem(data.list[_indexChoose], _indexChoose,
                  isDetailContainer: true),
            ),
          )
        : Container();
  }

  Widget _buildListView(ListCard data) {
    return Container(
      width: double.infinity,
      height: 100,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.list.length,
          itemBuilder: (context, index) {
            return _buildItem(data.list[index], index);
          }),
    );
  }

  Widget _buildItem(CardModel model, int index,
      {bool isDetailContainer = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _indexChoose = index;
        });
        if (isDetailContainer) _bloc.incCountCard(index);
      },
      child: Container(
        width: 100,
        height: 100,
        child: Card(
          color: model.color,
          child: Align(
              alignment: Alignment.center,
              child: Text(
                model.count.toString(),
                style: TextStyle(fontSize: 20),
              )),
        ),
      ),
    );
  }
}
