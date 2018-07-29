RSpec.shared_context 'test objects' do
  let(:comment) { FactoryBot.create :comment }
  let(:task) { comment.task }
  let(:column) { task.column }
  let(:board) { column.board }
end
