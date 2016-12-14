App.widget_data = App.cable.subscriptions.create channel: 'WidgetDataChannel', widget: 'who_is_home',
  connected: ->
    console.log('connected')

  disconnected: ->
    console.log('disconnected')

  received: (data) ->
    console.log('received data:', data)
    window.whoIsHomeWidget.renderData(data)

class WhoIsHomeWidget
  _this = undefined

  constructor: ->
    _this = this

    this.$widget = $('.widget .who-is-home')
    this.template = this.$widget[0].innerHTML

    this.renderData(this.$widget.data('data'))

  renderData: (data) ->
    this.render(this.template, data)

  render: (template, data) ->
    renderedTemplate = Mustache.render(template, data)
    this.$widget.html(renderedTemplate)

$(document).ready ->
  window.whoIsHomeWidget = new WhoIsHomeWidget()
