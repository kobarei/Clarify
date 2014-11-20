Template.tags.helpers
  boardUsers: () ->
    @board.users

  tags: () ->
    Tags.find()

  users: () ->
    Meteor.users.find(username: new RegExp(Session.get 'findUserQuery')).fetch()

Template.tags.events
  # list
  'keydown input[name=addLists]': (e) ->
    if e.which is 13 and e.target.value.length isnt 0
      Lists.insert
        name: e.target.value
        boardId: @board._id
        createdAt: moment().jp().format()
      e.target.value = ""

  # member
  'keyup input[name=addMembers]': (e) ->
    unless e.target.value.length is 0
      Session.set 'findUserQuery', e.target.value
      $('[name=list-members]').addShow()

  'blur input[name=addMembers]': (e) ->
    $('[name=list-members]').addHide() if e.target.value.length is 0

  'click .user-preview': (e) ->
    Boards.update Template.parentData(1).board._id,
      $addToSet: users: @
    $('input[name=addMembers]').val("")
    $('[name=list-members]').toggleDisplay()

  # tag
  'keyup input[name=newTag]': (e) ->
    $('[name=btn-class]').find('.tag-preview').html e.target.value
    $('[name=btn-class]').addShow()

  'blur input[name=newTag]': (e) ->
    $('[name=btn-class]').addHide() if e.target.value.length is 0

  'click .tag-preview': (e) ->
    Tags.insert
      name: e.target.innerHTML
      boardId: @board._id
      colorClass: e.target.className.match(/btn-(.*)/)[0]
      count: 0
      createdAt: moment().jp().format()
    $('input[name=newTag]').val("")
    $('[name=btn-class]').toggleDisplay()