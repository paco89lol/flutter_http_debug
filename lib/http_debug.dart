// lib/http_debug/http_debug.dart

export 'common/0_common.dart';
export 'http_debug/data/0_data.dart';

export 'http_debug/http_debug_floating_button.dart';
export 'http_debug/screens/0_screens.dart';

import 'http_debug/data/http_debug_context.dart';
import 'http_debug/data/http_record_entity.dart';

class HttpsDebug {

  static final _instance = HttpsDebug();
  static HttpsDebug get instance => _instance;

  HttpDebugContext _httpsDebugContext = HttpDebugContext(maxLength: 1000);

  int _maxLength = 1000;

  // Setter for the name variable
  set maxLength(int maxLength) {
    _maxLength = maxLength;
    _httpsDebugContext = HttpDebugContext(maxLength: _maxLength);
  }

  int get maxLength => _maxLength;

  HttpDebugContext get httpsDebugContext => _httpsDebugContext;

  void addRecord({required HttpRecordEntity httpRecord}) {
    _httpsDebugContext.circularBufferNotifier.add(httpRecord);
  }
}
