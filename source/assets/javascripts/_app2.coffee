###
Include your files here
###

#= require filename.coffee

cup3 = require "./_cup1.coffee"

$ ->
  console.log 'document ready from app2.js'
  console.log cup3
  console.log cup3.answer