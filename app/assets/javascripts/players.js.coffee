# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).ready ->
    if location.hash != ''
        $('a[href="'+location.hash+'"]').tab('show')
    #alert(location.hash)
    #$('a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
        #location.hash = $(e.target).attr('href').substr(1)
