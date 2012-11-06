# OpenTok Code:
apiKey = "21393201"
publisher = TB.initPublisher apiKey, 'myPublisher', {width:400, height:300}

# When user submits form, take a picture
$("#new_client").submit ->
  imgData = publisher.getImgData()
  if imgData?
    $("#client_imgdata").val( imgData )
    $("#new_client")[0].submit()
  else
    alert "Please allow chrome to access your camera"
  return false


# BackboneJS
class RoomClass extends Backbone.Model

class RoomsClass extends Backbone.Collection
  model: RoomClass
  url: "/rooms"

class RoomView extends Backbone.View
  template: Handlebars.compile( $("#room-template").html() )
  events:
    "click .room_view" : "enterRoom"
  enterRoom: ->
    $('#client_room_id').val( @model.get('id') )
  render: ->
    @$el.html @template(@model.toJSON())
    return @


class RoomsView extends Backbone.View
  el: "#roomList"
  template: Handlebars.compile( $("#room-template").html() )
  initialize: ->
    @collection.on 'reset', @render
    @collection.fetch()
  render: (data) =>
    @$el.empty()
    for model in data.models
      console.log model.get('clients')
      view = new RoomView {model:model}
      @$el.append view.render().el

rooms = new RoomsClass()
roomsView = new RoomsView collection:rooms


# TODO: When new members are updated via pusher, the corresponding room member and pictures should be updated.
#
# TODO: When new room is created, new view should be created
source = $("#room-template").html()
roomTemplate = Handlebars.compile(source)

pusher = new Pusher('9b96f0dc2bd6198af8ed')
channel = pusher.subscribe('newroom')

channel.bind 'new', (data) ->
  $('table').append( roomTemplate(data) )

$('.room_view').click ->

