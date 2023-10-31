# README

Rick and Morty Email Notifications for Serge

## Overview
This project uses Sidekiq to run a scheduled job every 30  minutes to fetch data from the Rick and Morty GraphQL API. Any new characters are stored in a local database. Serge is sent an email detailing the number of new records stored in the db and number of total records pulled from the API. 

## Prerequisites
Ruby 2.7+
Rails 6.1+
PostgreSQL

## Dependencies
Sidekiq
VCR and Webmock for mocking HTTP requests
RSpec for testing

## Installation
Clone the repository.

`bundle install`
`rails db:create`
`rails db:migrate`

Set up an .env file with your GMAIL_ADDRESS, GMAIL_PASSWORD, and MAIL_RECIPIENT. Use Serge's test email as the recipient per the instructions of the assignment. You  may need to generate an app password to use instead of using your actual gmail password. https://myaccount.google.com/apppasswords 

## Usage

# Starting the Sidekiq Worker (local)
1. Install and run Redis. https://redis.io/download
2. Run the rails server with `rails s` (optional, but helpful for seeing logs)
3. Run Sidekiq: `bundle exec sidekiq`

# Testing
Run `rspec` to run tests.

To fetch and store new characters manually, you can trigger the CharacterService.fetch_and_store_characters method.

## Future improvements
1. Generate separate internal character ID instead of using Ricky and Morty API character ID
2. Improve format of notification email and include details about characters
