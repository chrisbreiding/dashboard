Ember = require 'ember'

module.exports = Ember.Object.extend

  run: ->
    @get('store').local.save 'standupUrl', 'http://labs.tnwinc.com/storyboard'
