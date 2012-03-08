````
                         _____   _______     _____   __        _____   __  __   
                        /\_____\/\_______)\ /\_____\ /\_\     /\_____\/\  /\  /\ 
                       ( (_____/\(___  __\/( (  ___/( ( (    ( (_____/\ \ \/ / / 
                        \ \__\    / / /     \ \ \_   \ \_\    \ \__\   \ \  / /  
                       ( (_____\  \ \ \    / /____/ ( (_____(( (_____\/ / /\ \ \ 
                         / /__/_  ( ( (     / / /_\  / / /__  / /__/_  / /  \ \  
                        \/_____/  /_/_/    \/_/      \/_____/ \/_____/\/__\/__\/ 

````

# Purpose

ETFlex aims to make the Energy Transition Model accessible to ordinary people
who want to learn more about the subject, as well as help QI better serve
educational users.

Most of the application is implemented in CoffeeScript and can be found in
/client, while Rails serves up little more than a REST API.

## Installation


 1. Copy config/database.sample.yml to config/database.yml. Edit any settings
    as necessary for your local machine.

 2. Use Ruby 1.9.3 p0 or newer.
    rbenv: `rbenv local 1.9.3-p0`
    RVM: Create an .rvmrc with "rvm gemset use 1.9.3" then `rvm rvmrc load`.

 3. Install the Qt framework (see "Running the Tests" below for more
    information). This is one required when installing Gems for the "test"
    environment, and is not needed for production installs.

 4. `bundle install`

## Running the Tests

The ETFlex integration tests use the capybara-webkit Gem to do headless
full-stack tests, which include the JavaScript client. In order to run these
you will first need to install the Qt4 framework. Mac OS X users with Homebrew
should be able to achieve this simply by running

  `$ brew install qt`

Full instructions can be found on the [capybara-webkit wiki](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-QT)
