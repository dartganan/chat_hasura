import 'package:chat_hasura/pages/homePage.dart';
import 'package:chat_hasura/services/graphQldata.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: graphQlObject.client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Chat Hasura',
          home: HomePage(),
        ),
      ),
    );
  }
}
