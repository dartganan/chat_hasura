import 'package:chat_hasura/services/graphQldata.dart';
import 'package:chat_hasura/sock/SocketInterface.dart';
import 'package:graphql/client.dart';
import 'package:graphql/internal.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final socketClient = new SocketInterface(
      socketClient: SocketClient(
    "ws://dart-hasura.herokuapp.com/v1alpha1/graphql",
  ));

  HomeBloc() {
    final payload2 = SubscriptionRequest(
      Operation(
        operationName: "teste2",
        document: testSubscription2,
      ),
    );
    
    final payload = SubscriptionRequest(
      Operation(
        operationName: "teste",
        document: testSubscription,
      ),
    );

    socketClient.addRequest(payload2);
    socketClient.addRequest(payload);
    socketClient.request("teste", testEvent.add);
    socketClient.request("teste2", testEvent2.add);

  }

  final _testController = new BehaviorSubject<SubscriptionData>();
  Observable<SubscriptionData> get testFlux => _testController.stream;
  Sink<SubscriptionData> get testEvent => _testController.sink;
  
  final _testController2 = new BehaviorSubject<SubscriptionData>();
  Observable<SubscriptionData> get testFlux2 => _testController2.stream;
  Sink<SubscriptionData> get testEvent2 => _testController2.sink;

  void dispose() {
    _testController.close();
    _testController2.close();
  }
}
