import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttergpt/core/app_theme.dart';
import 'package:fluttergpt/models/chat_model.dart';
import 'package:fluttergpt/repositories/chat_gpt_repository.dart';

class ChatGptView extends StatefulWidget {
  const ChatGptView({super.key});

  @override
  State<ChatGptView> createState() => _ChatGptViewState();
}

class _ChatGptViewState extends State<ChatGptView> {
  final _inputCtrl = TextEditingController();
  final _repository = ChatGptRepository(Dio());
  final _messages = <ChatModel>[];
  final _scrollCtrl = ScrollController();

  void _srollDown() {
    Future.delayed(const Duration(milliseconds: 200), (() {
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.easeInOut);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          'ChatGPT Flutter',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: AppTheme.primaryColor,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollCtrl,
                  itemCount: _messages.length,
                  itemBuilder: (_, int index) {
                    return Row(
                      children: [
                        if (_messages[index].messageFrom == MessageFrom.me)
                          const Spacer(),
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.all(12),
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _messages[index].message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),

                          //lado da mensagem do bot
                        ),
                        if (_messages[index].messageFrom == MessageFrom.bot)
                          const Spacer(),
                      ],
                    );
                  },
                ),
              ),
              TextField(
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                maxLines: 4,
                minLines: 1,
                controller: _inputCtrl,
                decoration: InputDecoration(
                  hintText: 'Digite Aqui...',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.secondaryColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fillColor: AppTheme.secondaryColor,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppTheme.secondaryColor,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      if (_inputCtrl.text.isNotEmpty) {
                        final prompt = _inputCtrl.text;

                        setState(() {
                          _messages.add(ChatModel(
                            message: prompt,
                            messageFrom: MessageFrom.me,
                          ));
                          _inputCtrl.text = '';
                          _srollDown();
                        });
                        final chatResponse =
                            await _repository.promptMessage(prompt);

                        setState(() {
                          _messages.add(ChatModel(
                            message: chatResponse,
                            messageFrom: MessageFrom.bot,
                          ));
                          _srollDown();
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
