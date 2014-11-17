class jQueryEx extends $
  @fn.toggleDisplay = () ->
    if @hasClass 'hide'
      @removeClass('hide').addClass('show')
    else if @hasClass 'show'
      @removeClass('show').addClass('hide')

  @fn.addHide = () ->
    if @hasClass 'show'
      @removeClass('show').addClass('hide')

  @fn.addShow = () ->
    if @hasClass 'hide'
      @removeClass('hide').addClass('show')

  @fn.bulkReset = (obj) ->
    _.each obj, (v, k) =>
      @find(k).val v if @find k
