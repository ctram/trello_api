RSpec.shared_examples 'check authorization' do |request_type, path, options|
  it 'receives a 401 unless authenticated' do
    method(request_type).call(path, options)
    expect(response.status).to be 401
  end
end
