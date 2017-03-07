Ember = require 'ember'
App = require '../app'
Migrator = require '../services/migrator/migrator'

require './application'
require './controller'

App.ApplicationRoute = Ember.Route.extend

  beforeModel: ->
    @store.setup().then =>
      Migrator.create(store: @store).runMigrations()

  afterModel: ->
    @controllerFor('pusher').setupEvents()
