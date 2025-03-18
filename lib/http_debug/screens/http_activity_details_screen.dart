import 'dart:convert';

import 'package:flutter/material.dart';

import '../data/http_record_entity.dart';

class HttpActivityDetailsScreenV1 extends StatelessWidget {
  final HttpRecordEntity httpRecord;

  const HttpActivityDetailsScreenV1({super.key, required this.httpRecord});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text("Details", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Request Info
                Container(
                  color: Colors.grey[900],
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              httpRecord.url,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
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
                SizedBox(height: 16),

                // Request Header
                if (httpRecord.requestHeaders != null &&
                    httpRecord.requestHeaders!.isNotEmpty)
                  _buildSectionTitle("REQUEST HEADER"),
                if (httpRecord.requestHeaders != null &&
                    httpRecord.requestHeaders!.isNotEmpty)
                  _buildStringView(
                    _formattedHeadersString(httpRecord.requestHeaders ?? {}),
                  ),

                // Request Body
                if (httpRecord.requestBody != null && httpRecord.requestBody!.isNotEmpty)
                  _buildSectionTitle("REQUEST"),
                if (httpRecord.requestBody != null && httpRecord.requestBody!.isNotEmpty)
                  _buildStringView(httpRecord.requestBody ?? ""),

                // Response Header
                if (httpRecord.responseHeaders != null)
                  _buildSectionTitle("RESPONSE HEADER"),
                if (httpRecord.responseHeaders != null)
                  _buildStringView(
                    _formattedHeadersString(httpRecord.responseHeaders ?? {}),
                  ),

                // Response Body
                if (httpRecord.responseBody != null && httpRecord.responseBody!.isNotEmpty)
                  _buildSectionTitle("RESPONSE"),
                if (httpRecord.responseBody != null && httpRecord.responseBody!.isNotEmpty)
                  _buildStringView(httpRecord.responseBody ?? ""),

                if (httpRecord.error != null) _buildSectionTitle("ERROR"),
                if (httpRecord.error != null)
                  _buildStringView(httpRecord.error ?? ""),

                if (httpRecord.errorDescription != null)
                  _buildSectionTitle("ERROR DESCRIPTION"),
                if (httpRecord.errorDescription != null)
                  _buildStringView(httpRecord.errorDescription ?? ""),

                // Response size
                if (httpRecord.size != null)
                  _buildSectionTitle("RESPONSE SIZE"),
                if (httpRecord.size != null)
                  _buildStringView(httpRecord.size ?? ""),

                // Response time
                if (httpRecord.duration != null)
                  _buildSectionTitle("TOTAL TIME"),
                if (httpRecord.duration != null)
                  _buildStringView("${httpRecord.duration ?? 0} (s)"),

                // Response mime type
                if (httpRecord.responseMimeType != null)
                  _buildSectionTitle("MIME TYPE"),
                if (httpRecord.responseMimeType != null)
                  _buildStringView("${httpRecord.responseMimeType}"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build section title
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper method to build JSON view
  Widget _buildJsonView(Map<String, dynamic> json) {
    // Pretty-print the JSON using JsonEncoder
    final prettyJson = JsonEncoder.withIndent('  ').convert(json);

    return Container(
      width: double.infinity,
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16.0),
      child: Text(
        prettyJson,
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  // Helper method to build JSON view
  Widget _buildStringView(String string) {
    return Container(
      width: double.infinity,
      color: Colors.grey[900],
      padding: const EdgeInsets.all(16.0),
      child: Text(string, style: TextStyle(color: Colors.white, fontSize: 14)),
    );
  }

  String _formattedHeadersString(Map<String, dynamic> map) {
    String formattedString = map.entries
        .map((entry) {
          return '"${entry.key}": "${entry.value}"';
        })
        .join(',\n');

    return formattedString;
  }
}
