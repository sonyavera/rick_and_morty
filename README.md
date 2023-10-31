# README

Rick and Morty Email Notifications for Serge

## Overview
This project uses Sidekiq to run a scheduled job every 30  minutes to fetch data from the Rick and Morty GraphQL API. Any new characters are stored in a local database. Serge is sent an email detailing the number of new records stored in the db and number of total records pulled from the API. 

## Prerequisites
Ruby 2.7+
Rails 6.1+
PostgreSQL

## Dependencies
VCR and Webmock for mocking HTTP requests in tests
RSpec for testing
Sidekiq for background jobs

## Installation
Clone the repository.

`bundle install`

`rails db:create`
`rails db:migrate`

`rails s`

## Usage

# Starting the Sidekiq Worker
1. Configure Redis: Ensure that you have Redis properly configured in your Rails application. Sidekiq uses Redis as its backend for job processing.
2. Run Sidekiq: To start the Sidekiq worker, open your terminal and navigate to your project's root directory and run the following command:

`bundle exec sidekiq`

To fetch and store new characters manually, you can trigger the CharacterService.fetch_and_store_characters method.

Run `rspec` to run tests.

## Known Issues
For the simplicity of the assignment, the application uses the Rick and Morty API's character ID as the primary key for character records. For better data integrity, a separate internal ID should be implemented.
