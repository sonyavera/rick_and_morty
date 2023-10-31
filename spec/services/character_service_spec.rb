require 'rails_helper'
require 'vcr'
require 'rspec-sidekiq'
require 'sidekiq/testing'

Sidekiq::Testing.inline!

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

RSpec.describe CharacterService, type: :service do
  before(:each) do
    Character.destroy_all
  end

  it 'fetches character data from the GraphQL API and sends an email' do
    VCR.use_cassette('graphql_api', :record => :new_episodes) do
      expect(CharacterMailer).to receive(:character_update_email)
        .with(20, 20)
        .and_call_original

      result = CharacterService.fetch_and_store_characters
      expect(result[:new_characters]).to eq(20)
      expect(result[:total_characters]).to eq(20)
    end
  end

  it 'does not create duplicate records and email reflects only new characters', :vcr do
    Character.create(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human")
    expect(CharacterMailer).to receive(:character_update_email)
      .with(19, 20)
      .and_call_original

    result = CharacterService.fetch_and_store_characters
    expect(result[:new_characters]).to eq(19)
    expect(result[:total_characters]).to eq(20)
  end
end
