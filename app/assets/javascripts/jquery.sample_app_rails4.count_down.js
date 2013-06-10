(function($) {
  var DEFAULT_MAX_LENGTH = 140;

  var setQuantity = function($target, max_length) {
    var $textarea = this;
    var quantity = max_length - $textarea.val().length;
    $target.text(quantity);

    if (quantity < 0) {
      $target.css('color', '#f00');
    } else {
      $target.css('color', '#000');
    }
  };

  $.fn.countDown = function(target, max_length) {
    max_length = max_length || DEFAULT_MAX_LENGTH;
    var handler = setQuantity.bind(this, $(target), max_length);
    this.on('keyup change', handler);
    handler();

    return this;
  };
})(jQuery);
