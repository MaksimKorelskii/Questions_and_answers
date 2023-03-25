import consumer from "./consumer"

consumer.subscriptions.create({channel: "CommentsChannel", question_id: gon.question_id }, {
  received(data) {
    let html = data.html
    let commentable = data.commentable_type
    let commentableId = data.commentable_id

    if (gon.current_user_id != data.author_id) {
      if (commentable === 'question') {
        $('.question .comments').append(html)
      } 
      else {
        $('.answers .comments').append(html)
      }
  }}
})
