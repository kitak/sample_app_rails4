(function($) {

  $.fn.countDown = function(option) {
    option.max_length = option.max_length || 140;
    $(option.target).text(option.max_length);

    var setQuantity = function() {
      var $textarea = $(this);
      var $target = $(option.target);
      var quantity = option.max_length - $textarea.val().length;
      $target.text(quantity);

      if (quantity < 0) {
        $target.css('color', '#f00');
      } else {
        $target.css('color', '#000');
      }
    };

    this.on('keyup change', setQuantity);

    return this;
  };
})(jQuery);
