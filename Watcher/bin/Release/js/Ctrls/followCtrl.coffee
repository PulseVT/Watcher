makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class FollowCtrl
		constructor: (@scope, @element) ->
			@scopeFunctions()		
		
		watchers: =>
			@scope.$watch 'currentTabName', (value, old) =>
				return if value is old or value not in ['Dashboard','AnotherUserDashboard']
				setTimeout => @scope.timeout =>
					@scope.compile(@element.contents()) @scope

		scopeFunctions: =>
			@scope.init = => 
				@watchers()

	@FollowCtrl = ($scope, $element) ->
		new FollowCtrl arguments...