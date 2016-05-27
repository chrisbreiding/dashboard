require './image/route'
require './text/route'
require './url/route'
require './youtube/route'

sounds = require '../shared/sounds'

module.exports =
  image: ['url', 'duration']
  text: ['text', 'sender', 'duration']
  url: ['url', 'duration']
  youtube: ['id']

  reload: ->
    @transitionToRoute 'panes'
    Ember.run.later -> location.reload true

  seturl: (data)->
    panesController = @get 'controllers.panes'
    if data.paneId and data.url
      panesController.send 'setPaneUrl', data.paneId, data.url
    else
      panesController.send 'showPaneIds'

  share: (data)->
    if data.end and @get('shareWindow')
      @get('shareWindow').close()
      @set 'shareWindow', null
    else if !@get('shareWindow')
      @set 'shareWindow', window.open('http://appear.in/cypress', 'Cypress appear.in Room')

  sound: (data)->
    sound = sounds[data.sound] or data.sound
    @get('controllers.application').send 'playSound', sound
