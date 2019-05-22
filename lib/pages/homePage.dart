import 'dart:async';
import 'dart:convert';

import 'package:chat_hasura/blocs/HomeBloc.dart';
import 'package:chat_hasura/services/graphQldata.dart';
import 'package:chat_hasura/sock/SocketInterface.dart';
import 'package:flutter/material.dart';
import 'package:graphql/internal.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _homeBloc;
  //SocketInterface socketClient;
  //BehaviorSubject<SubscriptionData> b;

  @override
  void initState() {
    super.initState();
    _homeBloc = new HomeBloc();
/*
    b = new BehaviorSubject<SubscriptionData>();

    socketClient = new SocketInterface(
        socketClient: SocketClient(
      "ws://nutranno.herokuapp.com/v1alpha1/graphql",
    ));


    final payload2 = SubscriptionRequest(
      Operation(
        operationName: "teste2",
        document: testSubscription2,
      ),
    );

    socketClient.addRequest(payload2);
    socketClient.request("teste2", b.add);
    */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Hasura"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
        child: StreamBuilder(
          stream: _homeBloc.testFlux,
          builder:
              (BuildContext context, AsyncSnapshot<SubscriptionData> snapshot) {
            print("REBUILDEI");
            if (!snapshot.hasData) 
              return CircularProgressIndicator();
              final String x = jsonEncode(snapshot.data.data);
              return Container(child: Text(x));
            
          },
        ),
      ),
          ),
          Expanded(
            child: Container(
        child: StreamBuilder(
          stream: _homeBloc.testFlux2,
          builder:
              (BuildContext context, AsyncSnapshot<SubscriptionData> snapshot) {
            print("REBUILDEI");
            if (!snapshot.hasData) 
              return CircularProgressIndicator();
              final String x = jsonEncode(snapshot.data.data);
              return Container(child: Text(x));
            
          },
        ),
      ),
          )
        ],
      ),
    );
  }
}
