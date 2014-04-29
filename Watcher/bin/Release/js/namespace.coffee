window.namespace = (path, callback) ->

	tokens = path.split '.'

	place = window

	for token in tokens
		place[token] = {parent:place} unless place[token]?
		place = place[token]

	callback.call place