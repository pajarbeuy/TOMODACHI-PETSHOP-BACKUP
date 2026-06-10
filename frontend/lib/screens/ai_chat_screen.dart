import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ai_chat_service.dart';
import '../models/ai_models.dart';

class AiChatScreen extends StatefulWidget {
  final AiChatService chatService;

  const AiChatScreen({super.key, required this.chatService});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _showRestockPanel = false;
  RestockAnalysis? _restockData;
  bool _restockLoading = false;

  // Suggested questions
  final List<String> _suggestions = [
    'Produk mana yang harus direstock?',
    'Berapa total penjualan bulan ini?',
    'Produk apa yang paling laris?',
    'Analisis performa stok saya',
    'Berikan insight bisnis terkini',
  ];

  // Color palette
  static const _bg = Color(0xFF0F1117);
  static const _surface = Color(0xFF1A1D27);
  static const _card = Color(0xFF212435);
  static const _accent = Color(0xFFFFB570);
  static const _accentDark = Color(0xFFFF9A4D);
  static const _userBubble = Color(0xFFFF9A4D);
  static const _aiBubble = Color(0xFF2A2D3E);
  static const _textPrimary = Color(0xFFF0EEF5);
  static const _textSecondary = Color(0xFF9896A4);
  static const _divider = Color(0xFF2E3145);

