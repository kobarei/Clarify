ERRORS_KEY = "joinErrors"

Template.join.created = ->
  Session.set ERRORS_KEY, {}

Template.join.helpers
  errorMessages: ->
    _.values Session.get(ERRORS_KEY)

  errorClass: (key) ->
    Session.get(ERRORS_KEY)[key] and "error"

Template.join.events submit: (event, template) ->
  event.preventDefault()

  username = template.$("[name=username]").val()
  email    = template.$("[name=email]").val()
  password = template.$("[name=password]").val()
  confirm  = template.$("[name=confirm]").val()

  errors          = {}
  errors.username = "UserName required" unless username
  errors.email    = "Email required"    unless email
  errors.password = "Password required" unless password
  errors.confirm  = "Please confirm your password" if confirm isnt password

  Session.set ERRORS_KEY, errors
  return  if _.keys(errors).length

  Accounts.createUser
    username: username
    email: email
    password: password
  , (error) ->
    if error
      return Session.set(ERRORS_KEY,
        none: error.reason
      )
    Router.go "index"
