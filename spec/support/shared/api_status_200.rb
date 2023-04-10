shared_examples_for 'Status be_successful' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end
