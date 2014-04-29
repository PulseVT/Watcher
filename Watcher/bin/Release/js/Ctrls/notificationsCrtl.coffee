makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class NotificationsCtrl
		constructor: (@scope, @element, @AllUserNotifications, @PendingUserNotifications) ->
			@scope.pages.userNotifications = 
				all: helpers.pagesHelper()
				pending: helpers.pagesHelper()
			@scopeFunctions()
		
		scopeFunctions: =>
			@scope.init = =>
				@scope.notificationsMode = 'pending' # 	'all'	or	'pending'
				@loadNotifications()

			@scope.moreNotifications = =>
				@loadNotifications null, yes

			@scope.swtchNotificationsView = => @scope.tryApply =>
				@scope.notificationsMode = if @scope.notificationsMode is 'pending' then 'all' else 'pending'
				@loadNotifications()

			@scope.getNotificationsModeName = =>
				name = ''
				switch @scope.notificationsMode 
					when 'all' 
						name = 'All notifications'
					when 'pending'
						name = 'Unread notifications'
				name 

		loadNotifications: (callback, isMore) =>
			service = @PendingUserNotifications#if @scope.notificationsMode is 'pending' then @PendingUserNotifications else @AllUserNotifications
			@scope.notifications = [] unless isMore
			makeRequest service, {userId: @scope.currentUser._id, range: @scope.pages.userNotifications[@scope.notificationsMode]}, (result) =>
				@scope.existMoreNotifications = result.length is @scope.pages.userNotifications[@scope.notificationsMode].range()
				result = @scope.notifications.concat result if isMore
				console.log 'Notifications'
				console.log result
				@scope.tryApply =>
					@scope.notifications = result
					@scope.notificationsById = helpers.arrayToObject result, '_id'
					callback? result


	@NotificationsCtrl = ($scope, $element, AllUserNotifications, PendingUserNotifications) ->
		new NotificationsCtrl arguments...