App.PanesYoutubeRoute = Ember.Route.extend

  model: (params)->
    videoId: params.id

  actions:

    videoFinished: ->
      @transitionTo 'panes'
