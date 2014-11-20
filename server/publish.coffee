Meteor.publish "users", () ->
  Meteor.users.find()

Meteor.publish "boards", () ->
  Boards.find
    users:
      $elemMatch:
        _id: @userId
    archivedAt: $exists: false

Meteor.publish "lists", (boardId) ->
  check boardId, String
  Lists.find
    boardId: boardId
    archivedAt: $exists: false

Meteor.publish "items", (boardId) ->
  check boardId, String
  Items.find
    boardId: boardId
    archivedAt: $exists: false

Meteor.publish "tags", (boardId) ->
  check boardId, String
  Tags.find
    boardId: boardId

Meteor.publish "notificationHandler", (boardId) ->
  initialized = false
  itemHandle = Items.find(boardId: boardId).observeChanges
    added: (id, fields) ->
      if initialized
        Notifications.insert
          itemId: fields._id
          user: fields.user.username
          action: "カードを作成"
          boardId: boardId

    changed: (id, fields) ->
      unless fields.archivedAt?
        Notifications.insert
          itemId: fields._id
          user: fields.user.username
          action: "カードを変更"
          boardId: boardId

    removed: (id) ->
      console.log 'REMOVED'

  initialized = true

  @ready()

  @onStop ->
    itemHandle.stop()

Meteor.publish "notification", (boardId) ->
  check boardId, String
  Notifications.find boardId: boardId
