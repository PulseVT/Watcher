window.namespace 'app.directives', ->

	class AddImage
		constructor: (@scope, @element, @attrs) ->
			return unless @attrs.addImage
			parsed = JSON.parse @attrs.addImage
			@element.html @imageHtml parsed

		imageHtml: (yan) =>
			return '' unless yan.content_type is 'image'
			html = "<img width='400' height='264' id='yan-image-#{yan._id}' src='#{yan.content.url}'></img>"
			html


	@AddImage = ($scope, $element, $attrs) ->
		new AddImage arguments...
	