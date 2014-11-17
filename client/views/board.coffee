Template.board.events

  # update delete board
  'keydown input[name=editBoard]': (e) ->
    if e.which is 13 and e.target.value.length isnt 0
      Boards.update @board._id, $set: name: e.target.value

  'click .trash-icon': (e) ->
    Boards.update @board._id, $set: archivedAt: moment().jp().format()
