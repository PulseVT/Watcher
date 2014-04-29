makeRequest = window.app.makeRequest

window.namespace 'app.controllers', ->

	class DashboardCtrl
		constructor: (@scope, @element, @AllUserFollowers) ->
			@scopeFunctions()
		
		scopeFunctions: =>
			@scope.init = (@userVariableName) =>
				@watchers @userVariableName
				@scope.existMoreFollowers = yes

			@scope.moreFollowers = =>
				@scope.pages[@userVariableName].followers.shift 10
				@loadUserFollowers @scope[@userVariableName], null, yes

		watchers: =>
			@scope.$watch @userVariableName, (value, old) =>				
				return if value is old
				return unless value?
				@scope.pages[@userVariableName].followers = helpers.pagesHelper()
				@loadUserFollowers value

			@scope.$watch 'currentTabName', (value, old) =>
				return if value is old
				if value in ['Dashboard','AnotherUserDashboard'] and old not in ['Dashboard','AnotherUserDashboard'] and @scope.attendedUser?
					setTimeout => @scope.timeout => @scope.compile(@element.find('.dashboard-follow-text').contents()) @scope

		loadUserFollowers: (user, callback, isMore) =>
			makeRequest @AllUserFollowers, {userId:user._id, range:@scope.pages[@userVariableName].followers}, (result) =>				
				@scope.existMoreFollowers = result.length < @scope.pages[@userVariableName].followers.range()
				result = @scope.followers.concat result if isMore
				@scope.tryApply =>
					@scope.followers = result
					@scope.followersById = helpers.arrayToObject result, '_id'
				callback? result

	@DashboardCtrl = ($scope, $element, AllUserFollowers) ->
		new DashboardCtrl arguments...
