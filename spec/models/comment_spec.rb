require_relative '../helpers/test_helper'
require_relative '../../app/models/comment'

RSpec.describe Comment do
  let(:comment) { Comment.create(content: 'blah blah') }

  it 'is created with content' do
    expect(comment.content).to eq('blah blah')
  end

  it 'requires content' do
    comment = Comment.new
    expect(comment.valid?).to be false
  end

  it 'updates content' do
    comment.update(content: 'other content')
    expect(comment.content).to eq('other content')
  end

  it 'is destroyed' do
    comment.destroy
    expect(Comment.count).to be 0
  end
end