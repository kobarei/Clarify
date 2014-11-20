@Notifications = new Mongo.Collection 'notification'

@Boards = new Mongo.Collection 'boards'

@Boards.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc, fields, modifier) ->
    true
  remove: (userId, doc) ->
    true

@Lists = new Mongo.Collection 'lists'

@Lists.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc, fields, modifier) ->
    true
  remove: (userId, doc) ->
    true

@Items = new Mongo.Collection 'items'

@Items.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc, fields, modifier) ->
    doc.user._id is userId
  remove: (userId, doc) ->
    doc.user._id is userId

@Tags = new Mongo.Collection 'tags'

@Tags.allow
  insert: (userId, doc) ->
    true
  update: (userId, doc, fields, modifier) ->
    true
  remove: (userId, doc) ->
    true
