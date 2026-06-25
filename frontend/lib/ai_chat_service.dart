import 'api_client.dart';
import 'models/ai_models.dart';

/// Service untuk komunikasi dengan AI Chatbot API
class AiChatService {
  AiChatService(this._client);

  final ApiClient _client;
  String? _sessionId;

  String? get sessionId => _sessionId;

  /// Kirim pesan ke AI dan dapatkan balasan
  Future<ChatMessage> sendMessage(String message) async {
    final body = <String, dynamic>{'message': message};
    if (_sessionId != null) {
      body['session_id'] = _sessionId;
    }

    final response = await _client.post('/api/ai/chat', body: body);

    if (response['status'] == true) {
      final data = response['data'];
      _sessionId = data['session_id'];
      return ChatMessage(
        role: 'assistant',
        content: data['reply'] ?? '',
        timestamp: DateTime.now(),
      );
    }

    throw ApiException(response['message'] ?? 'AI service error');
  }

  Future<List<ChatMessage>> getChatHistory({String? sessionId}) async {
    final query = sessionId ?? _sessionId;
    final path = query == null
        ? '/api/ai/chat/history'
        : '/api/ai/chat/history?session_id=${Uri.encodeComponent(query)}';
    final response = await _client.get(path);

    if (response['status'] == true) {
      final history = (response['data'] as List? ?? [])
          .whereType<Map>()
          .map(
            (item) => ChatMessage.fromHistoryJson(item.cast<String, dynamic>()),
          )
          .toList();
      if (history.isNotEmpty) {
        _sessionId = history.last.sessionId ?? _sessionId;
      }
      return history;
    }

    throw ApiException(response['message'] ?? 'Chat history error');
  }

  /// Ambil data restock (tanpa LLM, raw JSON yang sudah dipetakan ke model)
  Future<RestockAnalysis> getRestockAnalysis() async {
    final response = await _client.get('/api/ai/restock');
    if (response['status'] == true) {
      return RestockAnalysis.fromJson(
        (response['data'] as Map).cast<String, dynamic>(),
      );
    }
    throw ApiException(response['message'] ?? 'Restock analysis error');
  }

  /// Reset sesi percakapan (mulai percakapan baru)
  void resetSession() {
    _sessionId = null;
  }
}
