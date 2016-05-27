Ember = require 'ember'

module.exports = Ember.Object.extend

  run: ->
    new Ember.RSVP.Promise (resolve)=>
      @get('store').remove 'standupUrl'

      resolve()
