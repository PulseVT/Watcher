makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class YansCtrl
		constructor: (@scope, @rootScope, @location, @AddYan, @AddReyan, @AllUserYans, @AllUserReyans, @AllUserYansAndReyans, @AllUserHomeYans, @AttachFile) ->
			@scopeFunctions()
		
		refreshPages: =>
			yanPages = 
				'HomeYans': helpers.pagesHelper()
				'Yans': helpers.pagesHelper()
				'Reyans': helpers.pagesHelper()
				'YansAndReyans': helpers.pagesHelper()
			@scope.pages.currentUser.yans = angular.copy yanPages
			@scope.pages.attendedUser.yans = angular.copy yanPages

		scopeFunctions: =>
			@scope.init = =>
				@scope.self = @scope
				@refreshPages()
				@watchers()

			@rootScope.captureImage = => setTimeout =>
				options = 
					limit: 1
				captureSuccess = (e) => setTimeout =>
					console.log 'IMAGE'
					console.log JSON.stringify e
					@scope.setFile e[0]
					@scope.attachFile()
				captureError = (e) => setTimeout =>
					@scope.tryApply => @scope.error = e
					console.log e
				navigator?.device?.capture?.captureImage? null, null, options

			@rootScope.captureVideo = =>
				options = 
					limit: 1
					duration: 60
				captureSuccess = (e) =>
					console.log 'VIDEO'
					console.log JSON.stringify e
					@scope.setFile e[0]
					@scope.attachFile()
				captureError = (e) =>
					@scope.tryApply => @scope.error = e
					console.log e
				navigator?.device?.capture?.captureVideo? null, null, options

			@rootScope.attachFile = =>
				return unless @scope.file
				ext = helpers.ext @scope.file.name
				unless ext in ['mp4', 'jpg']
					alert 'Wrong file format!'
					return
				content_type = ''
				switch ext
					when 'mp4'
						content_type = 'video'
					when 'jpg'
						content_type = 'image'
				@scope.setProgressVisible yes
				makeRequest @AttachFile,
					progress: @scope.uploadProgress
					params:
						access_token: window.accessToken
						content_type: content_type
						file: @scope.file
						author: @scope.currentUser._id
						caption: @scope.newYanText
				, (yan) => @scope.addYan yan

			@rootScope.addYan = (yan) =>
				commonSuccessCallback = (yan) =>
					helpers.include @scope, ['currentUserHomeYans','currentUserYansAndReyans','currentUserYans'], yan, [@scope.pages.currentUser.yans.HomeYans, @scope.pages.currentUser.yans.YansAndReyans, @scope.pages.currentUser.yans.Yans]	

				switch yan?.content_type
					when 'video','image'
						commonSuccessCallback yan
					else
						return unless @scope.newYanText
						makeRequest @AddYan, {content:@scope.newYanText, content_type:'text', author:@scope.currentUser._id}, (yan) => 
							commonSuccessCallback yan

				@scope.tryApply =>
					@scope.newYanPrepared = null
					@scope.setNewYanText ''

			@scope.addReyan = (yan) =>
				return unless @scope.currentUser?
				makeRequest @AddReyan, {yanId:yan.original_yan, userId:@scope.currentUser._id}, (result) =>
					helpers.include @scope, ['currentUserReyans','currentUserHomeYans','currentUserYansAndReyans'], yan, [@scope.pages.currentUser.yans.Reyans, @scope.pages.currentUser.yans.HomeYans, @scope.pages.currentUser.yans.YansAndReyans]

			@scope.varNameShowedUser = =>
				if @location.path().indexOf('attend') > -1 then 'attendedUser' else 'currentUser'

			@scope.varNameShowedYans = =>
				showedYans = null
				path = @location.path()
				switch path
					when paths.myHome
						showedYans = 'HomeYans'
					when paths.hisHome, paths.me
						showedYans = 'YansAndReyans'
				showedYans

			@scope.canReyan = (yan) =>
				@scope.currentUser._id isnt yan.original_author and @scope.currentUser._id isnt yan.author and not @scope.currentUserReyansById[yan._id]

			@scope.moreYans = =>
				varNameShowedYans = @scope.varNameShowedYans()
				varNameShowedUser = @scope.varNameShowedUser()
				@scope.pages[varNameShowedUser].yans[varNameShowedYans].shift 10
				@loadYans varNameShowedYans, varNameShowedUser, null, yes

		watchers: =>
			@scope.$watch 'newYanText', (value, old) => @scope.tryApply =>
				@scope.newYanTextFromCurrentScope = value

			@scope.$watch 'currentUser', (value, old) =>
				return if value is old
				return unless value?

				@refreshPages()

				@loadYans 'Yans', 'currentUser'
				@loadYans 'Reyans', 'currentUser'
				@loadYans 'YansAndReyans', 'currentUser'
				@loadYans 'HomeYans', 'currentUser'


			@scope.$watch 'currentUser.following', (value, old) =>
				return if value is old

				@loadYans 'HomeYans', 'currentUser'
			, true

			@scope.$watch 'attendedUser', (value, old) =>
				return if value is old
				return unless value?

				@loadYans 'YansAndReyans', 'attendedUser'


			@scope.$watch 'location.path()', (value, old) =>
				userVarName = if @scope.isAtHome() then 'currentUser' else 'attendedUser'
				@loadYans 'Reyans', userVarName
				@loadYans 'Yans', userVarName
				switch value
					when paths.myHome
						@loadYans 'HomeYans', 'currentUser'
					when paths.me
						@loadYans 'YansAndReyans', 'currentUser'
					when paths.hisHome
						@loadYans 'YansAndReyans', 'attendedUser'

		loadYans: (yansVariableName, userVariableName, callback, isMore) =>
			user = @scope[userVariableName]
			service = @["AllUser#{yansVariableName}"]
			return unless user?
			yansObjectName = userVariableName + yansVariableName
			@scope[yansObjectName] = null unless isMore
			makeRequest service, {userId:user._id, range:@scope.pages[userVariableName].yans[yansVariableName]}, (result) =>	
				@scope["existMore#{yansObjectName}"] = result.length is @scope.pages[userVariableName].yans[yansVariableName].range()
				result = @scope[yansObjectName].concat result if isMore
				console.log yansObjectName
				console.log result
				@scope.tryApply =>
					@scope.reyansByOriginalYan = {}
					for yan in result
						@scope.reyansByOriginalYan[yan.original_yan] = yan if yan.type is 'reyan'
					
					@scope[yansObjectName] = result
					@scope["#{yansObjectName}ById"] = helpers.arrayToObject result, '_id'
					callback? result

	@YansCtrl = ($scope, $rootScope, $location, AddYan, AddReyan, AllUserYans, AllUserReyans, AllUserYansAndReyans, AllUserHomeYans, AttachFile) ->
		new YansCtrl arguments...
