// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
  "use strict";

  $("#dictionary_submit").on("click", function (e) {
    e.preventDefault();
    $("#dictionary_form").submit();
  });
});
