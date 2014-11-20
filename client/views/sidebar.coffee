Template.sidebar.helpers
  boards: ->
    Boards.find()

Template.sidebar.events
  'click .login': () ->
    Router.go 'login'

  'click .logout': () ->
    Meteor.logout()

  'click .join': () ->
    Router.go 'join'

  'keydown input[type=text]': (e) ->
    if e.which is 13
      e.preventDefault()
      boardId = Boards.insert
        name: e.target.value
        users: [Meteor.user()]
        createdAt: moment().jp().format()
      _.each ["TODO", "DOING", "DONE"], (status) ->
        Lists.insert
          name: status
          boardId: boardId
          createdAt: moment().jp().format()
      e.target.value = ""
