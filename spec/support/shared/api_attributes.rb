shared_examples_for 'Returns all public fields' do
  it 'returns all public fields' do
    attributes.each do |attr|
      expect(resource[attr]).to eq object.send(attr).as_json
    end
  end
end

shared_examples_for 'Does not return private fields' do
  it 'does not returns private fields' do
    %w[ password encrypted_password ].each do |attr|
      expect(json).to_not have_key(attr)
    end
  end
end
