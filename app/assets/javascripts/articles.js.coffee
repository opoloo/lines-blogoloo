jQuery ->
  $('#article_published_at').datepicker
    dateFormat: 'yy-mm-dd'

  $('.select_image').on 'click' ->
    alert $(this)
