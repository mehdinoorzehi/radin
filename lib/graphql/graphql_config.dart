import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static final HttpLink httpLink = HttpLink(
    'https://renewing-hawk-97.hasura.app/v1/graphql',
    defaultHeaders: {
      'x-hasura-admin-secret': 'Hapoooli@20290',
    },
  );

  static final WebSocketLink websocketLink = WebSocketLink(
    'wss://renewing-hawk-97.hasura.app/v1/graphql',
    config: const SocketClientConfig(
      autoReconnect: true,
      inactivityTimeout: Duration(seconds: 30),
      headers: {
        'x-hasura-admin-secret': 'Hapoooli@20290',
      },
    ),
  );

  static final Link link = Link.split(
    (request) => request.isSubscription,
    websocketLink,
    httpLink,
  );

  static GraphQLClient client() {
    return GraphQLClient(
      cache: GraphQLCache(),
      link: link,
    );
  }
}
