// ignore_for_file: prefer_const_declarations

final String fetchMessagesQuery = """
    query GetMessages(\$offset: Int!, \$limit: Int!) {
      messages(limit: \$limit, order_by: {created_at: desc}, offset: \$offset) {
        id
        content
        sender_id
        receiver_id
        created_at
        userBySenderId {
          full_name
          profile_picture
        }
      }
    }
  """;

final String subscribeMessages = """
subscription NewMessages {
  messages(where: {receiver_id: {_eq: "c9bb44da-83e3-f02f-f3d0-b99e99367195"}}, order_by: {created_at: desc}, limit: 1) {
    id
    content
    created_at
    receiver_id
    sender_id
    userBySenderId {
      full_name
      profile_picture
    }
  }
}
  """;

final String sendMessageMutation = """
  mutation SendMessage(\$content: String!, \$senderId: uuid!, \$receiverId: uuid!) {
    insert_messages_one(object: {content: \$content, sender_id: \$senderId, receiver_id: \$receiverId}) {
      id
      content
      sender_id
      receiver_id
      created_at
      userBySenderId {
        full_name
        profile_picture
      }
    }
  }
  """;
