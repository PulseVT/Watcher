makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class FavoritesCtrl
		constructor: (@scope, @element, @GetUserFavorites) ->
			@scope.pages.userFavorites = helpers.pagesHelper()
			@scopeFunctions()
		
		scopeFunctions: =>
			@scope.init = =>
				@loadUserFavorites()
				

		loadUserFavorites: (callback, isMore) =>
			@scope.myFavorites = [] if isMore
			makeRequest @GetUserFavorites, {userId: @scope.currentUser._id, range:@scope.pages.userFavorites}, (result) => @scope.tryApply =>
				@scope.existMoreFavorites = result.length is @scope.pages.userFavorites.range()
				result = @scope.myFavorites.concat result if isMore
				@scope.tryApply =>
					@scope.myFavorites = result
					@scope.myFavoritesById = helpers.arrayToObject result, '_id'
					callback? result
				# for k, v of result
				# 	makeRequest @GetYan, {yanId: v.yanId}, (result) =>
				# 		@scope.myFavorites.push result

	@FavoritesCtrl = ($scope, $element, GetUserFavorites) ->
		new FavoritesCtrl arguments...