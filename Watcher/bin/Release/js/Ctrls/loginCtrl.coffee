makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class LoginCtrl
		constructor: (@scope, @element, @location, @GetToken, @LoginWithToken, @UsersById, @UserById) ->
			@scopeFunctions()
		
		watchers: =>

		scopeFunctions: =>
			@scope.init = =>
				@watchers()

			@scope.logIn = =>
				data =
					username: @scope.loginForm.name.$viewValue
					password: @scope.loginForm.password.$viewValue
				makeRequest @GetToken, data, (resultGetToken) =>
					makeRequest @LoginWithToken, resultGetToken.access_token, (result) =>
						window.accessToken = resultGetToken.access_token
						if result isnt 'Unauthorized'
							makeRequest @UserById, result.id, (currentUser) =>
								@scope.tryApply => @scope.setCurrentUser currentUser
								@scope.go paths.myHome
							, =>
								@scope.go paths.myHome
						else
							@handleErrorLogin()
				, (error) => @handleErrorLogin()

		handleErrorLogin: =>
			@scope.tryApply => @scope.loginErrorShow = yes
			clearTimeout @scope.hideLoginErrorTimeout
			@scope.hideLoginErrorTimeout = setTimeout => 
				@scope.tryApply => @scope.loginErrorShow = no
			, 5000


	@LoginCtrl = ($scope, $element, $location, GetToken, LoginWithToken, UsersById, UserById) ->
		new LoginCtrl arguments...