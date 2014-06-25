![](http://f.cl.ly/items/1Y1K1Q0I1H1l2D1n1A24/Screen%20Shot%202013-07-09%20at%209.55.30%20AM.png)

# Purpose

ETFlex aims to make the Energy Transition Model accessible to ordinary people
who want to learn more about the subject, as well as help QI better serve
educational users.

Most of the application is implemented in **CoffeeScript** and can be found in
`/client`, while Rails serves up little more than a *REST API*.

## Installation

 1. Copy `config/database.sample.yml` and `config/etflex.sample.yml` to
    `config/database.yml` and `config/etflex.yml` respectively. Edit any
    settings as necessary for your local machine.

 2. Install the Qt framework (see "Running the Tests" below for more
    information). This is required when installing Gems for the "test"
    environment, and is not needed for production installs.

 3. `bundle install`

 4. After creating your new database, run `rake db:setup db:seed` to add the
    tables, and some initial seed data.

## Runtime Options

You can customise the ETFlex experience by including certain options as part of
the URL query string.

#### `who=GuestName`

Any GET request for an HTTP resource (i.e. the root page, /scenes/:id, etc) may
include an optional `who` parameter:

```
http://beta.etflex.et-model.com/?who=Jeff
http://beta.etflex.et-model.com/scenes/1?who=Britta
```

This will set the name of the guest user. If the visitor has been to the ETFlex
site previously then either the name will be updated (if they opted not to enter
a name on their previous visit), or a new session will be created if the name
differs from the one we stored.

#### `scores=(off|no|false|hide|on|yes|true|show)`

Disables or enables the display of high scores. When disabled, the high score
"podium" prop is removed from scenario pages, and the high score lists will be
hidden on both scenario pages and the root page.

```
http://beta.etflex.et-model.com/?scores=off
http://beta.etflex.et-model.com/?scores=on
http://beta.etflex.et-model.com/scenes/1/with/348179?scores=hide
```

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
