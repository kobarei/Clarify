Meteor.publish "boards", () ->
  Boards.find()

Meteor.publish "lists", (boardId) ->
  check boardId, String
  Lists.find
    boardId: boardId
    status: "active"

Meteor.publish "items", (boardId) ->
  check boardId, String
  Items.find
    boardId: boardId
