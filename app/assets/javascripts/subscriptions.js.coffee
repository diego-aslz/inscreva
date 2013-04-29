# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(document).on 'click', '#check_id_card', ->
    $btnContinue = $(this)
    $field = $('#subscription_id_card')
    id_card = $field.val()
    if id_card
      $.get($btnContinue.data('url'), id_card: id_card).done (data, textStatus, jqxhr) ->
        if data == 0
          $('#id_card_show').val(id_card)
          $('#id_card_field').slideUp 'fast', ->
            $('#subscription_fields').slideDown('fast')
        else
          alert(data)
