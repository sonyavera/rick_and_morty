require 'rails_helper'
require 'sidekiq/testing'
require 'vcr'

Sidekiq::Testing.fake!

RSpec.describe CharacterFetchWorker, type: :worker do
  before(:each) do
    Sidekiq::Worker.clear_all
  end

  after(:each) do
    Sidekiq::Worker.clear_all
  end

  it 'adds jobs to the queue' do
    expect {
      CharacterFetchWorker.perform_async
    }.to change(CharacterFetchWorker.jobs, :size).by(1)
  end

  it 'works with perform' do
    VCR.use_cassette("character_fetch_worker_perform") do
      expect {
        CharacterFetchWorker.new.perform
      }.to change(Character, :count).by(20)
    end
  end

  it 'works when draining the queue' do
    VCR.use_cassette("character_fetch_worker_drain_queue") do
      CharacterFetchWorker.perform_async
      expect(CharacterFetchWorker.jobs.size).to eq(1)
      Sidekiq::Worker.drain_all
      expect(CharacterFetchWorker.jobs.size).to eq(0)
    end
  end
end
