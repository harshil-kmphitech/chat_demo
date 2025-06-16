import 'package:chat_demo/helpers/all.dart';
import 'package:chat_demo/models/authModel/auth_model.dart';
import 'package:chat_demo/models/chatModel/chat_message_model.dart';
import 'package:chat_demo/models/chatModel/chat_user_model.dart';
import 'package:chat_demo/ui/chat/conversation_screen.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatController extends GetxController {
  AuthModel user = AuthModel.fromJson({});

  RxBool isLoading = false.obs;
  RxBool isLoadMoreUsers = false.obs;

  var totalRecords = 0;
  var chats = <Message>[].obs;
  var otherUser = ChatList().obs;
  var chatUsers = <ChatList>[].obs;
  var chatUserModel = ChatUserModel().obs;
  final scrollController = ScrollController();
  final searchController = TextEditingController();
  final chatMsgController = TextEditingController();
  final refreshController = RefreshController(initialRefresh: false);
  final refreshController2 = RefreshController(initialRefresh: false);

  final socket = io.io(AppConfig.socketBaseUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': true,
    'reconnection': true,
    'reconnectionAttempts': 5,
    'reconnectionDelay': 1000,
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

      socket.emit(SocketKey.socketLeave, {'userId': user.data?.id});
      socket.emit(SocketKey.socketJoin, {'userId': user.data?.id});

      socket.on(SocketKey.setSocketJoin, (data) => printAction('-----setSocketJoin: $data'));

      socket.on(SocketKey.setSocketLeave, (data) => printAction('-----setSocketLeave: $data'));

      socket.on(SocketKey.setRoomJoin, (data) => printAction('-----setRoomJoin: $data'));

      socket.on(SocketKey.setRoomLeave, (data) => printAction('-----setRoomLeave: $data'));

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

            if (isUserMatch) {
              final index = chatUsers.indexWhere((cu) => cu.chatDetails?.userId == c.chatDetails?.userId);

              chatUsers[index] = c;
            } else {
              chatUsers.add(c);
            }
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
        final temp = ChatList.fromJson(data);

        chatUsers.removeWhere((cu) => cu.chatDetails?.userId == temp.chatDetails?.userId);

        chatUsers.insert(0, temp);

        printAction('-----chatUsers=${chatUsers.length}');
      });

      socket.on(SocketKey.setMessageList, (data) {
        if (!socket.connected) connectToSocket();

        printAction('-----setMessageList Received message: $data');
        var temp = ChatMessageModel.fromJson(data);
        if (totalRecords == 0) chats.clear();

        totalRecords = temp.resData?.totalRecords ?? 0;
        temp.resData?.messages?.forEach((m) => chats.insert(0, m));
        // temp.resData?.messages?.forEach((m) => chats.add(m));

        chats.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));

        isLoading.value = false;
        printAction('-----chats=${chats.length}');
        printAction("------------totalRecords=$totalRecords");

        if (totalRecords == 0) goToBottom();
        if (totalRecords != 0) refreshController2.loadComplete();
      });

      socket.on(SocketKey.setNewMessage, (data) {
        if (!socket.connected) connectToSocket();

        printAction('-----setNewMessage Received message: $data');

        var temp = Message.fromJson(data);

        // printAction('-----temp.roomId: ${temp.roomId}');
        // printAction('-----otherUser.value.roomId: ${otherUser.value.roomId}');
        printAction('-----temp.message: ${temp.message}');
        printWarning('-----otherUser.value.roomId == temp.roomId: ${otherUser.value.roomId == temp.roomId}');
        if (otherUser.value.roomId == temp.roomId) chats.insert(0, temp);
        chats.refresh();
        // goToBottom();

        printAction('-----chats=${chats.length}');
        // getChatUserList();
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

  void getMessageList({bool isClear = false}) {
    printAction("------------getMessageList");
    printAction("------------socket.connected=${socket.connected}");
    printAction("------------isClear=$isClear ---chats.length=${chats.length} ---totalRecords=$totalRecords");
    if (isClear) chatMsgController.clear();

    if (!socket.connected) connectToSocket();

    final data = {
      'userId': user.data?.id,
      'roomId': otherUser.value.roomId,
      'offset': chats.length,
      'limit': 10,
      'search': '',
    };

    if (isClear) {
      printAction("------------roomJoin");
      socket.emit(SocketKey.roomJoin, {
        'userId': user.data?.id,
        'roomId': otherUser.value.roomId,
        'receiver': otherUser.value.chatDetails?.userId,
        'chatType': otherUser.value.chatType ?? 'Personal', // 'Group' or 'Personal'
      });
    }
    socket.emit(SocketKey.getMessageList, data);
  }

  void sendMessage() {
    printAction("------------sendMessage");
    printAction("------------socket.connected=${socket.connected}");
    if (!socket.connected) connectToSocket();

    final message = chatMsgController.text.trim();
    if (message.isEmpty) {
      utils.showToast(
        isError: true,
        message: 'Please enter message',
      );
      return;
    }

    final curDate = DateTime.now().toUtc();
    final newMessage = Message(
      message: message,
      mediaUrl: '',
      msgType: 'text',
      messageId: '-',
      createdAt: curDate,
      sender: Sender(
        name: user.data?.name,
        senderId: user.data?.id,
        profile: user.data?.profile,
      ),
    );

    chats.insert(0, newMessage);

    final data = {
      'sender': user.data?.id,
      'receiver': otherUser.value.chatDetails?.userId,
      'message': message,
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
    if (chats.isEmpty) return;

    for (var t in [100, 200, 400, 800, 1000]) {
      Future.delayed(
        Duration(milliseconds: t),
        () {
          if (chats.isNotEmpty) {
            try {
              scrollController.animateTo(
                0, // scrollController.position.minScrollExtent,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            } catch (e) {
              //
            }
            if (t == 1000 && scrollController.position.minScrollExtent > 0) goToBottom();
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
      totalRecords = 0;
      otherUser.value = userDetail;
      isLoading.value = true;
      chats.clear();
      Get.to(() => ConversationScreen());
      getMessageList(isClear: true);
    }
  }

  @override
  void onInit() {
    connectToSocket();

    if (getIt<SharedPreferences>().getIsUserLogin ?? false) {
      final userData = getIt<SharedPreferences>().getLoginData;
      if (userData != null) user.data = userData;
    }

    super.onInit();
  }

  @override
  void onClose() {
    disconnectSocket();
    scrollController.dispose();
    searchController.dispose();
    chatMsgController.dispose();
    refreshController.dispose();
    refreshController2.dispose();
    super.onClose();
  }
}
