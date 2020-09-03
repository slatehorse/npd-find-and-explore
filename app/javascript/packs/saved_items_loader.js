import '../src/loader.scss'
import '../src/loader.js'
import { getElementsList, persistAdditionalNotes, removeAllFromMetadata,
         removeDatasetFromMetadata, removeFromMetadata, validateDateRange } from '../src/basket.js'
import $ from 'jquery'

window.loader = new GOVUK.Loader()

$(document).ready(function() {
  $('#govuk-box-message').show()
  window.loader.init({
    container: 'govuk-box-message',
    label: true,
    labelText: 'Your data is being loaded'
  })

  var selectedElements = getElementsList()

  var meta = document.querySelector('meta[name="csrf-token"]')
  var token = ''
  if (meta) {
    token = meta.content
  }

  $.ajax({
    type: 'POST',
    url: location.pathname.replace(/saved_items/, 'saved_items/saved_items'),
    data: { elements: selectedElements },
    dataType: 'html',
    headers: {
      'X-CSRF-Token': token
    },
    success: function(response, status, xhr) {
      setTimeout(function() {
        $('#govuk-box-message').hide()
        window.loader.stop()
        $('.saved_items_table').html(response)
        $('.years-required').each(function(idx, element) {
          element.addEventListener('change', validateDateRange)
          element.dispatchEvent(new Event('change'))
        })
        $('.additional-notes').each(function(idx, element) {
          element.addEventListener('change', persistAdditionalNotes)
        })
        $('.item-remove').each(function(idx, element) {
          element.addEventListener('click', removeFromMetadata)
        })
        $('.dataset-remove').each(function(idx, element) {
          element.addEventListener('click', removeDatasetFromMetadata)
        })

        $('.remove-all').each(function(idx, element) {
          element.addEventListener('click', removeAllFromMetadata)
        })
      }, 500)
    }
  })
})

