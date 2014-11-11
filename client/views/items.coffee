dragSrc = null
dragSrcId = null

refleshItemForm = (form) ->
  form[0].value = ''
  form[1].value = '00:00'

Template.items.helpers
  currentUserIs: (user) ->
    Meteor.user()._id is user._id

Template.items.events

  'dragstart .item': (e) ->
    dragSrc = @status
    dragSrcId = @_id

  'dragenter .panel': (e) ->
    if dragSrc isnt @status
      $(e.target.querySelector('.drop-pos')).addClass 'drop-pos-open'

  'dragover .drop-pos': (e) ->
    e.preventDefault()

  'drop .drop-pos-open': (e) ->
    $('.drop-pos').removeClass('drop-pos-open')
    if dragSrc isnt @status
      Items.update dragSrcId, $set: status: @status

  'dragend': (e) ->
    $('.drop-pos').removeClass('drop-pos-open')

  'click .submit-new-task': (e) ->
    e.preventDefault()
    form = $(e.target).parent().children()
    if form[0].value.length isnt 0
      date = new Date()
      Items.insert
        name: form[0].value
        user: Meteor.user()
        estimateTime: form[1].value
        status: @status
        boardId: location.href.match(/\/b\/(.+)/)[1]
        createdAt: date.getTime()
      refleshItemForm form

  'keydown input[name=editList]': (e) ->
    if e.which is 13 and e.target.value.length isnt 0
      e.preventDefault()
      Lists.update @_id, $set: name: e.target.value

  'click .trash-icon': (e) ->
    Boards.update @board._id, $set: active: false

  'mouseenter .item': (e) ->
    e.target.focus()
