![](http://f.cl.ly/items/1Y1K1Q0I1H1l2D1n1A24/Screen%20Shot%202013-07-09%20at%209.55.30%20AM.png)

# Purpose

ETFlex aims to make the Energy Transition Model accessible to ordinary people
who want to learn more about the subject, as well as help QI better serve
educational users.

Most of the application is implemented in **CoffeeScript** and can be found in
`/client`, while Rails serves up little more than a *REST API*.

## Installation


 1. Copy `config/database.sample.yml` and `config/etflex.sample.yml` to respectively 
    `config/database.yml` and `config/etflex.yml`. Edit any settings
    as necessary for your local machine.

 2. Install the Qt framework (see "Running the Tests" below for more
    information). This is one required when installing Gems for the "test"
    environment, and is not needed for production installs.

 3. `bundle install`

## Running the Tests

The ETFlex integration tests use the capybara-webkit Gem to do headless
full-stack tests, which include the JavaScript client. In order to run these
you will first need to install the **Qt4 framework**. Mac OS X users with
Homebrew should be able to achieve this simply by running

  `$ brew install qt`

Full instructions can be found on the [capybara-webkit wiki](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-QT)

## Client Events

The CoffeeScript client implements the PubSub pattern to communicate between
different components:

    current-user.name.request-change ( String name )
      This is triggered when a component would like the main app.coffee module
      to change the name of the current user or guest. Typically occurs after
      the user enters their name when starting a scenario or achieving a high
      score.

    current-user.name.changed ( String name, User|Guest user )
      This event is triggered after the app has changed the user name in the
      client. Note that any HTTP request to persist the name change on the
      server may be pending. Components should respond to this event by
      changing the user name in the UI.
