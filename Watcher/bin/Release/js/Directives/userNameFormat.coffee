window.namespace 'app.directives', ->

	class UserNameFormat
		constructor: (@scope, @element, @attrs) ->
			return unless @attrs.userNameFormat
			user = JSON.parse @attrs.userNameFormat
			@element.html @scope.userNameFormat user

	@UserNameFormat = ($scope, $element, $attrs) ->
		new UserNameFormat arguments...
	