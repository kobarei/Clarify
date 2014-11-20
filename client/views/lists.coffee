dragSrcId = null

hideDropPos = (e) ->
  $('.drop-pos').removeClass('drop-pos-open').addHide()

Template.lists.rendered = () ->
  @autorun ->
    $('.lists').width Lists.find().count() * 310 + $('.tags').width()

Template.lists.helpers
  currentUserIs: (user) ->
    Meteor.user()._id is user._id

  lists: ->
    Lists.find()

  items: (listId) ->
    Items.find listId: listId

  date: ->
    moment().jp().format('YYYY-MM-DD')

Template.lists.events
  # Drag & Drop
  'dragstart .item': (e) ->
    dragSrcId = @_id

  'dragenter .panel-body': (e) ->
    dropPos = $(e.target).find('.drop-pos')
    dropPos.addClass('drop-pos-open').addShow()
    dropPos.height $(e.target).height()
    dropPos.width $(e.target).width()

  'dragleave .drop-pos-open': (e) ->
    hideDropPos()

  'dragover .drop-pos': (e) ->
    e.preventDefault()

  'drop .drop-pos-open': (e) ->
    hideDropPos()
    Items.update dragSrcId, $set: listId: @_id

  # Tag Suggest
  'keydown input[name=addTags]': (e) ->
    $(e.target).parent('.item-form').find('[name=suggestTags]').addShow()
    Session.set 'suggestTagsQuery', e.target.value

  'click .archive-list': (e) ->
    Lists.update @_id, $set: archivedAt: moment().jp().format()

  'click .archive-item': (e) ->
    @tags.forEach (tag) ->
      Tags.update tag._id, $inc: count: -1
    Items.update @_id, $set: archivedAt: moment().jp().format()

  # insert update Item
  'click .submit-new-task': (e) ->
    form = $(e.target).parent('.item-form')
    if form.find('textarea[name=newTask]').val().length isnt 0
      tags = Tags.find(name: $in: form.find('input[name=newTags]').val().split(','))
      tags.forEach (tag) ->
        Tags.update tag._id, $inc: count: 1
      Items.insert
        name: form.find('textarea[name=newTask]').val()
        user: Meteor.user()
        listId: @_id
        boardId: @boardId
        tags: tags.fetch()
        estimateTime: form.find('input[name=newEstimateTime]').val()
        limitDate: form.find('input[name=newLimitDate]').val()
        createdAt: moment().jp().format()

      form.bulkReset
        'textarea[name=newTask]': ''
        'input[name=newEstimateTime]': '00:00'
        'input[name=newLimitDate]': moment().jp().format('YYYY-MM-DD')

  # Open confirm & cancel buttons
  'keydown textarea[name=editTask],
   change input[name=editEstimateTime],
   change input[name=editLimitDate]': (e) ->
    $(e.target).parent('.item').find('.edit-task-btns').addShow()

  # Close confirm & cancel buttons
  'click .cancel-edit-task': (e) ->
    $(e.target).parents('.item').bulkReset
      'textarea[name=editTask]': @name
      'input[name=editEstimateTime]': @estimateTime
      'input[name=newLimitDate]': @limitDate

    $(e.target).parent().toggleDisplay()

  'click .submit-edit-task': (e) ->
    form = $(e.target).parent().parent()
    Items.update @_id,　$set:
      name: form.find('textarea[name=editTask]').val()
      estimateTime: form.find('input[name=editEstimateTime]').val()
      limitDate: form.find('input[name=editLimitDate]').val()
    $(e.target).parent().toggleDisplay()
