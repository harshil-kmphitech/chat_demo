import 'dart:io';

import 'package:chat_demo/models/chatModel/chat_message_model.dart';
import 'package:chat_demo/models/chatModel/chat_user_model.dart';
import 'package:chat_demo/ui/chat/conversation_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:chat_demo/helpers/all.dart';
import 'package:chat_demo/models/authModel/auth_model.dart';

class ChatController extends GetxController {
  AuthModel user = AuthModel.fromJson({});

  RxBool isLoading = false.obs;
  RxBool isLoadMoreUsers = false.obs;

  var chats = <Message>[].obs;
  var otherUser = ChatList().obs;
  var chatUsers = <ChatList>[].obs;
  var chatUserModel = ChatUserModel().obs;
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final chatMsgController = TextEditingController();
  final refreshController = RefreshController(initialRefresh: false);

  final socket = io.io(AppConfig.socketBaseUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
  });

  void connectToSocket() {
    printWarning('-----connectToSocket');
    try {
      socket.connect();
    } catch (e) {
      printWarning('-----connectToSocket catch e = $e');
    }

    socket.onConnect((_) {
      printWarning('-----Socket onConnect');
      socket.off(SocketKey.setNewMessage);
      socket.off(SocketKey.setMessageList);
      socket.off(SocketKey.updateChatList);
      socket.off(SocketKey.setChatUserList);

      socket.emit(SocketKey.socketLeave, user.data?.id);
      socket.emit(SocketKey.socketJoin, user.data?.id);

      socket.on(SocketKey.setSocketJoin, (data) => printAction('-----setSocketJoin: $data'));

      socket.on(SocketKey.setSocketLeave, (data) => printAction('-----setSocketLeave: $data'));

      socket.on(SocketKey.setChatUserList, (data) {
        if (!socket.connected) connectToSocket();

        printAction('-----setChatUserList Received message: $data ');
        final temp = ChatUserModel.fromJson(data);
        chatUserModel.value = temp;

        if (!isLoadMoreUsers.value && searchController.text.trim().isNotEmpty) chatUsers.clear();
        printAction('-----chatUsers=${chatUsers.length}');

        temp.data?.chatList?.forEach(
          (c) {
            final isUserMatch = chatUsers.any((cu) {
              final isMatch = cu.chatDetails?.userId == c.chatDetails?.userId;
              if (isMatch) cu = c;
              return isMatch;
            });

            if (!isUserMatch) chatUsers.add(c);
          },
        );

        chatUsers.sort(
          (a, b) => (b.lastMessage?.createdAt ?? DateTime.now()).compareTo(a.lastMessage?.createdAt ?? DateTime.now()),
        );
        chatUsers.refresh();
        refreshController.loadComplete();
        refreshController.refreshCompleted();
        printAction('-----chatUsers=${chatUsers.length}');
      });

      socket.on(SocketKey.updateChatList, (data) {
        if (!socket.connected) connectToSocket();

        printAction('-----updateChatList Received message: $data');
        // var temp = ResData.fromJson(data["resData"]);

        // chatUsers.removeWhere((cu) => cu.id == temp.id);
        // chatSearchUsers.removeWhere((cu) => cu.id == temp.id);

        // chatUsers.insert(0, temp);
        // chatSearchUsers.insert(0, temp);

        printAction('-----chatUsers=${chatUsers.length}');
      });

      socket.on(SocketKey.setMessageList, (data) {
        if (!socket.connected) connectToSocket();

        printAction('-----setMessageList Received message: $data');
        var temp = ChatMessageModel.fromJson(data);
        chats.clear();

        temp.resData?.messages?.forEach((m) => chats.insert(0, m));
        // temp.resData?.messages?.forEach((m) => chats.add(m));

        chats.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));

        isLoading.value = false;
        printAction('-----chats=${chats.length}');

        goToBottom();
      });

      socket.on(SocketKey.setNewMessage, (data) {
        if (!socket.connected) connectToSocket();

        printAction('-----setNewMessage Received message: $data');

        var temp = Message.fromJson(data);

        printAction('-----otherUser.value.roomId: ${otherUser.value.roomId}');
        printAction('-----temp.roomId: ${temp.roomId}');
        printAction('-----temp.message: ${temp.message}');
        printWarning('-----otherUser.value.roomId == temp.roomId: ${otherUser.value.roomId == temp.roomId}');
        if (otherUser.value.roomId == temp.roomId) chats.insert(0, temp);
        chats.refresh();
        // goToBottom();

        printAction('-----chats=${chats.length}');
        getChatUserList();
      });

      getChatUserList();

      printWarning('-----Socket Connected Successfully');
    });

    socket.onReconnect((data) {
      printWarning('-----Socket onReconnect');

      socket.emit(SocketKey.socketLeave, user.data?.id);
      socket.emit(SocketKey.socketJoin, user.data?.id);
      printWarning('-----Socket Reconnected');
    });

    socket.onDisconnect((_) {
      printWarning('-----Socket onDisconnect');

      disconnectSocket();

      var isUserLogin = (getIt<SharedPreferences>().getIsUserLogin ?? false);
      printAction("-----isUserLogin=$isUserLogin");
      if (isUserLogin) {
        connectToSocket();
        return;
      }
    });

    socket.onConnectError((e) => printError('-----Socket onConnectError e = $e'));

    socket.onReconnectError((e) => printError('-----Socket onReconnectError e = $e'));

    socket.onError((e) {
      printError('-----Socket onError e = $e');
      utils.showToast(message: 'Error: $e');
    });
  }

  void getChatUserList({int offset = 0, String search = '', bool isLoadMore = false}) {
    printAction("------------getChatUserList");
    printAction("------------socket.connected=${socket.connected}");
    if (!socket.connected) connectToSocket();

    isLoadMoreUsers.value = isLoadMore;
    if (offset != 0) if ((chatUserModel.value.data?.totalRecords ?? -1) <= chatUsers.length) return;

    final data = {
      "userId": user.data?.id,
      "offset": offset,
      "search": search,
      "limit": 10,
    };

    printAction("------------data=$data");

    socket.emit(SocketKey.getChatUserList, data);
  }

  void getMessageList() {
    printAction("------------getMessageList");
    printAction("------------socket.connected=${socket.connected}");
    chatMsgController.clear();

    if (!socket.connected) connectToSocket();

    final data = {
      'userId': user.data?.id,
      'roomId': otherUser.value.roomId,
      'offset': 0,
      'limit': 100,
      'search': '',
    };

    socket.emit(SocketKey.roomJoin, {'userId': user.data?.id, 'roomId': otherUser.value.roomId});
    socket.emit(SocketKey.getMessageList, data);
  }

  void sendMessage() {
    printAction("------------sendMessage");
    printAction("------------socket.connected=${socket.connected}");
    if (!socket.connected) connectToSocket();

    if (chatMsgController.text.trim().isEmpty) {
      utils.showToast(
        isError: true,
        message: 'Please enter message',
      );
      return;
    }

    var msg = chatMsgController.text;

    var curDate = DateTime.now().toUtc();

    chats.insert(
      0,
      Message(
        message: msg,
        mediaUrl: '',
        msgType: 'text',
        messageId: '-',
        createdAt: curDate,
        sender: Sender(
          name: user.data?.name,
          senderId: user.data?.id,
          profile: user.data?.profile,
        ),
      ),
    );

    final data = {
      'sender': user.data?.id,
      'receiver': otherUser.value.chatDetails?.userId,
      'message': msg,
      'messageType': 'text',
      'createdAt': '$curDate',
      'chatType': otherUser.value.chatType,
      'roomId': otherUser.value.roomId ?? '',
    };

    socket.emit(SocketKey.sendMessage, data);

    chatMsgController.clear();

    goToBottom();

    // getChatUserList();
  }

  void goToBottom() {
    for (var t in [200, 400, 800, 1000]) {
      Future.delayed(
        Duration(milliseconds: t),
        () {
          if (chats.isNotEmpty) {
            try {
              scrollController.animateTo(
                scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } catch (e) {
              //
            }
          }
        },
      );
    }
  }

  void disconnectSocket() {
    printWarning("-----disconnectSocket");
    socket.emit(SocketKey.socketLeave, user.data?.id);
    socket.disconnect();
    socket.dispose();
  }

  void goToMessageView(ChatList? userDetail) {
    if (userDetail != null) {
      otherUser.value = userDetail;
      isLoading.value = true;
      Get.to(ConversationScreen());
      getMessageList();
    }
  }

  @override
  void onInit() {
    connectToSocket();

    if (getIt<SharedPreferences>().getIsUserLogin ?? false) {
      final userData = getIt<SharedPreferences>().getLoginData;
      if (userData != null) user.data = userData;

      //
      user.data?.id = Platform.isIOS ? '67f0e981be04059b4eab70c2' : '67f0e8d2be04059b4eab70b7';
    }

    super.onInit();
  }

  @override
  void onClose() {
    disconnectSocket();

    super.onClose();
  }
}
