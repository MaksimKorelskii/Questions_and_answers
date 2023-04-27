require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :index, SearchController }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)       { create(:user) }
    let(:other_user) { create(:user) }

    let(:user_question)  { create(:question, author: user) }
    let(:other_question) { create(:question, author: other_user) }

    let(:user_answer)  { create(:answer, question: user_question, author: user) }
    let(:other_answer) { create(:answer, question: other_question, author: other_user) }

    let(:user_link)  { create(:link, linkable: user_question) }
    let(:other_link) { create(:link, linkable: other_question) }

    let(:user_question_attachment) do
      create(:question, :with_file, author: user).files.first
    end

    let(:other_question_attachment) do
      create(:question, :with_file, author: other_user).files.first
    end

    let(:user_answer_attachment) do
      create(:answer, :with_file, question: user_question, author: user).files.first
    end

    let(:other_answer_attachment) do
      create(:answer, :with_file, question: other_question, author: other_user).files.first
    end

    let(:other_question_subscription) do
      other_question.subscriptions.find_by!(subscriber: other_user)
    end

    context 'for all' do
      it { should     be_able_to :read,   :all }
      it { should_not be_able_to :manage, :all }
    end

    context 'Question' do
      context '#create' do
        it { should be_able_to :create, Question }
      end

      context '#update' do
        it { should     be_able_to :update, user_question }
        it { should_not be_able_to :update, other_question }
      end

      context '#destroy' do
        it { should     be_able_to :destroy, user_question }
        it { should_not be_able_to :destroy, other_question }
      end

      context '#uprate' do
        it { should     be_able_to :uprate, other_question }
        it { should_not be_able_to :uprate, user_question }
      end

      context '#downrate' do
        it { should     be_able_to :downrate, other_question }
        it { should_not be_able_to :downrate, user_question }
      end
    end

    context 'Answer' do
      context '#create' do
        it { should be_able_to :create, Answer }
      end

      context '#update' do
        it { should     be_able_to :update, user_answer }
        it { should_not be_able_to :update, other_answer }
      end

      context '#destroy' do
        it { should     be_able_to :destroy, user_answer }
        it { should_not be_able_to :destroy, other_answer }
      end

      context '#uprate' do
        it { should     be_able_to :uprate, other_answer }
        it { should_not be_able_to :uprate, user_answer }
      end

      context '#downrate' do
        it { should     be_able_to :downrate, other_answer }
        it { should_not be_able_to :downrate, user_answer }
      end

      context '#mark_as_best' do
        it { should     be_able_to :mark_as_best, user_answer }
        it { should_not be_able_to :mark_as_best, other_answer }
      end
    end

    context 'Link' do
      context '#destroy' do
        it { should     be_able_to :destroy, user_link }
        it { should_not be_able_to :destroy, other_link }
      end
    end

    context 'Attachment' do
      context '#destroy for question' do
        it { should     be_able_to :destroy, user_question_attachment }
        it { should_not be_able_to :destroy, other_question_attachment }
      end

      context '#destroy for answer' do
        it { should     be_able_to :destroy, user_answer_attachment }
        it { should_not be_able_to :destroy, other_answer_attachment }
      end
    end

    context 'Comment' do
      context '#create' do
        it { should be_able_to :create, Comment }
      end

      context '#create_comment for question' do
        it { should be_able_to :create, Question }
      end

      context '#create_comment for answer' do
        it { should be_able_to :create, Answer }
      end
    end

    context 'Subscription' do
      describe '#create' do
        it { should be_able_to :create, Subscription }
      end

      describe '#destroy' do
        it { should     be_able_to :destroy, Subscription }
      end
    end
  end
end
