Ember = require 'ember'
App = require '../../app'
VersionAssistant = require './version_assistant'
migrations = require './manifest'

module.exports = Ember.Object.extend

  runMigrations: ->
    @_currentVersion().then (currentVersion) =>
      return if currentVersion is App.VERSION

      versions = @_getVersionsSince currentVersion
      operations = (@_runMigration version for version in versions)

      Ember.RSVP.all(operations).then =>
        @get('store').local.save 'appVersion', App.VERSION

  _currentVersion: ->
    @get('store').local.fetch('appVersion').then (version) ->
      version ? '0.0.0'

  _getVersionsSince: (currentVersion)->
    versionAssistant = VersionAssistant.create versions: Object.keys(migrations)
    versionAssistant.versionsSince currentVersion

  _runMigration: (version)->
    console.log "running migration for version #{version}"
    migrations[version].create(store: @get('store')).run()
