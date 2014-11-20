Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'

  onBeforeAction: ->
    if Meteor.user()
      Meteor.subscribe 'boards'

Router.map ->
  @route 'login',
    path: '/login'
    template: 'login'

  @route 'join',
    path: '/join',
    template: 'join'

  @route 'board',
    path: '/b/:_boardId',
    template: 'board',
    onBeforeAction: ->
      if Meteor.user()
        Session.set 'findUserQuery', ''
        Meteor.subscribe 'users'
        Meteor.subscribe 'lists', @params._boardId
        Meteor.subscribe 'items', @params._boardId
        Meteor.subscribe 'tags', @params._boardId
        Meteor.subscribe 'notification', @params._boardId
        Meteor.subscribe 'notificationHandler', @params._boardId
      else
        Router.go('login')
    data: ->
      board: Boards.findOne @params._boardId

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
