import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test/consts.dart';
import '../graphql/mutations.dart';
import '../graphql/graphql_config.dart';
import '../firebase/notification_service.dart';
import '../widgets/chat_page_appbar_widget.dart';
import '../widgets/scroll_bottom_button_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  //! آبجکت های مورد نیاز صفحه گفتگو
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  final String userId = "c9bb44da-83e3-f02f-f3d0-b99e99367195";
  final String receiverId = "880ac5de-51ec-44e5-b258-a4b1acb6410a";
  List messages = [];
  Set<String> messageIds = {};
  bool isFetchingMore = false;
  int offset = 0;
  bool hasMoreMessages = true;
  final int messageLimit = 20;
  bool showScrollToBottomButton = false;

  //! اوراید و اینیت استیت کردن جهت دریافت پیام و نوتیف
  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.atEdge &&
          scrollController.position.pixels != 0) {
        fetchMoreMessages();
      }
      setState(() {
        showScrollToBottomButton = scrollController.position.pixels > 300;
      });
    });

    fetchMoreMessages();
    NotificationService2().initialize();

    //! نمایش لحظه ای پیام و دریافت نوتیفیکیشن در حالت فورگراند
    GraphQLConfig.client()
        .subscribe(SubscriptionOptions(
      document: gql(subscribeMessages),
    ))
        .listen((QueryResult result) {
      if (result.hasException) {
        if (mounted) {
          Fluttertoast.showToast(
            msg: "خطا در دریافت پیام: ${result.exception.toString()}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
          );
        }
      } else {
        var newMessages = result.data!['messages'];
        if (newMessages.isNotEmpty) {
          if (mounted) {
            setState(() {
              for (var newMessage in newMessages) {
                if (!messageIds.contains(newMessage['id']) &&
                    newMessage['sender_id'] == receiverId) {
                  messages.insert(0, newMessage);
                  messageIds.add(newMessage['id']);
                  NotificationService2().showNotification(
                    newMessage['userBySenderId']['full_name'] ?? 'Unknown',
                    newMessage['content'] ?? 'No content',
                    newMessage['userBySenderId']['profile_picture'] ?? '',
                  );
                }
              }
              messages
                  .sort((a, b) => b['created_at'].compareTo(a['created_at']));
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    messageController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  //! تابع ارسال پیام
  void sendMessage(String content) async {
    final MutationOptions options = MutationOptions(
      document: gql(sendMessageMutation),
      variables: <String, dynamic>{
        'content': content,
        'senderId': userId,
        'receiverId': receiverId,
      },
    );

    final QueryResult result = await GraphQLConfig.client().mutate(options);

    if (result.hasException) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: "خطا در ارسال پیام ها: ${result.exception.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      var newMessage = result.data!['insert_messages_one'];
      if (mounted) {
        setState(() {
          messages.insert(0, newMessage);
          messageIds.add(newMessage['id']);
          messages.sort((a, b) => b['created_at'].compareTo(a['created_at']));
        });
      }
    }
  }

  //! تابع دریافت پیام های بیشتر
  void fetchMoreMessages() async {
    if (isFetchingMore || !hasMoreMessages) return;

    setState(() {
      isFetchingMore = true;
    });

    final QueryOptions options = QueryOptions(
      document: gql(fetchMessagesQuery),
      variables: {
        'offset': offset,
        'limit': messageLimit,
      },
    );

    final QueryResult result = await GraphQLConfig.client().query(options);

    if (result.hasException) {
      if (mounted) {
        Fluttertoast.showToast(
          msg: "خطا در دریافت پیام ها: ${result.exception.toString()}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      List fetchedMessages = result.data!['messages'];
      if (fetchedMessages.length < messageLimit) {
        hasMoreMessages = false;
      }
      if (mounted) {
        setState(() {
          for (var message in fetchedMessages) {
            if (!messageIds.contains(message['id'])) {
              messages.add(message);
              messageIds.add(message['id']);
            }
          }
          messages.sort((a, b) => b['created_at'].compareTo(a['created_at']));
          offset += messageLimit;
        });
      }
    }

    setState(() {
      isFetchingMore = false;
    });
  }

  //! ساخت آیتم پیام
  Widget buildMessageItem(dynamic message) {
    try {
      bool isMine = message['sender_id'] == userId;
      var profilePicture =
          message['userBySenderId']['profile_picture'] ?? 'default_image_url';
      var fullName = message['userBySenderId']['full_name'] ?? 'Unknown';
      var createdAt = message['created_at'] ?? '';

      return Align(
        alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            color: isMine ? const Color(0xffE1F6DF) : const Color(0xffF6F6F6),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment:
                isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profilePicture),
              ),
              const SizedBox(height: 5),
              Text(fullName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Text(message['content'] ?? 'No content'),
              const SizedBox(height: 5),
              Text(createdAt, style: const TextStyle(fontSize: 10)),
            ],
          ),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'خطا در نمایش پیام: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );

      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //! اپبار صفحه چت
      appBar: myChatPageAppBar(),

      body: Stack(
        children: [
          Image.asset(
            'assets/images/b.png',
            width: Get.width,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              //! لیست پیام ها
              Expanded(
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: scrollController,
                      reverse: true,
                      itemCount: messages.length + (hasMoreMessages ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == messages.length) {
                          return isFetchingMore
                              ? const Center(child: CircularProgressIndicator())
                              : Container();
                        }
                        var message = messages[index];
                        if (message != null) {
                          return buildMessageItem(message);
                        } else {
                          return Container();
                        }
                      },
                    ),
                    if (isFetchingMore)
                      const Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(),
                      ),
                  ],
                ),
              ),

              //! دکمه جهت اسکرول کردن به پایین پیام ها
              ScrollBottmButtonWidget(
                  showScrollToBottomButton: showScrollToBottomButton,
                  scrollController: scrollController),
              //! تکست فیلد پایین صفحه
              Container(
                height: 85,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            sendMessage(messageController.text);
                            messageController.clear();
                          }
                        },
                        icon: Image.asset(
                          'assets/images/send.png',
                          height: 25,
                        )),
                    SizedBox(
                      height: 40,
                      width: 255,
                      child: TextField(
                        controller: messageController,
                        textDirection: TextDirection.rtl,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 9, horizontal: 10),
                          filled: true,
                          fillColor: const Color(0xffF7F7FC),
                          hintText: 'پیام',
                          hintStyle: const TextStyle(color: kGreyColor),
                          hintTextDirection: TextDirection.rtl,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8)),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: kBlueColor, width: 2.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/add.png',
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
