

import '../../common/circular_buffer_notifier.dart';
import 'http_record_entity.dart';

class HttpDebugContext {

  final int maxLength;
  final CircularBufferNotifier<HttpRecordEntity> circularBufferNotifier;

  HttpDebugContext({required this.maxLength})
      : circularBufferNotifier = CircularBufferNotifier(maxLength: maxLength);

}