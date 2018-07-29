RSpec.shared_context 'test objects' do
  let(:comment) { FactoryBot.create :comment }
  let(:task)    { FactoryBot.create :task }
  let(:column)  { FactoryBot.create :column }
  let(:board)   { FactoryBot.create :board }
end