  TextStyle _font({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    Color color = _textPrimary,
    double height = 1.5,
  }) => GoogleFonts.plusJakartaSans(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
  );

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
    _loadChatHistory();
  }

  void _addWelcomeMessage() {
    _messages.add(_welcomeMessage());
  }

  ChatMessage _welcomeMessage() {
    return ChatMessage(
      role: 'assistant',
      content:
          'Halo! Saya **Tommi** 🐾, asisten AI Tomodachi Pet Shop.\n\n'
          'Saya siap membantu kamu menganalisis:\n'
          '• 📦 Status stok & rekomendasi restock\n'
          '• 💰 Laporan penjualan & pendapatan\n'
          '• 🏆 Performa produk terlaris\n'
          '• 📊 Insight bisnis petshop\n\n'
          'Ada yang bisa saya bantu?',
      timestamp: DateTime.now(),
    );
  }

  Future<void> _loadChatHistory() async {
    try {
      final history = await widget.chatService.getChatHistory();
      if (!mounted || history.isEmpty) return;
      setState(() {
        _messages
          ..clear()
          ..addAll(history);
      });
      _scrollToBottom(animated: false);
    } catch (_) {
      // Riwayat chat bukan fitur blocking; user tetap bisa mulai chat baru.
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  Future<void> _sendMessage([String? override]) async {
    final text = (override ?? _inputController.text).trim();
    if (text.isEmpty || _isLoading) return;

    _inputController.clear();

    setState(() {
      _messages.add(
        ChatMessage(role: 'user', content: text, timestamp: DateTime.now()),
      );
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final reply = await widget.chatService.sendMessage(text);
      if (!mounted) return;
      setState(() {
        _messages.add(reply);
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            role: 'assistant',
            content: _formatChatError(e),
            timestamp: DateTime.now(),
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    }

    _focusNode.requestFocus();
  }

  String _formatChatError(Object error) {
    final message = error.toString();
    final needsConfigHint =
        message.contains('OPENROUTER_API_KEY') ||
        message.contains('API key tidak dikonfigurasi');

    if (needsConfigHint) {
      return '⚠️ Terjadi kesalahan: $message\n\n'
          'Pastikan OPENROUTER_API_KEY sudah dikonfigurasi di backend.';
    }

    return '⚠️ Terjadi kesalahan: $message';
  }

  Future<void> _loadRestockData() async {
    setState(() {
      _restockLoading = true;
      _showRestockPanel = true;
    });
    try {
      final data = await widget.chatService.getRestockAnalysis();
      if (!mounted) return;
      setState(() {
        _restockData = data;
        _restockLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _restockLoading = false;
        _restockData = null;
      });
    }
  }

  void _resetChat() {
    widget.chatService.resetSession();
    setState(() {
      _messages.clear();
      _showRestockPanel = false;
      _restockData = null;
    });
    _addWelcomeMessage();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth >= 900;

    return Container(
      color: _bg,
      child: isWide
          ? Row(
              children: [
                // Chat Panel
                Expanded(flex: 3, child: _buildChatPanel()),
                // Restock side panel (wide screen)
                Container(
                  width: 340,
                  decoration: const BoxDecoration(
                    color: _surface,
                    border: Border(left: BorderSide(color: _divider, width: 1)),
                  ),
                  child: _buildRestockSidePanel(),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(child: _buildChatPanel()),
                if (_showRestockPanel)
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: _buildRestockSidePanel(),
                  ),
              ],
            ),
    );
  }

  // ── Chat Panel ────────────────────────────────────────────────────────────

  Widget _buildChatPanel() {
    return Column(
      children: [
        _buildChatHeader(),
        Expanded(child: _buildMessageList()),
        if (_messages.length <= 1) _buildSuggestions(),
        _buildInputBar(),
      ],
    );
  }

  Widget _buildChatHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(bottom: BorderSide(color: _divider)),
      ),
      child: Row(
        children: [
          // Tommi avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB570), Color(0xFFFF6B35)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('🐾', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tommi AI Assistant',
                  style: _font(
                    size: 15,
                    weight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4ADE80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Online • Powered by OpenRouter',
                      style: _font(size: 11, color: _textSecondary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Restock button
          _headerBtn(
            icon: Icons.inventory_2_outlined,
            label: 'Restock',
            onTap: _loadRestockData,
            active: _showRestockPanel,
          ),
          const SizedBox(width: 8),
          // Reset button
          _headerBtn(
            icon: Icons.refresh_rounded,
            label: 'Reset',
            onTap: _resetChat,
          ),
        ],
      ),
    );
  }

  Widget _headerBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool active = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: active ? _accent.withOpacity(0.15) : _card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? _accent.withOpacity(0.5) : _divider,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: active ? _accent : _textSecondary),
            const SizedBox(width: 5),
            Text(
              label,
              style: _font(
                size: 12,
                weight: FontWeight.w600,
                color: active ? _accent : _textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == _messages.length) return _buildTypingIndicator();
        return _buildMessageBubble(_messages[i]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    final isUser = msg.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFB570), Color(0xFFFF6B35)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text('🐾', style: TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: msg.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Pesan disalin',
                      style: _font(size: 13, color: Colors.white),
                    ),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 1),
                    backgroundColor: _card,
                  ),
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isUser ? _userBubble : _aiBubble,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _buildMessageText(msg.content, isUser: isUser),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person, size: 18, color: _accent),
            ),
          ],
        ],
      ),
    );
  }

  /// Render teks dengan bold markdown (**text**) dan bullet (•)
  Widget _buildMessageText(String content, {required bool isUser}) {
    final textColor = isUser ? Colors.white : _textPrimary;
    final spans = <InlineSpan>[];
    final lines = content.split('\n');

    for (int lineIdx = 0; lineIdx < lines.length; lineIdx++) {
      final line = lines[lineIdx];
      if (lineIdx > 0) spans.add(const TextSpan(text: '\n'));

      // Parse **bold** inline
      final parts = line.split(RegExp(r'\*\*'));
      for (int i = 0; i < parts.length; i++) {
        if (parts[i].isEmpty) continue;
        if (i % 2 == 1) {
          // bold
          spans.add(
            TextSpan(
              text: parts[i],
              style: _font(
                size: 13.5,
                weight: FontWeight.w700,
                color: isUser ? Colors.white : _accent,
              ),
            ),
          );
        } else {
          spans.add(
            TextSpan(
              text: parts[i],
              style: _font(size: 13.5, color: textColor),
            ),
          );
        }
      }
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFB570), Color(0xFFFF6B35)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🐾', style: TextStyle(fontSize: 14)),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _aiBubble,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: _TypingDots(),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return Container(
      color: _bg,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              'Pertanyaan yang sering ditanyakan:',
              style: _font(size: 11, color: _textSecondary),
            ),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions.map((s) {
              return GestureDetector(
                onTap: () => _sendMessage(s),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _divider),
                  ),
                  child: Text(s, style: _font(size: 12, color: _textSecondary)),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: _surface,
        border: Border(top: BorderSide(color: _divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _divider),
              ),
              child: TextField(
                controller: _inputController,
                focusNode: _focusNode,
                style: _font(size: 14, color: _textPrimary),
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: 'Tanya seputar inventaris...',
                  hintStyle: _font(size: 14, color: _textSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _isLoading ? null : _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: _isLoading
                    ? null
                    : const LinearGradient(
                        colors: [_accent, _accentDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                color: _isLoading ? _card : null,
                borderRadius: BorderRadius.circular(14),
                boxShadow: _isLoading
                    ? null
                    : [
                        BoxShadow(
                          color: _accent.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: _isLoading
                  ? const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _textSecondary,
                          ),
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Restock Side Panel ────────────────────────────────────────────────────

  Widget _buildRestockSidePanel() {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: const BoxDecoration(
            color: _surface,
            border: Border(bottom: BorderSide(color: _divider)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6B35).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Color(0xFFFF6B35),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Analisis Restock',
                  style: _font(
                    size: 14,
                    weight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _showRestockPanel = false),
                child: const Icon(Icons.close, color: _textSecondary, size: 20),
              ),
            ],
          ),
        ),
        // Content
        Expanded(
          child: _restockLoading
              ? const Center(child: CircularProgressIndicator(color: _accent))
              : _restockData == null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: _textSecondary,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Gagal memuat data',
                        style: _font(color: _textSecondary),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _loadRestockData,
                        child: Text('Coba lagi', style: _font(color: _accent)),
                      ),
                    ],
                  ),
                )
              : _buildRestockContent(),
        ),
      ],
    );
  }

  Widget _buildRestockContent() {
    final analysis = _restockData!;
    final summary = analysis.summary;
    final needRestock = analysis.needRestock;
    final safe = analysis.safe;

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        // Summary cards
        Row(
          children: [
            Expanded(
              child: _summaryCard(
                label: 'Perlu Restock',
                value: '${summary.needRestock}',
                color: const Color(0xFFFF6B35),
                icon: Icons.warning_rounded,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _summaryCard(
                label: 'Stok Aman',
                value: '${summary.safe}',
                color: const Color(0xFF4ADE80),
                icon: Icons.check_circle_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (needRestock.isNotEmpty) ...[
          _sectionLabel('⚠️ Harus Direstock', const Color(0xFFFF6B35)),
          const SizedBox(height: 8),
          ...needRestock.map((item) => _restockCard(item)),
          const SizedBox(height: 16),
        ],
        if (safe.isNotEmpty) ...[
          _sectionLabel('✅ Stok Aman', const Color(0xFF4ADE80)),
          const SizedBox(height: 8),
          ...safe.map((item) => _restockCard(item)),
        ],
      ],
    );
  }

  Widget _summaryCard({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: _font(size: 22, weight: FontWeight.w800, color: color),
          ),
          Text(label, style: _font(size: 11, color: _textSecondary)),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text, Color color) {
    return Text(
      text,
      style: _font(size: 12, weight: FontWeight.w700, color: color),
    );
  }

  Widget _restockCard(RestockItem item) {
    final statusColor = item.needsRestock
        ? const Color(0xFFFF6B35)
        : const Color(0xFF4ADE80);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.productName,
                  style: _font(
                    size: 12.5,
                    weight: FontWeight.w700,
                    color: _textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  item.status,
                  style: _font(
                    size: 10,
                    weight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _infoRow('SKU', item.sku),
          _infoRow('Kategori', item.category),
          _infoRow('Stok saat ini', '${item.currentStock} unit'),
          _infoRow(
            'Rata-rata jual/hari',
            '${item.avgDailySales.toStringAsFixed(1)} unit',
          ),
          _infoRow(
            'Perkiraan kebutuhan 7 hari',
            '${item.predictedNeed7Days.toStringAsFixed(1)} unit',
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: _font(size: 11, color: _textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: _font(
                size: 11,
                weight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Typing Dots Animation ─────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (ctx, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i / 3;
            final t = ((_controller.value + delay) % 1.0);
            final opacity = (t < 0.5 ? t * 2 : (1 - t) * 2).clamp(0.3, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB570).withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
