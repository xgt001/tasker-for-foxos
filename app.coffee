$(document).ready ->

  # Runs functions on page load
  initialize = ->
    allTodos = getAllTodos()
    showTodos(allTodos)
    $("#new-todo").focus()

  # Pulls stuff from localStorage
  getAllTodos = ->
    todo = localStorage.getItem("todo")
    todo = JSON.parse(todo) || []
    todo

  # Gets whatever is in the input and saves it
  setNewTodo = ->
    name = $("#new-todo").val() # get it from the input
    newTodo = createToDo(name) # create a new todo object
    allTodos = getAllTodos() # get what we have currently from getAllTodos()
    allTodos.push newTodo # append our new shit
    setAllTodos(allTodos)

  setAllTodos = (allTodos) ->
    localStorage.setItem("todo", JSON.stringify(allTodos)) # push that shit to localStorage as a string
    showTodos(allTodos) # run the showTodos again to show the latest one
    
    $("#new-todo").val('') # set the input to blank so we can type again
    
  getId = (li) ->
    id = $(li).find('input').attr('id').replace('todo', '') # Finds the input id and strips 'todo' from it
    parseInt(id) # Turns it into an integer (and return)

  markDone = (id) ->
    todos = getAllTodos()
    todos.splice(id,1)
    setAllTodos(todos)

  # Creates a new todo object
  createToDo = (name) ->
    todo =
      isDone: false
      name: name

  # Actually chuck that shit in the div
  showTodos = (allTodos) ->
    html = generateHTML(allTodos)
    $("#todo-list").html(html) # insert them into the div #todo-list

  # Gives us the shit in an li with labels and a checkbox
  generateHTML = (allTodos) ->
    names = getNames(allTodos) # get what's returned from allTodos()
    for name, i in names
      names[i] = '<li><input type="checkbox" id="todo' + i + '"></input><label for=todo' + i + '>' + name + '</label></li>'
    names

  # Grab everything from the key 'name' out of the object
  getNames = (allTodos) ->
    names = [] # create a new array for our names
    for todo in allTodos # iterate on each
      names.push todo['name'] # append the value to our new array called names
    names # return them so allTodos() can use it

  initialize()

  # Triggers the setting of the new todo when clicking the button
  $("#todo-submit").click (e) ->
    e.preventDefault()
    setNewTodo()

  $(document).on "click", "#todo-list li", (e) ->
    self = this
    $(self).find('input').prop('checked', true)
    $(self).fadeOut(500, ->
      markDone(getId(self)) 
      )
