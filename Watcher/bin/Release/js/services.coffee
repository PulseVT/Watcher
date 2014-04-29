#angular services
window.namespace 'app', ->

	window.favorites =
		byUser: {}
		byYan: {}
	window.likes =			
		byUser: {}
		byYan: {}
	window.notifications = {}

	class Services
		constructor: (@rootScope, @q, @http, @resource) ->

		GetToken:							(data) 				=> @httpRequest 'post', urls.getToken, 
																	grant_type: "password"
																	client_id: "mobileV1"
																	client_secret: "secret123456"
																	username: data.username
																	password: data.password
		RefreshToken:						(data) 				=> @httpRequest 'post', urls.getToken, 
																	"grant_type":"refresh_token"
																	"client_id":"mobileV1"
																	"client_secret":"secret123456"
																	"refresh_token": data.refresh_token
		LoginWithToken:						(token)				=> @httpRequest 'post', urls.loginWithToken, access_token: token
		UsersById:							(ids)				=> @httpRequest 'post', urls.usersById, ids:ids, access_token: window.accessToken
		UserById:							(id)				=> @httpRequest 'get', urls.userById(id), params: access_token: window.accessToken
		AllUsers: 					 							=> @httpRequest 'get', urls.allUsers, params: access_token: window.accessToken
		AddUser:							(data)				=> @xhrRequest	'post', urls.addUser, _.extend data, access_token: window.accessToken
		AddYan:								(data) 				=> @httpRequest 'post', urls.addYan, _.extend data, access_token: window.accessToken
		GetYan:								(data)				=> @httpRequest 'get', urls.getYan(data.yanId), params: access_token: window.accessToken
		DeleteYan: 							(yanId)				=> @httpRequest 'delete', urls.deleteYan(yanId), params: access_token: window.accessToken 
		AllUserHomeYans:					(data)				=> @httpRequest 'get', urls.allUserHomeYans(data.userId, data.range.from, data.range.to), params: access_token: window.accessToken
		AllUserYans:						(data)				=> @httpRequest 'get', urls.allUserYans(data.userId, data.range.from, data.range.to), params: access_token: window.accessToken
		AllUserReyans:						(data)				=> @httpRequest 'get', urls.allUserReyans(data.userId, data.range.from, data.range.to), params: access_token: window.accessToken
		AllUserYansAndReyans:				(data)				=> @httpRequest 'get', urls.allUserYansAndReyans(data.userId, data.range.from, data.range.to), params: access_token: window.accessToken
		FollowUser:							(data) 				=> @httpRequest 'put', urls.followUser(data.followedId, data.byId), access_token: window.accessToken
		UnfollowUser:						(data) 				=> @httpRequest 'delete', urls.unfollowUser(data.followedId, data.byId), params: access_token: window.accessToken
		AllUserFollowers:					(data)				=> @httpRequest 'get', urls.allUserFollowers(data.userId, data.range.from, data.range.to), params: access_token: window.accessToken
		AddReyan:							(data)				=> @httpRequest 'put', urls.addReyan(data.yanId, data.userId), access_token: window.accessToken
		RemoveReyan:						(data)				=> @httpRequest 'delete', urls.removeReyan(data.yanId), params: access_token: window.accessToken
		AddComment:							(data)				=> @httpRequest 'post', urls.addComment(data.yanId), _.extend data.data, access_token: window.accessToken
		GetComments:						(data) 				=> @httpRequest 'get', urls.getComments(data.yanId, data.range.from, data.range.to), params: access_token: window.accessToken
		DeleteComment:						(data)				=> @httpRequest 'delete', urls.deleteComment(data.yanId, data.commentId), params: access_token: window.accessToken
		NumberUsers:											=> @httpRequest 'get', urls.numberUsers, params: access_token: window.accessToken
		NumberUserFollowers:				(userId)			=> @httpRequest 'get', urls.numberUserFollowers(userId), params: access_token: window.accessToken
		AttachFile:							(data)				=> @xhrRequest 	'post', urls.addYan, data
		AddFavorite:						(data)				=> @httpRequest 'put', urls.addFavorite(data.yanId, data.userId), access_token: window.accessToken
		RemoveFavorite:						(data)				=> @httpRequest 'delete', urls.removeFavorite(data.yanId, data.userId), params: access_token: window.accessToken
		NumberYanFavourites:				(data)				=> @httpRequest 'get', urls.numberYanFavourites(data.yanId), params: access_token: window.accessToken
		GetYanFavorites:					(data)				=> @httpRequest 'get', urls.getYanFavorites(data.yanId), params: access_token: window.accessToken
		GetUserFavorites:					(data)				=> @httpRequest 'get', urls.getUserFavorites(data.userId, data.range.from, data.range.to), params: access_token: window.accessToken
		AddLike:							(data)				=> @httpRequest 'put', urls.addLike(data.yanId, data.userId), _.extend data, access_token: window.accessToken
		RemoveLike:							(data)				=> @httpRequest 'delete', urls.removeLike(data.yanId, data.userId), params: access_token: window.accessToken
		NumberYanLikes:						(data)				=> @httpRequest 'get', urls.numberYanLikes(data.yanId), params: access_token: window.accessToken
		ReadNotification: 					(data) 				=> @httpRequest 'put', urls.readNotification(data.userId), _.extend data.notification, access_token: window.accessToken
		AllUserNotifications:				(data)				=> @httpRequest 'get', urls.allUserNotifications(data.userId, data.range.from, data.range.to), params: access_token: window.accessToken
		PendingUserNotifications:			(data)				=> @httpRequest	'get', urls.pendingUserNotifications(data.userId, data.range.from, data.range.to), params: access_token: window.accessToken
		DeleteNotification:					(data)				=> @httpRequest 'delete', urls.deleteNotification(data.userId, data.notificationId), params: access_token: window.accessToken
		NumberPendingUserNotifications:		(data)				=> @httpRequest 'get', urls.numberPendingUserNotifications(data.userId), params: access_token: window.accessToken


		# resourceRequest: (type, url, data) =>
		# 	deferred = @q.defer()
		# 	res = @resource url			
		# 	res[type] data, (response) =>
		# 		unless response.error
		# 			deferred.resolve response
		# 		else
		# 			deferred.reject response.message
		# 	deferred.promise


		fakeRequest: (type, url, data) =>
			deferred = @q.defer()
			@fakeHttp[url] data, (response) =>
				setTimeout =>
					unless response.error 
						deferred.resolve response.data
					else 
						deferred.reject response.error
				, 500
			deferred.promise

		fakeHttp:
			#Notifications
			addNotification: (data, callback) =>
				id = (new Date).getTime()
				newNotification = 
					content: data.content
					_id: id
					userId: data.userId
					fromUserId: data.fromUserId
					datetime: new Date
				response =
					data: newNotification
					error: false				
				unless window.notifications[data.userId]?[id]?
					window.notifications[data.userId] = {} unless window.notifications[data.userId]?
					window.notifications[data.userId][id] = newNotification
				else
					response.error = 'Already exists'
				callback response
			readNotification: (data, callback) =>
				response = 
					error: false
				delete window.notifications[data.userId][data.notificationId]
				callback response
			allUserNotifications: (data, callback) =>
				response = 
					data: window.notifications[data.userId] or {}
					error: false
				callback response
			#Favorites
			addFavorite: (data, callback) =>
				response =
					data: data
					error: false
				unless window.favorites.byUser[data.userId]?[data.yanId]?
					window.favorites.byUser[data.userId] = {} unless window.favorites.byUser[data.userId]?
					window.favorites.byUser[data.userId][data.yanId] = data
					window.favorites.byYan[data.yanId] = {} unless window.favorites.byYan[data.yanId]?
					window.favorites.byYan[data.yanId][data.userId] = data
				else
					response.error = 'Already exists'
				callback response
			removeFavorite: (data, callback) =>
				response = 
					error: false
				delete window.favorites.byUser[data.userId][data.yanId]
				delete window.favorites.byYan[data.yanId][data.userId]
				callback response
			getYanFavorites: (data, callback) =>
				response = 
					data: window.favorites.byYan[data.yanId] or {}
					error: false
				callback response
			getUserFavorites: (data, callback)=>
				response =
					data: window.favorites.byUser[data.userId] or {}
					error: false
				callback response
			#Likes
			addLike: (data, callback) =>
				response =
					data: data
					error: false
				unless window.likes.byUser[data.userId]?[data.yanId]?
					window.likes.byUser[data.userId] = {} unless window.likes.byUser[data.userId]?
					window.likes.byUser[data.userId][data.yanId] = data
					window.likes.byYan[data.yanId] = {} unless window.likes.byYan[data.yanId]?
					window.likes.byYan[data.yanId][data.userId] = data
				else
					response.error = 'Already exists'
				callback response
			removeLike: (data, callback) =>
				response = 
					error: false
				delete window.likes.byUser[data.userId][data.yanId]
				delete window.likes.byYan[data.yanId][data.userId]
				callback response
			getYanLikes: (data, callback) =>
				response = 
					data: window.likes.byYan[data.yanId] or {}
					error: false
				callback response


		xhrRequest: (type, url, data) =>
			deferred = @q.defer()
			form = new FormData
			for k, v of data.params
				form.append k, v
			xhr = new XMLHttpRequest
			xhr.upload.onprogress = data.progress
			xhr.onload = =>
				deferred.resolve JSON.parse xhr.response
			xhr.onerror = => 
				deferred.reject JSON.parse xhr.response
			xhr.onabort = null
			xhr.open type, url
			xhr.send form
			deferred.promise

		httpRequest: (type, url, data) =>
			deferred = @q.defer()						
			@http[type](url, data).success (response) =>
				unless response.error or response is 'Unauthorized'
					deferred.resolve response
				else
					deferred.reject response.message
			deferred.promise

	@services = (rootScope, q, http, resource) -> 
		window.http = http
		window.resource = resource
		new Services arguments...

