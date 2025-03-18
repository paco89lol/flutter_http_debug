import 'package:flutter/material.dart';

import '../data/0_data.dart';
import '../data/http_debug_context.dart';
import 'http_activity_details_screen.dart';

/// https Inspector Widget to display records
class HttpDebugScreen extends StatefulWidget {
  final HttpDebugContext httpDebugContext;
  final VoidCallback? toggleInspector;

  const HttpDebugScreen({
    super.key,
    this.toggleInspector,
    required this.httpDebugContext,
  });

  @override
  HttpDebugScreenState createState() => HttpDebugScreenState();
}

class HttpDebugScreenState extends State<HttpDebugScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    if (widget.httpDebugContext.circularBufferNotifier.buffer.length > 0) {
      // Scroll to the bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 1),
          curve: Curves.easeOut,
        );
      });
    }

    super.initState();
  }

  // Function to check if the user is at the bottom of the list
  bool _isAtBottom() {
    if (!_scrollController.hasClients) return false;
    return _scrollController.offset >=
        _scrollController.position.maxScrollExtent;
  }

  // Function to check if the user is at the bottom of the list
  // bool _isAtTop() {
  //   if (!_scrollController.hasClients) return false;
  //   return _scrollController.offset <=
  //       _scrollController.position.minScrollExtent;
  // }

  // Function to scroll to the bottom
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // Function to scroll to the bottom
  void _scrollToTop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leadingWidth: 100,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.close, size: 30),
              color: Colors.green,
              onPressed: () {
                if (widget.toggleInspector != null) {
                  widget.toggleInspector!();
                }
              },
            ),
            IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              icon: const Icon(Icons.vertical_align_top_rounded),
              color: Colors.green,
              onPressed: () {
                _scrollToTop();
              },
              tooltip: 'scroll to top',
            ),
          ],
        ),
        title: Text(
          "[${widget.httpDebugContext.circularBufferNotifier.buffer.length}]",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: const Icon(Icons.vertical_align_bottom_rounded),
            color: Colors.green,
            onPressed: () {
              _scrollToBottom();
            },
            tooltip: 'scroll to bottom',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline), // Clear record icon
            color: Colors.green,
            onPressed: () {
              widget.httpDebugContext.circularBufferNotifier
                  .clear(); // Clear all records
            },
            tooltip: 'Clear Records',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.httpDebugContext.circularBufferNotifier,
        builder: (content, _) {
          // if (_isAtBottom()) {
          //   _scrollToBottom();
          // }

          final circularBuffer =
              widget.httpDebugContext.circularBufferNotifier.buffer;
          final listOfLog = circularBuffer.toList();
          return circularBuffer.isEmpty
              ? const Center(
                child: Text(
                  'No Records available.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              )
              : Scrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: ScrollConfiguration(
                  behavior: NoGlowScrollBehavior(),
                  child: ListView.builder(
                    shrinkWrap: true,
                    controller: _scrollController,
                    itemCount: circularBuffer.length,
                    itemBuilder: (context, index) {
                      final httpRecord = listOfLog[index];
                      return _buildHttpRecordView(index + 1, httpRecord);
                    },
                  ),
                ),
              );
        },
      ),
    );
  }

  Widget _buildHttpRecordView(int position, HttpRecordEntity httpRecord) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: InkWell(
        splashColor: Colors.transparent,    // Disable ripple
        highlightColor: Colors.transparent, // Disable highlight
        onTapUp: (detail) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (_) => HttpActivityDetailsScreenV1(httpRecord: httpRecord),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 20, minWidth: 20),
              child: Text(
                "$position",
                style: TextStyle(
                  color: Colors.white,
                  fontSize:
                      (position.toString().length > 2)
                          ? (position.toString().length > 3)
                              ? 10
                              : 12
                          : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "[${httpRecord.method.toUpperCase()}]",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "${httpRecord.requestCreatedAt}",
                        style: TextStyle(color: Colors.green, fontSize: 16),
                      ),
                    ],
                  ),
                  Text(
                    httpRecord.url,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
            Text(
              "${httpRecord.responseCode ?? ""}",
              style: TextStyle(
                color:
                    (httpRecord.responseCode != null &&
                            httpRecord.responseCode! >= 200 &&
                            httpRecord.responseCode! < 300)
                        ? Colors.green
                        : (httpRecord.responseCode != null &&
                            httpRecord.responseCode! >= 300 &&
                            httpRecord.responseCode! < 400)
                        ? Colors.orange
                        : Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child; // Remove any overscroll effects
  }
}
