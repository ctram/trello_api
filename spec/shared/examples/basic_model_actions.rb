RSpec.shared_examples 'basic model_class actions' do |model_class|
  let(:name) { 'My Name' }
  let(:title) { 'My Title' }
  let(:instance) { model_class.create(name: name, title: title) }

  it 'is created with name and title' do
    expect(instance.name).to eq(name)
    expect(instance.title).to eq(title)
  end

  it 'requires name and title' do
    instance = model_class.new
    expect(instance.valid?).to be false
  end

  it 'updates with new name and title' do
    instance.update(name: 'Hot Sauce', title: 'Mild Sauce')
    expect(instance.name).to eq('Hot Sauce')
    expect(instance.title).to eq('Mild Sauce')
  end

  it 'is destroyed' do
    instance.destroy
    expect(model_class.all.length).to be 0
  end
end