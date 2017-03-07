Ember = require 'ember'

module.exports = Ember.Object.extend

  run: ->
    @get('store').local.remove 'standupUrl'
