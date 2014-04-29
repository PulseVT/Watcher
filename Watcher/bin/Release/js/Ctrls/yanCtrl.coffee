makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class YanCtrl
		constructor: (@scope, @element, @DeleteYan, @RemoveReyan, @AddComment, @GetComments, @AddFavorite, @RemoveFavorite, @NumberYanFavourites, @AddLike, @RemoveLike, @NumberYanLikes, @GetYanFavorites) ->
			@scopeFunctions()
		
		scopeFunctions: =>
			@scope.init = =>
				#setting pages				
				@scope.pages.yansComments[@scope.yan._id] = helpers.pagesHelper()

				#getting numbers
				@loadFavoritesNumber()
				@loadLikesNumber()

				#getting lists
				@scope.comments = []
				@scope.favorites = {}
				@scope.likes = helpers.arrayOfValuesToObject @scope.yan.likes
				@loadFavorites()

				#other preparations
				@scope.showComments = no
				@watchers()
				@scope.timeout => setTimeout =>
					@scope.compile(@element.find('.yan-content').contents()) @scope
					# @scope.compile(@element.find('.buttons').contents()) @scope

				return unless @scope.yan.content_type is 'image'

				setTimeout => @scope.timeout =>
					@scope.compile(@element.find('.yan-image').contents()) @scope

			@scope.addFavorite = =>
				makeRequest @AddFavorite, {yanId: @scope.yan._id, userId: @scope.currentUser._id}, (result) => @scope.tryApply =>
					@scope.nFavorites++
					@scope.favorites[@scope.currentUser._id] = @scope.currentUser._id
					helpers.include @scope, ['myFavorites'], result, @scope.pages.userFavorites if @scope.myFavorites?

					# #adding notification if the owner of faved yan is not currentUser
					# if @scope.yan.author isnt @scope.currentUser._id
					# 	makeRequest @AddNotification, {
					# 		content: "
					# 			<p ng-click='goToAnotherUser(\"#{@scope.currentUser._id}\")'>#{@scope.currentUser.firstName} #{@scope.currentUser.lastName} @#{@scope.currentUser.username} </p>
					# 			<p class='bolder'>has faved <a ng-click='go(paths.singleYan(\"#{@scope.yan._id}\"))'>your yan</a>!<p>
					# 				"
					# 		userId: @scope.yan.author
					# 		fromUserId: @scope.currentUser._id
					# 	}, (result) =>
					# 		console.log 'NOTIFICATION'
					# 		console.log result


			@scope.removeFavorite = =>
				makeRequest @RemoveFavorite, {yanId: @scope.yan._id, userId: @scope.currentUser._id}, (result) => @scope.tryApply =>
					@scope.nFavorites--
					delete @scope.favorites[@scope.currentUser._id]
					helpers.exclude @scope, ['myFavorites'], result, @scope.pages.userFavorites if @scope.myFavorites?

			@scope.addLike = =>
				add = =>
					@scope.tryApply =>
						@scope.nLikes++
						@scope.likes[@scope.currentUser._id] = @scope.currentUser._id
				makeRequest @AddLike, {yanId: @scope.yan._id, userId: @scope.currentUser._id}, (result) => 
					@scope.tryApply =>
				, (error) => alert error

			@scope.removeLike = =>
				remove = =>
					@scope.tryApply =>
						@scope.nLikes--
						delete @scope.likes[@scope.currentUser._id]
				makeRequest @RemoveLike, {yanId: @scope.yan._id, userId: @scope.currentUser._id}, (result) => 
					@scope.tryApply =>
				, (error) => alert error

			@scope.addComment = => @scope.tryApply =>
				makeRequest @AddComment, {yanId:@scope.yan._id, data:{content:@scope.newCommentText,author:@scope.currentUser._id}}, (result) =>
					@scope.tryApply =>
						@scope.comments = [result].concat @scope.comments
						@scope.newCommentText = ''
						@scope.pages.yansComments[@scope.yan._id].shift 1


			@scope.toggleShowComments = => @scope.tryApply =>
				@scope.showComments = not @scope.showComments
				unless @scope.showComments 
					@scope.comments = []
					@scope.pages.yansComments[@scope.yan._id].default()

			@scope.deleteYan = =>
				makeRequest @DeleteYan, @scope.yan._id, (yan) =>
					delete @scope.pages.yansComments[@scope.yan._id]
					helpers.exclude @scope, ['currentUserHomeYans','currentUserYansAndReyans','attendedUserYansAndReyans'], @scope.yan, [@scope.pages.currentUser.yans.HomeYans, @scope.pages.currentUser.yans.YansAndReyans, @scope.pages.attendedUser.yans.YansAndReyans]

			@scope.removeReyan = =>
				return unless @scope.currentUser?
				makeRequest @RemoveReyan, {yanId:@scope.yan._id}, =>
					objectsForExclusion = ['currentUserReyans','currentUserYansAndReyans']
					pagesObjects = [@scope.pages.currentUser.yans.Reyans, @scope.pages.currentUser.yans.YansAndReyans]
					if @scope.yan.author not in @scope.currentUser.following
						objectsForExclusion.push 'currentUserHomeYans'
						pagesObjects.push @scope.pages.currentUser.yans.HomeYans
					helpers.exclude @scope, objectsForExclusion, @scope.yan, pagesObjects

			@scope.moreComments = =>
				@scope.pages.yansComments[@scope.yan._id].shift 10
				@loadComments null, yes

		watchers: =>
			@scope.$watch 'showComments', (value, old) =>
				return if value is old				
				@loadComments() if value

			# @scope.$watch 'favorites', (value, old) => 
			# 	@scope.tryApply =>
			# 		@scope.nFavorites = helpers.objLen value
			# , yes

			# @scope.$watch 'likes', (value, old) => 
			# 	@scope.tryApply =>
			# 		@scope.nLikes = helpers.objLen value
			# , yes	

		loadFavorites: (callback) =>
			return if @scope.yan.content_type isnt 'text'
			makeRequest @GetYanFavorites, {yanId: @scope.yan._id}, (result) =>
				@scope.tryApply =>
					@scope.favorites = helpers.arrayOfValuesToObject result
					callback? result

		loadComments: (callback, isMore) => 
			@scope.comments = [] unless isMore
			makeRequest @GetComments, {yanId: @scope.yan._id, range: @scope.pages.yansComments[@scope.yan._id]}, (result) =>
				@scope.existMoreComments = result.length is @scope.pages.yansComments[@scope.yan._id].range()
				result = @scope.comments.concat result if isMore
				console.log result
				@scope.tryApply =>
					@scope.comments = result
					@scope.commentsById = helpers.arrayToObject result, '_id'
					callback? result

		loadFavoritesNumber: (callback) =>			
			return if @scope.yan.content_type isnt 'text'
			makeRequest @NumberYanFavourites, {yanId: @scope.yan._id}, (result) => @scope.tryApply =>
				@scope.nFavorites = result.count

		loadLikesNumber: (callback) =>
			return if @scope.yan.content_type is 'text'
			makeRequest @NumberYanLikes, {yanId: @scope.yan._id}, (result) => @scope.tryApply =>
				@scope.nLikes = result.count

	@YanCtrl = ($scope, $element, DeleteYan, RemoveReyan, AddComment, GetComments, AddFavorite, RemoveFavorite, NumberYanFavourites, AddLike, RemoveLike, NumberYanLikes, GetYanFavorites) ->
		new YanCtrl arguments...