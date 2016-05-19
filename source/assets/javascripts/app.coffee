###
Include your files here
###

#= require filename.coffee

one = require "./_partial1.coffee"
square = one.external.square


$ ->
  console.log 'document ready from app.js'
  console.log 'the object imported from partials:'
  console.log one
  console.log 'the answer:  ' + one.answer
  console.log 'square function imported form partial2 - square(4):  ' + square(4)