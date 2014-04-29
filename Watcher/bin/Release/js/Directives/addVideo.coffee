window.namespace 'app.directives', ->

	class AddVideo
		constructor: (@scope, @element, @attrs) ->
			return unless @attrs.addVideo
			parsed = JSON.parse @attrs.addVideo
			unless parsed?.watch?
				@element.html @videoHtml parsed
			else
				@watchers parsed.watch

		watchers: (watchValues) =>
			for watchValue in watchValues
				@scope.$watch watchValue, (value, old) =>
					return if value is old
					@element.html @videoHtml value

		videoHtml: (yan) =>
			return '' unless yan.content_type is 'video'
			html = "<video id='yan-video-#{yan._id}' class='video-js vjs-default-skin'
						controls preload='auto' width='400' height='264' poster='http://video-js.zencoder.com/oceans-clip.png'>
						<source src='http://#{yan.content.url}' type='video/mp4'/>
					</video>"
			@scope.timeout => setTimeout =>
				videojs "yan-video-#{yan._id}", {} , =>
					console.log "video #{yan._id} ready."
			, 1000
			html


	@AddVideo = ($scope, $element, $attrs) ->
		new AddVideo arguments...
	