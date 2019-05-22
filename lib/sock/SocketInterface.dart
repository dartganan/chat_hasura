import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rxdart/rxdart.dart';

class SocketInterface {
  SocketClient socketClient;
  Observable<SocketConnectionState> connectionState;

  final _connections = <String, ConnectionInfo>{};

  static SocketInterface _instance;

  SocketInterface._internal({this.socketClient}) {
    this.connectionState = Observable(socketClient.connectionState);

    connectionState
        .skipWhile((e) =>
            e == SocketConnectionState.CONNECTED ||
            e == SocketConnectionState.CONNECTING)
        .listen((state) {
      print(state);
      if (state == SocketConnectionState.CONNECTED) _reconnect();
    });
  }

  factory SocketInterface({SocketClient socketClient}) {
    if (_instance == null) {
      _instance = SocketInterface._internal(socketClient: socketClient);
    }
    return _instance;
  }

  void _reconnect() {
    _connections.forEach((key, value) {
      value.stream = Observable(
          socketClient.subscribe(value.request, value.awaitForConnection));

      final items = <ListenerInfo>{};

      value.subscriptions.forEach((sub) async {
        final item = ListenerInfo(
            listener: sub.listener,
            subscription: value.stream.listen(sub.listener));
        items.add(item);
        await sub.subscription.cancel();
      });

      value.subscriptions.clear();
      value.subscriptions.addAll(items);
    });
  }

  void addRequest(SubscriptionRequest request) {
    final requestName = request.operation.operationName;

    final stream =
        Observable((socketClient.subscribe(request, true)).asBroadcastStream());

    final connectionInfo = new ConnectionInfo(
      stream: stream,
      request: request,
      awaitForConnection: true,
    );

    _connections[requestName] = connectionInfo;
  }

  void request(String requestName, Function(SubscriptionData) f) {
    final connectionInfo = _connections[requestName];

    final listenerInfo = ListenerInfo(
      listener: f,
      subscription: connectionInfo.stream.listen(f),
    );

    connectionInfo.subscriptions.add((listenerInfo));
  }

  void removeRequest(String requestName) {
    _connections.remove(requestName);
  }

  void dispose() {
    socketClient.dispose();
    _instance = null;
  }
}

class ConnectionInfo {
  Observable<SubscriptionData> stream;
  final SubscriptionRequest request;
  final bool awaitForConnection;
  Set<ListenerInfo> subscriptions = <ListenerInfo>{};
  int get listenerNumber => subscriptions.length;

  ConnectionInfo({this.stream, this.request, this.awaitForConnection});
}

class ListenerInfo {
  StreamSubscription<SubscriptionData> subscription;
  Function(SubscriptionData subscription) listener;

  ListenerInfo({this.subscription, this.listener});
}
