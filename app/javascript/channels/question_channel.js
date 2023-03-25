import consumer from "./consumer"

consumer.subscriptions.create({channel: "QuestionChannel", question_id: gon.question_id }, {
  received(data) {
    if (gon.current_user_id != data.author_id) {
      console.log(data.author_id)
      $('.answers').append(data.html)
    }
  }
})
