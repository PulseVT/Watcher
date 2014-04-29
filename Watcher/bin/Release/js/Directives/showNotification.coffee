window.namespace 'app.directives', ->

	class ShowNotification
		constructor: (@scope, @element, @attrs) ->
			return unless @attrs.showNotification
			parsed = JSON.parse @attrs.showNotification
			@element.html @notificationHtml parsed
			setTimeout => @scope.timeout =>
				@scope.compile(@element.contents()) @scope

		notificationHtml: (n) =>
			"
				<div class='span3'>
					<img ng-click='goToAnotherUser(\"#{n.fromUserId}\")' src='#{@scope.usersById[n.fromUserId].avatar}' width='100' height='100'></img>
					<span user-name-format='{{usersById[\"#{n.fromUserId}\"]}}'></span>
				</div>
				<div class='span5'>
					#{n.attachment.content or 'No attachment'}
				</div>
				<div class='span4'>
					<p>#{n.content}</p>
					<p>
						<button ng-click='readNotification(n)'>Read</button>
					</p>
				</div>							
			"

	@ShowNotification = ($scope, $element, $attrs) ->
		new ShowNotification arguments...
	
