import 'package:flutter/material.dart';

void main() {
  runApp(const MohabAiApp());
}

class MohabAiApp extends StatelessWidget {
  const MohabAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF7867F5);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mohab AI',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          brightness: Brightness.dark,
          surface: const Color(0xFF10111A),
        ),
        scaffoldBackgroundColor: const Color(0xFF10111A),
        fontFamily: null,
      ),
      home: const ChatHome(),
    );
  }
}

enum AiMode { cloud, local }

class ChatMessage {
  ChatMessage({required this.text, required this.fromUser});
  final String text;
  final bool fromUser;
}

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  AiMode _mode = AiMode.cloud;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, fromUser: true));
      _messages.add(ChatMessage(
        text: _mode == AiMode.cloud
            ? 'وصلت رسالتك! واجهة Mohab AI تعمل الآن. في المرحلة التالية سنربط الوضع السحابي بمزوّد نموذج مفتوح المصدر عبر خادم آمن.'
            : 'أنت تستخدم وضع التشغيل المحلي. سنضيف محرك llama.cpp ونموذج GGUF متوافقاً مع هاتفك في مرحلة لاحقة.',
        fromUser: false,
      ));
    });
    _controller.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF10111A),
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B8CFF), Color(0xFF5947D9)],
                  ),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mohab AI',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  Text('مساعدك الذكي',
                      style: TextStyle(fontSize: 11, color: Colors.white60)),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'محادثة جديدة',
              onPressed: () => setState(_messages.clear),
              icon: const Icon(Icons.add_comment_outlined),
            ),
            const SizedBox(width: 6),
          ],
        ),
        body: Column(
          children: [
            _buildModePicker(),
            Expanded(
              child: _messages.isEmpty ? _buildWelcome() : _buildMessages(),
            ),
            _buildComposer(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildModePicker() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1B28),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Expanded(
              child: _modeButton(
                mode: AiMode.cloud,
                icon: Icons.cloud_outlined,
                label: 'سحابي',
              ),
            ),
            Expanded(
              child: _modeButton(
                mode: AiMode.local,
                icon: Icons.phone_android,
                label: 'محلي',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeButton({
    required AiMode mode,
    required IconData icon,
    required String label,
  }) {
    final selected = _mode == mode;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => setState(() => _mode = mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF6554E8) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 17),
            const SizedBox(width: 7),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6554E8).withOpacity(0.16),
              ),
              child: const Icon(Icons.auto_awesome,
                  size: 38, color: Color(0xFFA99FFF)),
            ),
            const SizedBox(height: 22),
            const Text(
              'أهلاً بك في Mohab AI',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'مساعدك الذكي للكتابة والتعلّم والبرمجة والإبداع.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white60, height: 1.7),
            ),
            const SizedBox(height: 25),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 9,
              runSpacing: 9,
              children: const [
                _SuggestionChip(label: 'اكتب لي كود Python', icon: Icons.code),
                _SuggestionChip(label: 'اشرح فكرة معقدة', icon: Icons.lightbulb_outline),
                _SuggestionChip(label: 'ساعدني في التعلّم', icon: Icons.school_outlined),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'هذه نسخة أولية من الواجهة؛ ربط نماذج الذكاء الاصطناعي سيأتي في الخطوات التالية.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.white38, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return Align(
          alignment:
              message.fromUser ? Alignment.centerLeft : Alignment.centerRight,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 310),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            decoration: BoxDecoration(
              color: message.fromUser
                  ? const Color(0xFF6554E8)
                  : const Color(0xFF202130),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Text(message.text,
                style: const TextStyle(height: 1.6, fontSize: 14)),
          ),
        );
      },
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 7, 7, 7),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1D2A),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: const InputDecoration(
                  hintText: 'اكتب رسالتك إلى Mohab AI...',
                  hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: const Color(0xFF6554E8),
              borderRadius: BorderRadius.circular(15),
              child: InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: _sendMessage,
                child: const SizedBox(
                  width: 44,
                  height: 44,
                  child: Icon(Icons.arrow_upward_rounded, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label, required this.icon});
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      onPressed: () {
        final state = context.findAncestorStateOfType<_ChatHomeState>();
        if (state != null) {
          state._controller.text = label;
          state._sendMessage();
        }
      },
      avatar: Icon(icon, size: 16, color: const Color(0xFFA99FFF)),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: const Color(0xFF1D1E2C),
      side: BorderSide(color: Colors.white.withOpacity(0.07)),
    );
  }
}
