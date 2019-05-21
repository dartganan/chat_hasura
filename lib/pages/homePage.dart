import 'package:chat_hasura/services/graphQldata.dart';
import 'package:flutter/material.dart';
import 'package:graphql/internal.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String operationName = "teste";
  bool _alive = true;
  // List<Map<String, dynamic>> nomes = List();
  List nomes = List();

  dynamic variables = const <String, dynamic>{};
  bool waitForConnection = false;

  void conectaSocket() async {
    Stream<SubscriptionData> res;
    SocketClient socketClient = SocketClient(
      "ws://dart-hasura.herokuapp.com/v1alpha1/graphql",
    );

    SubscriptionRequest payload = SubscriptionRequest(
      Operation(
        operationName: "teste",
        document: testSubscription,
      ),
    );
    socketClient.connectionState.listen((e) {
      print("STATUS $e");
      if (e == SocketConnectionState.CONNECTED) {
        res = socketClient.subscribe(payload, waitForConnection);
        res.listen((data) {
          print(data.data);
          print(waitForConnection);
        });
      }
    });
    socketClient.onConnectionLost();

    //operationName, testSubscription,variables


/*       final Stream<SubscriptionData> stream = socketClient.subscribe(payload, waitForConnection);

            
            stream.listen((SubscriptionData  data){
             // print(data);
               setState(() {
                List teste = data.toJson()['data']['repositories'] as List;
               nomes = teste;
              //  print('patients: $teste}');
              });
            }); */
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    conectaSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Hasura"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: nomes.length,
          itemBuilder: (BuildContext context, int index) {
            print(nomes[index]['name']);
            return Text("${nomes[index]['name']}");
          },
        ),
      ),
    );
  }
}
