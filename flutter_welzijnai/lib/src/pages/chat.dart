import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logger/web.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:welzijnai/models/history_data.dart';
import 'package:welzijnai/src/components/chat_bubble.dart';
import 'package:welzijnai/src/components/navbar.dart';
import 'package:welzijnai/src/components/textfield.dart';
import 'package:welzijnai/src/pages/settings.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:welzijnai/src/services/auth/auth_service.dart';
import 'package:welzijnai/src/services/chat/chat_service.dart';
import 'package:welzijnai/src/services/history/history_service.dart';
import 'package:welzijnai/src/services/setings/settingsprovider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Chatpage
/// Gets the past messages from the current day and provides
/// the input option the user has selected in the settings.
/// File path: lib/src/pages/chat.dart

int messageCount = 0;
List<int> messageList = [];
ChatMode selectedMode = ChatMode.text;
HistoryData historyData = HistoryData(
  mobility: 0,
  selfcare: 0,
  activities: 0,
  pain: 0,
  anxiety: 0,
  timestamp: Timestamp.now(),
);

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });
  static const routeName = '/chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final player = AudioPlayer();
  final stt.SpeechToText speech = stt.SpeechToText();
  bool speechEnabled = false;
  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await speech.initialize();
    setState(() {});
  }

  void startListening(BuildContext context) async {
    await speech.listen(
      onResult: (result) {
        setState(() {
          messageController.text = result.recognizedWords.toLowerCase(); //lowercased to make output nicer
          if (result.finalResult && selectedMode == ChatMode.speech) {
            stopListening();
            sendMessage(context);
          }
        });
      },
      localeId: 'nl_NL', //changed to English (en_US) for demo, switch back to 'nl_NL' if needed
    );
  }

  void stopListening() async {
    await speech.stop();
    setState(() {});
  }

  Future<void> playTextToSpeech(String text) async {
    String? apikey = dotenv.env['ELEVENLABS_API_KEY'];
    if (apikey == null) {
      return;
    }
    String voiceRachel =
        '21m00Tcm4TlvDq8ikWAM'; //Rachel voice - change if you know another Voice ID

    //api key in env file todo
    String url = 'https://api.elevenlabs.io/v1/text-to-speech/$voiceRachel';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'accept': 'audio/mpeg',
        'xi-api-key': apikey,
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "text": text,
        "model_id": "eleven_multilingual_v2",
        "voice_settings": {"stability": .15, "similarity_boost": .75}
      }),
    );

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes; //get the bytes ElevenLabs sent back
      await player.setAudioSource(MyCustomSource(
          bytes)); //send the bytes to be read from the JustAudio library
      player.play(); //play the audio
    } else {
      // throw Exception('Failed to load audio');
      return;
    }
  }

  ///debugging
  // void sendMessage(BuildContext context) async {
  //   String messageText = messageController.text;
  //   final settingsProvider =
  //       Provider.of<SettingsProvider>(context, listen: false);
  //   messageController.clear();
  //   if (messageText.isNotEmpty) {
  //     await chatService.sendMessage(true, messageText);
  //     await playTextToSpeech(messageText);
  //     if (settingsProvider.selectedDebug) {
  //       await chatService.sendMessage(false, "debug");
  //     }

  //     await chatService.sendMessage(false, messageText);
  //   }
  // }

  //Send message
  void sendMessage(BuildContext context) async {
    Logger logger = Logger();
    int scale = 1;
    String messageText = messageController.text;
    messageController.clear();
    final settingsProvider =
        Provider.of<SettingsProvider>(context, listen: false);
    if (messageText.isNotEmpty) {
      await chatService.sendMessage(true, messageText);
      var url = Uri.http('10.0.2.2:8000', '/response');
      try {
        var response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            'message': messageText,
            'question_index': messageCount.toString(),
          }),
        );
        if (response.statusCode == 200) {
          logger.i('Message sent successfully');
          //Parse the response body
          var apiResponse = jsonDecode(response.body);
          //Send the API response to Firebase
          if (settingsProvider.selectedDebug && apiResponse['scale'] != null) {
            chatService.sendMessage(false, apiResponse['scale']);
          }
          if (apiResponse['scaleindex'] != null) {
            scale = int.parse(apiResponse['scaleindex']) + 1;
          }
          //if (settingsProvider.selectedDebug){
          //chatService.sendMessage(false, scale.toString()); //+1
          //}
          if (messageCount < 5 && messageCount != 0) {
            messageList.add(scale);
          } else if (messageCount == 5) {
            messageList.add(scale);
            historyData = HistoryData(
              mobility: messageList[0],
              selfcare: messageList[1],
              activities: messageList[2],
              pain: messageList[3],
              anxiety: messageList[4],
              timestamp: Timestamp.now(),
            );
            HistoryService historyService = HistoryService();
            historyService.syncHistory(historyData);
            messageList = [];
          }

          chatService.sendMessage(false, apiResponse['response']);
          messageCount++;
          await playTextToSpeech(apiResponse['response']);
        } else {
          logger.e('Failed to send message');
        }
      } catch (e) {
        logger.e('Failed to send message: $e');
      }
      messageController.clear();
    }
  }

  void refresh() async {
    Logger logger = Logger();
    chatService.refreshMessages(DateTime.now());
    var url = Uri.http('10.0.2.2:8000', '/');
    try {
      var response = await http.delete(
        url,
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        logger.i('Delete sent successfully');
        messageCount = 0;
        messageList = [];
      } else {
        logger.e('Failed to send message');
      }
    } catch (e) {
      logger.e('Failed to send message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var chatModeProvider = Provider.of<SettingsProvider>(context);
    ChatMode selectedMode = chatModeProvider.selectedChatMode;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 55,
            ),
            Center(
              child: Text(
                "Welzijn.ai",
              ),
            ),
          ],
        ),
        shape: const Border(bottom: BorderSide(width: 1)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: IconButton(
                icon: SizedBox(
                    height: 30,
                    width: 30,
                    child: Image.asset("assets/images/refresh.png")),
                onPressed: refresh),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildMessageList(context),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 3,
                  child: Visibility(
                    visible: selectedMode ==
                        ChatMode
                            .textAndSpeech, // Only show when the input option is both text and speech
                    child: IconButton(
                        splashRadius: 1,
                        icon: SizedBox(
                          height: 45,
                          width: 45,
                          child: Image.asset('assets/images/mic.png'),
                        ),
                        onPressed: speech.isListening
                            ? stopListening
                            : () => startListening(context)),
                  ),
                ),
              ],
            ),
          ),
          _buildUserInput(context),
        ],
      ),
      bottomNavigationBar: const NavBar(
        // Of the three available pages, the first one is currently selected.
        selected: [true, false, false],
      ),
    );
  }

  // Get the messages for the current user and day from the chatservice
  Widget _buildMessageList(BuildContext context) {
    String senderID = authService.getCurrentUser()!.uid;
    DateTime now = DateTime.now();
    final DateTime date = DateTime(now.year, now.month, now.day);

    return StreamBuilder(
        stream: chatService.getMessages(senderID, date),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Container();
          }
          return SingleChildScrollView(
            reverse: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: snapshot.data!.docs
                  .map((doc) => _buildMessageItem(doc))
                  .toList(),
            ),
          );
        });
  }

  // Layout for the individual messages
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isUser = data['user'];
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
            child: ChatBubble(message: data['message'], isUser: isUser),
          ),
        ],
      ),
    );
  }

  // Input from the user
  Widget _buildUserInput(BuildContext context) {
    var chatModeProvider = Provider.of<SettingsProvider>(context);
    selectedMode = chatModeProvider.selectedChatMode;
    return selectedMode == ChatMode.text ||
            selectedMode == ChatMode.textAndSpeech
        ? _textOrSpeech()
        : _speech(context);
  }

  // Only speech input
  Widget _speech(BuildContext context) {
    return Column(
      children: [
        IconButton(
          splashRadius: 1,
          icon: SizedBox(
            height: 45,
            width: 45,
            child: Image.asset('assets/images/mic.png'),
          ),
          onPressed: speech.isListening
              ? stopListening
              : () => startListening(context),
        ),
        Text(
          "Spreek uw bericht in...",
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  // Text input or both text and speech input
  Widget _textOrSpeech() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: LoginTextField(
                focusNode: focusNode,
                hintText: "Typ een bericht...",
                controller: messageController,
              ),
            ),
            Material(
              shape: const CircleBorder(),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                height: 50,
                width: 50,
                child: InkWell(
                  onTap: () => sendMessage(context),
                  child: Image.asset('assets/images/send.png'),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}

class MyCustomSource extends StreamAudioSource {
  final List<int> bytes;
  MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}
