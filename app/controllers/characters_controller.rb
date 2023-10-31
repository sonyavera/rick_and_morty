class CharactersController < ApplicationController
    def fetch_and_store
      CharacterService.fetch_and_store_characters
    end
  end
  