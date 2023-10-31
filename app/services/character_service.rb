require 'net/http'
require 'json'

class CharacterService
  GRAPHQL_ENDPOINT = URI('https://rickandmortyapi.com/graphql')

  def self.fetch_and_store_characters
    new_characters_count = 0
    total_characters_count = 0

    response_data = fetch_characters_from_api
    return 0 if response_data['errors']

    characters = extract_character_data(response_data)
    characters.each do |character_data|
      total_characters_count += 1
      if create_or_update_character(character_data)
        new_characters_count += 1
      end
    end

    CharacterMailer.character_update_email(new_characters_count, total_characters_count).deliver_now
    { new_characters: new_characters_count, total_characters: total_characters_count }
  end

  private

  def self.fetch_characters_from_api
    query_string = File.read("app/graphql/character_query.graphql")
    req = Net::HTTP::Post.new(GRAPHQL_ENDPOINT, 'Content-Type' => 'application/json')
    req.body = { query: query_string }.to_json

    res = Net::HTTP.start(GRAPHQL_ENDPOINT.hostname, GRAPHQL_ENDPOINT.port, use_ssl: GRAPHQL_ENDPOINT.scheme == 'https') do |http|
      http.request(req)
    end

    JSON.parse(res.body)
  rescue JSON::ParserError => e
    Rails.logger.error("JSON Parsing failed: #{e.message}")
    {}
  rescue => e
    Rails.logger.error("An unexpected error occurred: #{e.message}")
    {}
  end

  def self.extract_character_data(response_data)
    response_data.dig('data', 'characters', 'results') || []
  end

  def self.create_or_update_character(character)
    episode_ids_string = character['episode'].map { |episode| episode['id'] }.join('')

    new_character = Character.find_or_initialize_by(id: character['id']) do |c|
      populate_character_attributes(c, character, episode_ids_string)
    end
  
    if new_character.new_record?
      if new_character.save
        Rails.logger.info("New character created: #{new_character.id}")
        return true
      else
        Rails.logger.error("Failed to create new character with id #{character['id']}: #{new_character.errors.full_messages.join(", ")}")
        return false
      end
    else
      Rails.logger.info("Character already exists: #{new_character.id}")
      return false
    end
  end
  
  def self.populate_character_attributes(character_obj, character_data, episode_ids_string)
    character_obj.name = character_data['name']
    character_obj.status = character_data['status']
    character_obj.species = character_data['species']
    character_obj.character_type = character_data['type']
    character_obj.gender = character_data['gender']
    character_obj.origin = character_data.dig('origin', 'name') || 'Unknown'
    character_obj.location = character_data.dig('location', 'name') || 'Unknown'
    character_obj.image = character_data['image']
    character_obj.episode = episode_ids_string
    character_obj.url = character_data['url']
    character_obj.created = DateTime.parse(character_data['created'])
  end  
end
