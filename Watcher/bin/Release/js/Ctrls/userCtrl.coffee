makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class UserCtrl
		constructor: (@scope, @element, @FollowUser, @UnfollowUser) ->
			@scopeFunctions()
		
		scopeFunctions: =>
			@scope.init = => 

			@scope.follow = =>
				makeRequest @FollowUser, {followedId:@scope.attendedUser._id, byId:@scope.currentUser._id}, (f) =>
					@scope.tryApply =>
						@scope.currentUser.following.push @scope.attendedUser._id
						@scope.pages[@userVariableName].followers.shift 1

			@scope.unfollow = =>
				makeRequest @UnfollowUser, {followedId:@scope.attendedUser._id, byId:@scope.currentUser._id}, (f) =>
					@scope.tryApply =>						
						following = []
						for followingId in @scope.currentUser.following
							following.push followingId if followingId isnt @scope.attendedUser._id
						@scope.currentUser.following = following
						@scope.pages[@userVariableName].followers.shift -1

			@scope.isFollowedByCurrentUser = =>
				return unless @scope.attendedUser and @scope.currentUser
				isFollowed = no
				for userId in @scope.currentUser.following
					isFollowed = yes if userId is @scope.attendedUser._id
				isFollowed

	@UserCtrl = ($scope, $element, FollowUser, UnfollowUser) ->
		new UserCtrl arguments...