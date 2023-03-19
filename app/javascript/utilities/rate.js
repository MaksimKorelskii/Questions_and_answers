$(document).on('turbolinks:load', function() {
  $('.rate').on('ajax:success', function(e) {
    let rating = e.detail[0].rating
    let resourceId = e.detail[0].resource_id
    let resourceName = e.detail[0].resource_name

    $('div#' + resourceName + '-' + resourceId + '.rating').html(rating)
  })
  .on('ajax:error', function (e) {
    let error = e.detail[0]

    $('.question-errors').html(`<p>${error}</p>`);
  })
})
