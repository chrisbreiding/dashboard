_ = require 'lodash'
Ember = require 'ember'
firebase = require 'firebase'
App = require '../app'

Promise = Ember.RSVP.Promise

localData = JSON.parse(localStorage[App.NAMESPACE] or '{}')

localStore =
  fetch: (keyOrArray) ->
    value = if _.isArray(keyOrArray)
      _.map keyOrArray, (key) -> localData[key]
    else if not keyOrArray?
      localData
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

class RemoteStore
  constructor: (appName, apiKey) ->
    @_app = firebase.initializeApp({
      apiKey: apiKey
      authDomain: "#{appName}.firebaseapp.com"
      databaseURL: "https://#{appName}.firebaseio.com"
      storageBucket: "#{appName}.appspot.com"
    })

  auth: ->
    firebase.auth().signInAnonymously().catch (error) ->
      console.error('Failed to authenticate', error)

  fetch: (keyOrArray) ->
    @_ensureData().then =>
      if _.isArray(keyOrArray)
        _.map keyOrArray, (key) => @_data[key]
      else if not keyOrArray?
        @_data
      else
        @_data[keyOrArray]

  save: (keyOrObject, value) ->
    @_ensureData().then =>
      if _.isPlainObject(keyOrObject)
        _.each keyOrObject, (value, key) =>
          @_data[key] = value
      else
        @_data[keyOrObject] = value
      @_save().then -> value

  remove: (key) ->
    @_ensureData().then =>
      delete @_data[key]
      @_save()

  sync: ->
    @fetch().then (data) =>
      return if _.size(data)

      localStore.fetch().then (data) =>
        data = _.omit(data, 'appVersion', 'firebaseName', 'firebaseKey')
        @save(data)

  _ref: ->
    @_app.database().ref()

  _ensureData: ->
    new Promise (resolve) =>
      return resolve() if @_data

      @_ref().child('/').once 'value', (snapshot) =>
        @_data = snapshot.val() or {}
        resolve()

  _save: ->
    new Promise (resolve) =>
      @_ref().child('/').update(@_data, resolve)

Store = Ember.Object.extend
  fetch: (key) ->
    @_store.fetch(key)

  save: (key, value) ->
    @_store.save(key, value)

  remove: (key) ->
    @_store.remove(key)

  local: localStore

  setup: ->
    localStore.fetch(['firebaseName', 'firebaseKey']).then ([name, key]) =>
      if name and key
        @_store = new RemoteStore(name, key)
        @_store.auth().then =>
          @_store.sync()
      else
        @_store = localStore

Ember.Application.initializer
  name: 'store'

  initialize: (container, application)->
    container.register 'store:main', Store

    application.inject 'controller', 'store', 'store:main'
    application.inject 'route', 'store', 'store:main'
