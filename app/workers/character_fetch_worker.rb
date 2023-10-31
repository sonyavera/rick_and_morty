class CharacterFetchWorker
    include Sidekiq::Worker
  
    def perform
      CharacterService.fetch_and_store_characters
    end
  end
  