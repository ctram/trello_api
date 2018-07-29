RSpec.shared_examples 'check authorization' do |request_action, model|
  let(:title) { 'title'.freeze }
  let(:name) { 'name'.freeze }

  let(:board) { Board.create(title: title, name: name ) }
  let(:column) { board.columns.create(title: title, name: name) }
  let(:task) { column.tasks.create(title: title, name: name) }
  let(:comment) { task.comments.create(content: 'hehe') }

  def paths(model)
    {
      board: %w[/boards /boards/1],
      column: %w[/boards/1/columns /columns/1],
      task: %w[/columns/1/tasks /tasks/1],
      comment: %w[/tasks/1/comments /comments/1]
    }[model.to_s.downcase.to_sym]
  end

  def method_verb(request_action)
    {
      index: :get,
      create: :post,
      show: :get,
      update: :put,
      destroy: :delete
    }[request_action]
  end

  it "#{request_action} receives a 401 unless authorized" do
    path = %i[index create].include?(request_action) ? paths(model).first : paths(model).last
    method(method_verb(request_action)).call(path)
    expect(response.status).to be 401
  end
end
