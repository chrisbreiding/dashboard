Ember = require 'ember'
App = require '../app'

App.SettingsController = Ember.ObjectController.extend

  needs: ['panes']

  content: {}

  keys: ['pusherApiKey', 'slackChannelName']
  localKeys: ['firebaseName', 'firebaseKey']

  setup: (->
    @_initValue key for key in @get('keys')
    @_initValue key, true for key in @get('localKeys')
  ).on 'init'

  _initValue: (key, isLocal) ->
    store = if isLocal then @store.local else @store
    store.fetch(key).then (value) =>
      @set key, value
      @set "original_#{key}", value

  _saveAndBroadcastValue: (key)->
    value = @get key
    if value isnt @get("original_#{key}")
      @set "original_#{key}", value
      isLocal = key in @get('localKeys')
      store = if isLocal then @store.local else @store
      store.save(key, value).then ->
        App.eventBus.trigger "#{key}Updated", value

  actions:
    save: ->
      @_saveAndBroadcastValue(key) for key in @get('keys')
      @_saveAndBroadcastValue(key) for key in @get('localKeys')
      @get('controllers.panes').send 'closeSettings'

    cancel: ->
      for key in @get('keys')
        @set key, @get("original_#{key}")
      for key in @get('localKeys')
        @set key, @get("original_#{key}")
      @get('controllers.panes').send 'closeSettings'
