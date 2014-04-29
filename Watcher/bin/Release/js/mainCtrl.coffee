helpers = window.app.helpers
window.namespace 'app.controllers', ->
	class MainCtrl
		constructor: (@scope, @location) ->	
			@scopeData()
			@watchers()
			@loadTodos()
			window.scope = @scope

		watchers: =>
			@scope.$watch 'displayed', (value) => @location.url value

		scopeData: =>
			@scope.self = @scope
			@scope.helpers = helpers
			@scope.sortType = 'date'
			@scope.reverse = no
			@scope.displayed = @location.url().substr(1) or 'pending'
			@scope.showInfoName = null
			@scope.tooltipToDestroy = null

			@scope.validateForm = (form) =>
				if form.name.$error.required
					@scope.setShowInfoName 'name-error'
				else if form.deadline.$error.required
					@scope.setShowInfoName 'deadline-error'
				if form.$valid then yes else no

			@scope.addToDo = => @scope.tryApply =>	
				if @scope.validateForm @scope.addTodoForm
					date = (new Date).valueOf()
					@scope.todos[date] =
						name: @scope.name
						text: @scope.text
						setDate: date
						deadlineDate: @scope.deadline.valueOf()
						status: 'pending'
					@pushTodos()
					@scope.text = ''
					@scope.name = ''
					@scope.deadline = null
					@scope.addTodoForm.$setPristine()

					@scope.setShowInfoName 'added'

			@scope.setReverse = (value) => @scope.tryApply => @scope.reverse = value

			@scope.setSortType = (value) => @scope.tryApply => @scope.sortType = value

			@scope.setShowInfoName = (value) => @scope.tryApply => @scope.showInfoName = value

			@scope.setTooltipToDestroy = (value) => @scope.tryApply => @scope.tooltipToDestroy = value

			@scope.goToPending = => @scope.tryApply => @scope.displayed = 'pending'

			@scope.goToDone = => @scope.tryApply =>	@scope.displayed = 'done'

			@scope.deadlineText = => helpers.dateFormat @scope.deadline

			@scope.flushToStorage = @pushTodos


		loadTodos: =>
			storedTodos = JSON.parse window.localStorage.getItem 'todos'
			@scope.todos = if storedTodos? then helpers.arrayToObject _.sortBy(storedTodos, (item) => item.date), 'setDate' else []
			for k, v of @scope.todos
				delete v.$$hashKey

		pushTodos: => window.localStorage.setItem 'todos', JSON.stringify @scope.todos


	@MainCtrl = ($scope, $location) ->
		new MainCtrl arguments...