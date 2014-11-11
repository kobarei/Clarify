ERRORS_KEY = "loginErrors"

Template.login.created = ->
  console.log 'accounts-login'
  Session.set ERRORS_KEY, {}

Template.login.helpers
  errorMessages: ->
    _.values Session.get(ERRORS_KEY)

  errorClass: (key) ->
    Session.get(ERRORS_KEY)[key] and "error"

Template.login.events submit: (event, template) ->
  event.preventDefault()

  email    = template.$("[name=email]").val()
  password = template.$("[name=password]").val()

  errors          = {}
  errors.email    = "Email is required"  unless email
  errors.password = "Password is required"  unless password

  Session.set ERRORS_KEY, errors
  return  if _.keys(errors).length

  Meteor.loginWithPassword email, password, (error) ->
    if error
      return Session.set(ERRORS_KEY,
        none: error.reason
      )
    Router.go "index"
