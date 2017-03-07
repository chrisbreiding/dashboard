Ember = require 'ember'

module.exports = Ember.Object.extend

  run: ->
    @get('store').local.fetch('panes').then (panes) =>
      for pane, index in panes
        pane.id = index
      @get('store').local.save 'panes', panes