#request maker
window.namespace 'app', ->
	@makeRequest = (service, data, onSuccess, onError) =>
		service.get(data).then onSuccess, onError

#helpers
window.namespace 'app', ->

	class PagesHelper
		constructor: (@from, @to) ->
			@from = 1 unless @from?
			@to = 10 unless @to?
		range: ->
			@to - @from + 1
		default: ->
			@from = 1
			@to = 10
		shift: (n) ->
			@from += n
			@to += n

	class Helpers
		constructor: ->

		pagesHelper: =>
			new PagesHelper arguments...

		arrayOfValuesToObject: (array) ->
			return {} unless array?
			obj = {}
			obj[val] = val for val in array
			obj

		arrayToObject: (array, key) ->
			return {} unless array?
			obj = {}
			obj[elem[key]] = elem for elem in array
			obj

		arrayToObjectOfArray: (array, key) -> #when array has many elems with indentical value by key
			return {} unless array?
			obj = {}
			for elem in array
				obj[elem[key]] = [] unless obj[elem[key]]?
				obj[elem[key]].push elem
			obj

		objectToArray: (obj) ->
			return [] unless obj?
			array = []
			for k, v of obj
				array.push v
			array

		removeFromArrayOfObjectsWhere: (arr, key, value) ->
			return [] unless arr?
			index = null
			for elem, i in arr
				index = i if elem[key] is value
			arr.splice index, 1 if index?
			arr

		dateToYMDTime: (d) ->
			return unless d?
			date = new Date d
			return d if typeof d is "string" and (isNaN(date.getTime()) or /^\d{2}\/\d{2}\/\d{4}$/.test d)
			d = date.getDate()
			m = date.getMonth() + 1
			y = date.getFullYear()
			h = date.getHours()
			min = date.getMinutes()
			sec = date.getSeconds()
			doubleDigits = (n) -> "#{if n <= 9 then '0' + n else n}"
			"#{y}/#{doubleDigits m}/#{doubleDigits d} | #{doubleDigits h}:#{doubleDigits min}:#{doubleDigits sec}"

		include: (scope, names, obj, pages) => scope.tryApply =>
			for name, i in names
				continue unless scope["#{name}ById"]?
				continue if scope["#{name}ById"][obj._id]?
				scope[name] = [obj].concat scope[name]
				scope["#{name}ById"][obj._id] = obj
				pages[i].shift 1
			
		exclude: (scope, names, obj, pages) => 
			self = @
			scope.tryApply =>
				for name, i in names
					continue unless scope[name]
					scope[name] = self.removeFromArrayOfObjectsWhere scope[name], '_id', obj._id
					delete scope["#{name}ById"][obj._id]
					pages[i].shift -1

		ext: (str) =>
			str.match(/\.([^\.]+)$/)[1]

		objLen: (obj) =>
			n = 0
			for k, v of obj
				n++
			n

		getCookie: (name) =>
			matches = document.cookie.match(new RegExp("(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"))
			if matches then decodeURIComponent(matches[1]) else null

		setCookie: (name, value, options) =>
			options = options || {}
			expires = options.expires
			if (typeof expires == "number" && expires)
				d = new Date()
				d.setTime(d.getTime() + expires*1000)
				expires = options.expires = d
			if (expires && expires.toUTCString)
				options.expires = expires.toUTCString()
			value = encodeURIComponent value
			updatedCookie = name + "=" + value
			for propName, propValue of options
				updatedCookie += "; " + propName
				propValue = options[propName]
				if propValue isnt yes
					updatedCookie += "=" + propValue
			document.cookie = updatedCookie


	@helpers = (-> new Helpers arguments...)()