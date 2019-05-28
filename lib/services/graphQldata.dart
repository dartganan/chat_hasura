import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';



class GraphQlObject {

  
  static HttpLink httpLink = HttpLink(
    uri: 'https://nutranno.herokuapp.com/v1alpha1/graphql',
  );
  //static AuthLink authLink = AuthLink();
  static Link link = httpLink as Link;
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      cache: NormalizedInMemoryCache(
      dataIdFromObject: typenameDataIdFromObject,
    ),
      link: link,
    ),
  );
}

String typenameDataIdFromObject(Object object) {

  print("${object}");
  print("Testeeeee");
  if (object is Map<String, Object> &&
      object.containsKey('__typename') &&
      object.containsKey('id')) {
    return "${object['__typename']}/${object['id']}";
  }
  return null;
}

GraphQlObject graphQlObject = new GraphQlObject();

String toggleIsCompletedMutation(result, index) {
  return ("""mutation ToggleTask{
                                     update_todo(where: {id: {_eq: ${result.data["todo"][index]["id"]}}}, _set: {isCompleted: ${!result.data["todo"][index]["isCompleted"]}}) {
                                      returning {
                                        isCompleted
                                      }
                                    }
                                }""");
}

String deleteTaskMutation(result, index) {
  return ("""mutation DeleteTask{       
                                  delete_todo(where: {id: {_eq: ${result.data["todo"][index]["id"]}}}) {
                                    returning {
                                      id
                                    }
                                  }
                                }""");
}

String addTaskMutation(task) {
  return ("""mutation AddTask{
                                                  insert_todo(objects: {isCompleted: false, task: "$task"}) {
                                                    returning {
                                                      id
                                                    }
                                                  }
                                      }""");
}

String fetchQuery() {
  return ("""query TodoGet{
                                                  todo {
                                                    id
                                                    isCompleted
                                                    task
                                                  }
                                                }
                                          """);
}

const String query = r'''
		query teste3{
  categorias {
    nome
    produtos {
      id
    }
  }
}

''';

const String testSubscription = r'''
		subscription teste{
   categorias {
    
    id,
    nome
  }
}

''';

const String testSubscription2 = r'''
		subscription teste2{
  produtos {
    id
    name
  }
}

''';
