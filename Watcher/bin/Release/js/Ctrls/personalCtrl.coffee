makeRequest = window.app.makeRequest
helpers = window.app.helpers

pics = [
	'https://dl.dropboxusercontent.com/u/20467543/pic.jpg', 
	'http://i.telegraph.co.uk/multimedia/archive/02413/seal-shark-leap_2413378k.jpg',
	'http://2.bp.blogspot.com/-aL7kRBCxN0U/UN8SZBLq-NI/AAAAAAAAD9w/4cqDUKpRPRg/s1600/snow_leopard_pictures_1.jpg',
	'https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcR-4JdFpRLjiupd4SF4AdGytGqw2WzqXqpPgfJo22p0xb9ChzQb1g'
]
undefined_pic = 'img/logo.png'

window.namespace 'app.controllers', ->

	class PersonalCtrl
		constructor: (@scope, @rootScope, @element, @location, @AllUsers, @GetUserFavorites, @GetYan, @NumberPendingUserNotifications) ->
			@scopeFunctions()
		
		scopeFunctions: =>
			@scope.init = =>
				@scope.setNotificationsNumber 0
				@watchers()
				# @scope.setCurrentUser null
				@loadAllUsers (users) =>
				# 	@scope.tryApply =>
				# 		@scope.setCurrentUser users[0]
				@listenNotifications()

			@scope.logout = =>
				# makeRequest @Logout, null, (r) =>
				# 	setTimeout => alert "logged out successfully\n" + r
				# 	@location.path paths.login
				@location.path paths.root

			@scope.userNameFormat = (user) ->
				text = if user? then "<span>#{user.firstName} #{user.lastName} <span class='user-username'>@#{user.username}</span></span>" else ''

			@scope.goToAnotherUser = (userId) =>
				if userId is @scope.currentUser._id
					unless @scope.isAtHome()
						@scope.tryApply =>
							@scope.attendedUser = null
							@location.path paths.myHome
				else
					@scope.tryApply =>
						@scope.attendedUser = @scope.usersById[userId]
						@location.path paths.hisHome

			@scope.dateFormat = (date) =>
				helpers.dateToYMDTime date

			@scope.changeCurrentTabName = (val) =>
				@scope.tryApply =>
					@scope.currentTabName = val

			@scope.userOfVisiblePage = => @scope.attendedUser or @scope.currentUser

			@scope.attachFileShow = =>
				@scope.getVideoWay = 'upload'
				$('#attachFile').modal()
				null #!! IMPORTANT !!

			@scope.setVideoWay = (way) => @scope.tryApply =>
				@scope.getVideoWay = way

			@scope.getVideoWayClass = (tab) =>
				'active' if tab is @scope.getVideoWay

			@scope.setChosenFile = (elem) => @scope.tryApply =>
				extension = helpers.ext elem.value
				switch extension
					when 'mp4'
						@scope.setParsingVisible yes
						@scope.setFile null
						fr = new FileReader
						fr.onload = (f) =>
							@scope.setImageParsed no
							$('#testvideo').attr 'src', f.target.result
							setTimeout => @scope.timeout =>	
								duration = document.getElementById('testvideo').duration
								console.log duration
								if duration > 60
									elem.value = null
									@scope.setVideoDuration null
									alert 'Video longer than 60 sec!'
								else
									@scope.setVideoDuration duration
									@scope.setFile elem.files[0]
								@scope.setParsingVisible no
							, 1000
						fr.readAsDataURL elem.files[0]
					when 'jpg'
						@scope.setParsingVisible yes
						@scope.setVideoDuration null
						@scope.setFile null
						fr = new FileReader
						fr.onload = (f) =>
							$('#attachFile .image-preview img').attr 'src', f.target.result
							setTimeout => @scope.timeout =>
								@scope.setParsingVisible no
								@scope.setImageParsed yes
								@scope.setFile elem.files[0]
								@scope.setParsingVisible no
							, 1000
						fr.readAsDataURL elem.files[0]
					else					
						elem.value = null
						@scope.setFile null
						alert 'Only mp4 files allowed.'	

			@scope.uploadProgress = (evt) =>
				@scope.tryApply =>
					console.log evt.lengthComputable
					if evt.lengthComputable
						console.log evt.total
						@scope.progress = Math.round evt.loaded * 100 / evt.total
						$('#attachFile').modal 'hide' if @scope.progress is 100
					else
						@scope.progress = 'unable to compute'

			@scope.setNotificationsNumber = (val) => @scope.tryApply =>
				@scope.notificationsNumber = val



		watchers: =>		
			@scope.$watch 'users', (value, old) =>
				return if value is old
				return unless value?
				return unless @scope.users? and @scope.currentUser?
				@scope.tryApply => 
					@scope.anotherUsers = []
					for user in @scope.users
						@scope.anotherUsers.push user if user._id isnt @scope.currentUser._id
			, yes

			@scope.$watch 'currentUser', (value, old) =>
				return if value is old
				return unless value?
				return unless @scope.users? and @scope.currentUser?
				@scope.tryApply => 
					@scope.anotherUsers = []
					for user in @scope.users
						@scope.anotherUsers.push user if user._id isnt @scope.currentUser._id
					@addUsersSelect2()
			, yes
				

		loadAllUsers: (callback) =>
			makeRequest @AllUsers, null, (users) =>
				# for user, i in users
				# 	users[i].img = pics[i]
				@scope.tryApply => 
					console.log 'users'
					console.log users
					for user in users
						user.avatar = undefined_pic unless user.avatar?
					@scope.users = users
					@scope.usersById = helpers.arrayToObject users, '_id'
					@addUsersSelect2()
				callback? users

		addUsersSelect2: =>
			setTimeout => @scope.timeout =>
				format = (user) =>
					user = @scope.usersById[user.text]
					"<div class='user-at-select2' id='#{user._id}'><img src='#{user.avatar}'/> #{@scope.userNameFormat user}</div>"
				$('#s2_users').select2
					formatResult: format
					formatSelection: format
					escapeMarkup: (m) -> m
				.on 'select2-open', =>
					self = @
					$('.select2-results li').on 'mousedown', (e) ->
						self.scope.goToAnotherUser $(@).find('.user-at-select2').attr 'id'

				$('#s2_change_user').select2
					formatResult: format
					formatSelection: format
					escapeMarkup: (m) -> m
				.on 'select2-open', =>
					self = @
					$('.select2-results li').on 'mousedown', (e) ->						
						setTimeout => self.scope.timeout => self.scope.tryApply =>							
							self.scope.setCurrentUser self.scope.usersById[$(@).find('.user-at-select2').attr 'id']
							self.location.path paths.myHome

		listenNotifications: =>
			setInterval =>
				makeRequest @NumberPendingUserNotifications, {userId: @scope.currentUser._id}, (result) => @scope.tryApply =>
					@scope.setNotificationsNumber result.count
					console.log result.count
			, 2000

	@PersonalCtrl = ($scope, $rootScope, $element, $location, AllUsers, GetUserFavorites, GetYan, NumberPendingUserNotifications) ->
		new PersonalCtrl arguments...
