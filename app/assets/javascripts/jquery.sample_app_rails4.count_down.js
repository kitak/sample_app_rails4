(function($) {

  $.fn.countDown = function(option) {
    option.max_length = option.max_length || 140;

    var setQuantity = function(textarea) {
      var $textarea = $(textarea);
      var $target = $(option.target);
      var quantity = option.max_length - $textarea.val().length;
      $target.text(quantity);

      if (quantity < 0) {
        $target.css('color', '#f00');
      } else {
        $target.css('color', '#000');
      }
    };

    this.on('keyup change', function() { setQuantity(this); });
    setQuantity(this);

    return this;
  };
})(jQuery);
