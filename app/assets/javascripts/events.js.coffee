$ ->
  updateExtras()
  $('div.has_many.fields').children('a').on('click', (e)->
    updateExtras()
  )

updateExtras = ->
  $('.field_type').each ->
    shuffleExtra(this)
    $(this).on('change', ->
      shuffleExtra(this)
    )

shuffleExtra = (el)->
  type = $(el).val()
  extra = $(el).parent().parent().children('.extra')
  if jQuery.inArray(type, extra.data('extra-types')) == -1
    extra.slideUp()
  else
    extra.slideDown()
