import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_demo/controllers/chat_controller.dart';
import 'package:chat_demo/helpers/all.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatUsersScreen extends StatelessWidget {
  const ChatUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat Users Screen',
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
            //
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade700),
                ),
              ),
              controller: controller.searchController,
              textInputAction: TextInputAction.search,
              onChanged: (val) => controller.getChatUserList(search: val),
            ).marginAll(20),

            //
            Expanded(
              child: Obx(
                () => controller.chatUsers.isEmpty
                    ? Center(
                        child: Image.asset(
                          Assets.images.noData.path,
                          height: 172,
                          width: 180,
                          fit: BoxFit.fill,
                        ),
                      )
                    : SmartRefresher(
                        primary: false,
                        controller: controller.refreshController,
                        enablePullUp: !((controller.chatUserModel.value.data?.totalRecords ?? -1) <= controller.chatUsers.length),
                        onRefresh: () => controller.getChatUserList(search: controller.searchController.text),
                        onLoading: () => controller.getChatUserList(
                          offset: controller.chatUsers.length,
                          search: controller.searchController.text,
                          isLoadMore: true,
                        ),
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          itemCount: controller.chatUsers.length,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (BuildContext context, int index) {
                            final user = controller.chatUsers[index];
                            final isTodayDate = utils.isTodayDate(dateA: '${user.lastMessage?.createdAt}');

                            return GestureDetector(
                              onTap: () => controller.goToMessageView(user),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 10, left: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(53),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(53),
                                        child: CachedNetworkImage(
                                          imageUrl: user.senderUserDetails?.profile ?? '',
                                          fit: BoxFit.cover,
                                          height: 53,
                                          width: 53,
                                          errorWidget: (context, url, error) => Center(
                                            child: Image.asset(
                                              Assets.images.user.path,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.blue,
                                              value: downloadProgress.progress,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    //
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  user.chatDetails?.name ?? '-',
                                                  style: TextStyle(fontSize: 16),
                                                ),
                                              ),
                                              Text(
                                                isTodayDate
                                                    ? utils.getFormatedDate(dateFormate: "hh:mm a", date: "${user.lastMessage?.createdAt}").toUpperCase()
                                                    : utils.getFormatedDate(dateFormate: "dd MMM", date: "${user.lastMessage?.createdAt}"),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ).marginOnly(left: 3),
                                            ],
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  user.lastMessage?.message ?? '-',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ),
                                              if ((user.unreadmessageCount ?? 0) > 0)
                                                Container(
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.only(left: 3),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    '${user.unreadmessageCount ?? 0}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
