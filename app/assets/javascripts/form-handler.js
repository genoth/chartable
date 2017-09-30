$(document).ready(function() {
  descriptorFormHandler();
});

var descriptorFormHandler = function() {
  $("text-input").on("submit", function(event){
    event.preventDefault();
    console.log("bound");
    var $form = $(this)

    var $request = $.ajax({
      url: $form.attr("action"),
      method: "post",
      data: $form.serialize()
    })
    $request.done(function(serverResponse){
      $("#our-data").append(serverResponse);
    })
  })
}
