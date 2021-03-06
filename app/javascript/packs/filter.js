import '../src/loader.scss'
import '../src/loader.js'

window.loader = new GOVUK.Loader()

function submitFilter(event) {
  var target = event.currentTarget
  var name = target.name
  var value = target.value
  var query = window.location.search.replace(/^\?/, '').split('&')

  var newQuery = []
  if (target.tagName == 'SELECT') {
    var regexp = new RegExp('^' + name.replace(/\[/g, '\\[').replace(/\]/g, '\\]') + '=');
    newQuery = query.filter(function (element) { return !regexp.test(element) });
    newQuery.push(name + '=' + value);
  } else {
    var regexp = new RegExp('^' + name.replace(/\[/g, '\\[').replace(/\]/g, '\\]') + '=' + encodeURI(value))
    if (target.checked) {
      query.push(name + '=' + value)
      newQuery = query.filter(function(value, index, self) { return self.indexOf(value) === index } )
    } else {
      newQuery = query.filter(function (element) { return !regexp.test(element) })
    }
  }

  window.loader.init({
    container: 'govuk-box-message',
    label: true,
    labelText: 'We are filtering your search, please wait'
  })

  window.location.search = '?' + newQuery.join('&')
}

$(document).ready(function() {
  $('[data-filter=true]').on('change', submitFilter);
})
