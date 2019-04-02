document.querySelector('#sort').addEventListener('change', function(event) {
  var query = window.location.search.replace(/^\?/, '').split('&');

  var newQuery = query.filter(function(element) { return !/^sort/.test(element) });
  newQuery.push('sort=' + event.currentTarget.selectedOptions[0].value);

  window.location.search = '?' + newQuery.join('&');
})
