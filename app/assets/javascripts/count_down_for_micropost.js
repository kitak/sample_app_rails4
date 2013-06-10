$(function () {
  var $textarea = $("#micropost_content");
  var $count_down = $("#count_down");
  var MAX_LENGTH = 140;

  $count_down.text(MAX_LENGTH);
  
  var setQuantity = function () {
    var quantity = MAX_LENGTH - $textarea.val().length;
    $count_down.text(quantity);

    if(quantity < 0) {
      $count_down.css('color', '#f00');
    } else {
      $count_down.css('color', '#000');
    }

    setTimeout(setQuantity, 100);
  };
  setQuantity();
});
