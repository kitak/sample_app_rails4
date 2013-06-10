$(function () {
  var $textarea = $("#micropost_content");
  var $count_down = $("#count_down");
  var MAX_LENGTH = 140;

  if ($textarea.length === 0) {
    return;
  }

  $count_down.text(MAX_LENGTH);

  setTimeout(function () {
    var quantity = MAX_LENGTH - $textarea.val().length;
    $count_down.text(quantity);

    if(quantity < 0) {
      $count_down.css('color', '#f00');
    } else {
      $count_down.css('color', '#000');
    }

    setTimeout(arguments.callee, 100);
  }, 100);
});
