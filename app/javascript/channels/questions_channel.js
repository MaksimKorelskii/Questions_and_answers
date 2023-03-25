import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  received(data) {
    if (gon.current_user_id != data.author_id) {
      $('.questions').append(data.html)
    }
  }
})
