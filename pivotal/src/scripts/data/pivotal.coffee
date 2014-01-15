BASE_URL = 'https://www.pivotaltracker.com/services/v5/'

Pivotal = Ember.Object.extend

  init: ->
    token = localStorage.apiToken
    @set 'token', JSON.parse(token) if token

  isAuthenticated: ->
    @get('token')?

  setToken: (token)->
    localStorage.apiToken = JSON.stringify token
    @set 'token', token

  getProjects: ->
    @queryPivotal(url: 'projects').then (projects)->
      _.map projects, (project)->
        _.pick project, 'id', 'name'

  getProject: (id)->
    @queryPivotal(url: "projects/#{id}").then (project)->
      _.pick project, 'id', 'name'

  queryPivotal: (config)->
    $.ajax
      type: 'GET'
      url: "#{BASE_URL}#{config.url}"
      headers:
        'X-TrackerToken': @get 'token'

App.pivotal = Pivotal.create()