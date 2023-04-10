shared_examples 'API List' do
  it 'returns list of objects' do
    expect(resource.size).to eq list_size
  end
end
