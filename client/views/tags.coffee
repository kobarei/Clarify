Template.tags.helpers
  tags: () ->
    Tags.find()

  users: () ->
    Meteor.users.find(username: Session.get 'findUserQuery').fetch()

Template.tags.events
  # list
  'keydown input[name=addLists]': (e) ->
    if e.which is 13 and e.target.value.length isnt 0
      Lists.insert
        name: e.target.value
        boardId: @boardId
        createdAt: moment().jp().format()
      e.target.value = ""

  # member
  'keyup input[name=addMembers]': (e) ->
    Session.set 'findUserQuery', e.target.value
    $('[name=list-members]').addShow()

  'blur input[name=addMembers]': (e) ->
    $('[name=list-members]').toggleDisplay() if e.target.value.length is 0

  'click .user-preview': (e) ->
    Boards.update Template.parentData(1).board._id,
      $push: users: @
    $('input[name=addMembers]').val("")
    $('[name=list-members]').toggleDisplay()

  # tag
  'keyup input[name=newTag]': (e) ->
    $('[name=btn-class]').find('.tag-preview').html e.target.value
    $('[name=btn-class]').addShow()

  'blur input[name=newTag]': (e) ->
    $('[name=btn-class]').toggleDisplay() if e.target.value.length is 0

  'click .tag-preview': (e) ->
    Tags.insert
      name: e.target.innerHTML
      boardId: @boardId
      colorClass: e.target.className.match(/btn-(.*)/)[0]
      count: 0
      createdAt: moment().jp().format()
    $('input[name=newTag]').val("")
    $('[name=btn-class]').toggleDisplay()