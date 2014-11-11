Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

  waitOn: ->
    Meteor.subscribe 'boards'
    Meteor.subscribe 'items', @params._boardId

Router.map ->
  @route 'login',
    path: '/login'
    template: 'login'

  @route 'join',
    path: '/join',
    template: 'join'

  @route 'items',
    path: '/b/:_boardId',
    template: 'items',
    data: ->
      packedItems = []
      _.each ["TODO", "DOING", "DONE"], (status) =>
        packedItems.push {
          status: status
          items: Items.find
            boardId: @params._boardId
            status: status
          ,
            sort: createdAt: -1
        }
      board: Boards.findOne @params._boardId
      status: packedItems

  @route 'index',
    path: '/',
    template: 'index'

#  @route 'foos_show',
#    path: '/foo/:_id',
#    template: 'foos_show'
#    waitOn: ->
#      return Meteor.subscribe('foos')
#    data: ->
#      return Foos.findOne({_id: @params._id})
