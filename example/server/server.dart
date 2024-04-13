import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

const formatter = JsonEncoder.withIndent('  ');

void main() {
  final app = Router();
  // capture all routes start with '/mirror'
  app.all('/mirror/<path|.*>', (Request request, String path) {
    print('You requested: $path');

    final String body = '''
method:${request.method}
uri:${request.requestedUri}
path:${request.url.path}
pathSegments:${formatter.convert(request.url.pathSegments)}
query:${request.url.query}
queryParameters:${formatter.convert(request.url.queryParameters)}
queryParametersAll:${formatter.convert(request.url.queryParametersAll)}
headers:${formatter.convert(request.headers)}
body:${formatter.convert(request.readAsString())}
''';

    return Response.ok(body);
  });

  io.serve(app, '0.0.0.0', 10086);

  print('Serving at http://localhost:10086');
}
