_ = require 'lodash'
Ember = require 'ember'
App = require '../app'

Promise = Ember.RSVP.Promise

localData = JSON.parse(localStorage[App.NAMESPACE] or '{}')

local =
  fetch: (keyOrArray) ->
    value = if _.isArray(keyOrArray)
      _.map keyOrArray, (key) -> localData[key]
    else
      localData[keyOrArray]
    Promise.resolve(value)

  save: (key, value) ->
    localData[key] = value
    @_save()
    Promise.resolve(value)

  remove: (key) ->
    delete localData[key]
    @_save()
    Promise.resolve()

  _save: ->
    localStorage[App.NAMESPACE] = JSON.stringify(localData)

remote = {}

Store = Ember.Object.extend

  fetch: (key) ->
    @_getStore().then (store) -> store.fetch(key)

  save: (key, value) ->
    @_getStore().then (store) -> store.save(key, value)

  remove: (key) ->
    @_getStore().then (store) -> store.remove(key)

  local: local

  _getStore: ->
    if @_store
      Promise.resolve(@_store)
    else
      local.fetch(['firebaseName', 'firebaseKey']).then ([name, key]) ->
        persistRemotely = name? and key?
        @_store = if persistRemotely then remote else local

Ember.Application.initializer
  name: 'store'

  initialize: (container, application)->
    container.register 'store:main', Store

    application.inject 'controller', 'store', 'store:main'
    application.inject 'route', 'store', 'store:main'
