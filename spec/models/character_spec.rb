require 'rails_helper'

RSpec.describe Character, type: :model do
  it 'is valid with valid attributes' do
    character = Character.new(
      name: 'Rick',
      status: 'Alive',
      species: 'Human',
    )
    expect(character).to be_valid
  end

  it 'is not valid without a name' do
    character = Character.new(name: nil)
    expect(character).to_not be_valid
  end
end
