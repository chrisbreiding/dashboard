Ember = require 'ember'
App = require '../app'
_ = require 'lodash'
Pusher = require 'pusher'
events = require './events'

App.PusherController = Ember.Controller.extend

  needs: ['application', 'panes']

  setupEvents: ->
    @store.fetch(['pusherApiKey', 'slackChannelName']).then ([pusherApiKey, channelName]) =>
      if pusherApiKey
        pusher = new Pusher pusherApiKey
        @set 'pusher', pusher
      @_subscribeToChannel((channelName or '').toLowerCase())

      App.eventBus.on 'pusherApiKeyUpdated', @_apiKeyUpdated.bind(this)
      App.eventBus.on 'slackChannelNameUpdated', @_channelNameUpdated.bind(this)

      channel = @get 'channel'

      return unless channel

      _.each events, (handler, event)=>
        fn = if _.isFunction handler
          handler
        else
          (data)->
            args = _.map handler, (arg)-> encodeURIComponent data[arg]
            Ember.run => @transitionToRoute "panes.#{event}", args...

        channel.bind event, fn.bind(this)

  _apiKeyUpdated: (apiKey)->
    if apiKey
      @set 'pusher', new Pusher apiKey
      store.fetch('slackChannelName').then (channelName = '') ->
        @_resubscribeToChannel(channelName.toLowerCase())

  _channelNameUpdated: (channelName)->
    @_resubscribeToChannel channelName.toLowerCase()

  _subscribeToChannel: (channelName)->
    if channelName
      @set 'channel', @get('pusher').subscribe(channelName)

  _resubscribeToChannel: (channelName)->
    @get('channel')?.unbind()
    @_subscribeToChannel channelName
    @setupEvents()
