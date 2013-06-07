$(document).ready(function () {
  var $textarea = $("#micropost_content");

  if ($textarea.length === 0) {
    return;
  }

  $textarea.keyup(function () {
    console.log(140 - $textarea.val().length);
  });
});
