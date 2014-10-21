$(document).ready ->
  $("#toggleForm").on "click", "input[data-toggle]", ->
    $target = $($(this).attr("data-toggle"))
    $target.toggle()
    
    # Enable the submit buttons in case additional fields are not valid
    #$("#togglingForm").data("bootstrapValidator").disableSubmitButtons false  unless $target.is(":visible")