import 'dart:convert';

ChatModel ChatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String ChatModelToJson(ChatModel chatModel) => json.encode(chatModel.toJson());

class ChatModel {
  late String senderUid, receiverUid, message, date, image, type;
  late bool isRead;
  ChatModel(
      {required this.senderUid,
      required this.receiverUid,
      required this.message,
      required this.date,
      required this.isRead,
      required this.image,
      required this.type});

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        senderUid: json["senderUid"],
        receiverUid: json["receiverUid"],
        message: json["message"],
        date: json["date"],
        isRead: json["isRead"],
        image: json["image"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "senderUid": senderUid,
        "receiverUid": receiverUid,
        "message": message,
        "date": date,
        "isRead": isRead,
        "image": image,
        "type": type,
      };
}
