App.ItemPickerComponent = Ember.Component.extend

  expanded: false

  didInsertElement: ->
    Ember.$('body').on 'click.expansion', =>
      @set 'expanded', false

  willDestroy: ->
    Ember.$('body').off 'click.expansion'

  curatedItems: (->
    withCurrent =_.map @get('items'), (item)=>
      item.set('current', @get('currentItemId') is item.get('id'))
    withCurrent.sort (a, b)->
      b.get('current') - a.get('current')
  ).property 'items', 'currentItemId'

  actions:

    toggleExpansion: ->
      @toggleProperty 'expanded'
      return

    selectItem: (item)->
      @set 'expanded', false
      @sendAction 'onSelect', item if not item.get('current')
