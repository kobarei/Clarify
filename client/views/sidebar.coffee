Template.sidebar.helpers
  boards: ->
    Boards.find active: true

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
      Boards.insert
        user: Meteor.user()
        name: e.target.value
        active: true
      e.target.value = ""
