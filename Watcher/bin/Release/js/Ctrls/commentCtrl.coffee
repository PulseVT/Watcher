makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class CommentCtrl
		constructor: (@scope, @element, @DeleteComment) ->
			@scopeFunctions()
		
		scopeFunctions: =>
			@scope.init = =>

			@scope.deleteComment = =>
				makeRequest @DeleteComment, {yanId:@scope.yan._id, commentId:@scope.c._id}, (result) =>
					@scope.tryApply =>
						@scope.comments = helpers.removeFromArrayOfObjectsWhere @scope.comments, '_id', @scope.c._id
						@scope.pages.yansComments[@scope.yan._id].shift -1


	@CommentCtrl = ($scope, $element, DeleteComment) ->
		new CommentCtrl arguments...