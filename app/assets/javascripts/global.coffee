# This file is used for executing common script for all pages
$ ->
  # Make checkbox readonly works like disabled
  $('body').on 'click', ':checkbox[readonly]', (e) ->
    e.preventDefault()
