require 'rails_helper'

RSpec.describe SearchService do
  let!(:author) { create(:user) }
  let!(:question) { create(:question, author: author) }
  let!(:answer) { create(:answer, question: question, author: author) }
  let!(:comment) { create(:question, author: author) }

  it 'search by all' do
    expect(ThinkingSphinx).to receive(:search).with(question.title)

    described_class.call(search_query: question.title, search_by: 'all')
  end

  it 'search by questions' do
    expect(Question).to receive(:search).with(question.title)

    described_class.call(search_query: question.title, search_by: 'question')
  end

  it 'search by answers' do
    expect(Answer).to receive(:search).with(answer.body)

    described_class.call(search_query: answer.body, search_by: 'answer')
  end

  it 'search by comments' do
    expect(Comment).to receive(:search).with(comment.body)

    described_class.call(search_query: comment.body, search_by: 'comment')
  end

  it 'search by users' do
    expect(User).to receive(:search).with(ThinkingSphinx::Query.escape(author.email))

    described_class.call(search_query: author.email, search_by: 'user')
  end

  it 'search with no matches' do
    expect(described_class).to receive(:call).with(search_query: '', search_by: '')

    described_class.call(search_query: '', search_by: '')
  end
end
