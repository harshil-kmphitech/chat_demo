import 'package:chat_demo/controllers/chat_controller.dart';
import 'package:chat_demo/helpers/all.dart';

class ConversationScreen extends GetView<ChatController> {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        controller.getChatUserList();
        printAction("------------roomLeave");
        controller.socket.emit(SocketKey.roomLeave, {'userId': controller.user.data?.id});
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            controller.otherUser.value.chatDetails?.name ?? '',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? SizedBox(width: Get.width)
                      : controller.chats.isEmpty
                          ? Center(
                              child: Image.asset(
                                Assets.images.noData.path,
                                height: 172,
                                width: 180,
                                fit: BoxFit.fill,
                              ),
                            )
                          : ListView.builder(
                              reverse: true,
                              primary: false,
                              padding: EdgeInsets.zero,
                              itemCount: controller.chats.length,
                              itemBuilder: (context, index) {
                                var chat = controller.chats[index];
                                var isMe = chat.sender?.senderId == controller.user.data?.id;
                                var isShowDate = true;
                                var isToday = false;
                                var isYesterday = false;

                                if (index != (controller.chats.length - 1)) {
                                  isShowDate = DateTime.parse(
                                        utils.getFormatedDate(dateFormate: 'yyyy-MM-dd', date: '${chat.createdAt}'),
                                      ).compareTo(DateTime.parse(
                                        utils.getFormatedDate(dateFormate: 'yyyy-MM-dd', date: '${controller.chats[index + 1].createdAt}'),
                                      )) ==
                                      1;
                                }
                                if (isShowDate) {
                                  isToday = utils.isTodayDate(dateA: '${chat.createdAt}');
                                  isYesterday = utils.isYesterdayDate(dateA: '${chat.createdAt}');
                                }

                                return Align(
                                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      if (isShowDate)
                                        Row(
                                          children: [
                                            const Expanded(child: Divider(color: Colors.grey)),
                                            Text(
                                              isToday
                                                  ? 'Today'
                                                  : isYesterday
                                                      ? 'Yesterday'
                                                      : utils.getFormatedDate(dateFormate: "dd MMM yyyy", date: '${chat.createdAt}'),
                                              style: TextStyle(
                                                fontSize: 14,
                                                // fontFamily: FontFamily.regular,
                                              ),
                                            ).marginSymmetric(horizontal: 10),
                                            const Expanded(child: Divider(color: Colors.grey)),
                                          ],
                                        ).marginOnly(bottom: 10),
                                      Container(
                                        padding: EdgeInsets.all(12),
                                        margin: EdgeInsets.only(bottom: 5, left: isMe ? 60 : 0, right: isMe ? 0 : 60),
                                        decoration: BoxDecoration(
                                          color: isMe ? Colors.blue : Colors.grey,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(isMe ? 12 : 0),
                                            bottomRight: Radius.circular(isMe ? 0 : 12),
                                          ),
                                        ),
                                        child: Text(
                                          chat.message ?? '',
                                          maxLines: 10,
                                          style: TextStyle(
                                            fontSize: 14,
                                            // fontFamily: FontFamily.regular,
                                            color: isMe ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        utils.getFormatedDate(dateFormate: "hh:mm a", date: '${chat.createdAt}').toUpperCase(),
                                        maxLines: 10,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                          // fontFamily: FontFamily.regular,
                                        ),
                                      ).marginOnly(bottom: 12),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ),

              //
              Obx(
                () {
                  controller.otherUser.value;

                  return !utils.isValueEmpty(controller.otherUser.value.deletedAt)
                      ? Text(
                          'This User No Longer Exists',
                          style: TextStyle(fontSize: 16),
                        ).paddingSymmetric(vertical: 10)
                      // : controller.otherUser.value.isBlock != '0'
                      //     ? Text(
                      //         'thisUserIsBlockedByTheAdmin',
                      //         style: TextStyle(fontSize: 16),
                      //       ).paddingSymmetric(vertical: 10)
                      : TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            suffix: GestureDetector(
                              onTap: () => controller.sendMessage(),
                              child: Icon(Icons.send_rounded).paddingOnly(left: 10),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          controller: controller.chatMsgController,
                        ).paddingOnly(top: 10, bottom: 20);
                },
              ),
            ],
          ).paddingSymmetric(horizontal: 20),
        ),
      ),
    );
  }
}
