# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
# For datepicker instructions, see
# http://allthingsrails.com/post/18389560407/using-jquery-ui-datepicker-with-rails
$ ->
  $(".jquery-ui-date").datepicker(altField: "#date-alt", altFormat: "yy-mm-d", dateFormat: "D dd M yy")
