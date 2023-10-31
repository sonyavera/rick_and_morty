namespace :character_data do
    task fetch_and_store: :environment do
      CharacterService.fetch_and_store_characters
    end
  end
  