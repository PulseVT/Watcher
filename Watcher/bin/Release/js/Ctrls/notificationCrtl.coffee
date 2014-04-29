makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class NotificationCtrl
		constructor: (@scope, @element, @ReadNotification, @DeleteNotification) ->
			@scopeFunctions()
		
		scopeFunctions: =>
			@scope.init = =>

			@scope.readNotification = (n) =>
				n.status = 'das ist falsch'
				makeRequest @ReadNotification, {userId: @scope.currentUser._id, notification:n}, (result) => @scope.tryApply =>
					helpers.exclude @scope, ['notifications'], n, [@scope.pages.userNotifications[@scope.notificationsMode]] if @scope.notificationsMode is 'pending'
					@scope.setNotificationsNumber @scope.notificationsNumber-1

			@scope.deleteNotification = (n) =>	
				makeRequest @DeleteNotification, {userId: @scope.currentUser._id, notificationId:n._id}, (result) => @scope.tryApply =>
					helpers.exclude @scope, ['notifications'], n, [@scope.pages.userNotifications[@scope.notificationsMode]]
					@scope.setNotificationsNumber @scope.notificationsNumber-1


	@NotificationCtrl = ($scope, $element, ReadNotification, DeleteNotification) ->
		new NotificationCtrl arguments...