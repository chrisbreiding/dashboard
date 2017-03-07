Ember = require 'ember'
App = require '../app'

App.WebPageComponent = Ember.Component.extend

  tagName: 'iframe'

  attributeBindings: [
    'src'
    'frameborder'
    'marginheight'
    'marginwidth'
    'scrolling'
    'sandbox'
  ]

  frameborder: 0
  marginheight: 0
  marginwidth: 0
  scrolling: (->
    if @get('scrollable') then 'yes' else 'no'
  ).property 'scrollable'

  sandbox: (->
    if @get 'sandboxed'
      'allow-same-origin allow-scripts'
    else
      null
  ).property 'sandboxed'
