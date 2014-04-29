serverUrl = 'http://iyansserver.herokuapp.com/'
# serverUrl = 'http://127.0.0.1:3000/'#'http://192.168.143.182:3000/'#'http://iyansserver.aws.af.cm/'
window.serverUrl = serverUrl

urls =
	getToken: "#{serverUrl}oauth/token/"
	loginWithToken: "#{serverUrl}users/id/"
	usersById: "#{serverUrl}users/ids/"
	userById: (userId) -> "#{serverUrl}users/#{userId}"
	allUsers: "#{serverUrl}users/"
	addUser: "#{serverUrl}users/"
	addYan: "#{serverUrl}yans/"
	getYan: (yanId) -> "#{serverUrl}yans/#{yanId}"
	deleteYan: (yanId) -> "#{serverUrl}yans/#{yanId}/"
	allUserHomeYans: (userId, from, to) -> "#{serverUrl}users/#{userId}/followyans?from=#{from}&to=#{to}/"
	allUserYans: (userId, from, to) -> "#{serverUrl}users/#{userId}/all?from=#{from}&to=#{to}/"
	allUserReyans: (userId, from, to) -> "#{serverUrl}users/#{userId}/reyans?from=#{from}&to=#{to}/"
	allUserYansAndReyans: (userId, from, to) -> "#{serverUrl}users/#{userId}/allinone?from=#{from}&to=#{to}/"
	followUser: (followedId, byId) -> "#{serverUrl}users/#{followedId}/follow/#{byId}/"
	unfollowUser: (followedId, byId) -> "#{serverUrl}users/#{followedId}/unfollow/#{byId}/"
	allUserFollowers: (userId, from, to) -> "#{serverUrl}users/#{userId}/followers?from=#{from}&to=#{to}/"
	addReyan: (yanId, userId) -> "#{serverUrl}yans/#{yanId}/reyaned/#{userId}/"
	removeReyan: (yanId) -> "#{serverUrl}yans/#{yanId}/"
	addComment: (yanId) -> "#{serverUrl}yans/#{yanId}/comments/"
	getComments: (yanId, from, to) -> "#{serverUrl}yans/#{yanId}/comments?from=#{from}&to=#{to}/"
	deleteComment: (yanId, commentId) -> "#{serverUrl}yans/#{yanId}/comments/#{commentId}/"
	numberUsers: "#{serverUrl}users/count/"
	numberUserFollowers: (userId) -> "#{serverUrl}users/#{userId}/followers/count/"
	#Favorites
	addFavorite: (yanId, userId) -> "#{serverUrl}yans/#{yanId}/favorited/#{userId}"
	removeFavorite: (yanId, userId) -> "#{serverUrl}yans/#{yanId}/favorited/#{userId}"
	numberYanFavourites: (yanId) -> "#{serverUrl}yans/#{yanId}/favorited/count"
	getYanFavorites: (yanId) -> "#{serverUrl}yans/#{yanId}/favorited"
	getUserFavorites: (userId, from, to) -> "#{serverUrl}users/#{userId}/favorites?from=#{from}&to=#{to}"
	#Likes
	addLike: (yanId, userId) -> "#{serverUrl}yans/#{yanId}/like/#{userId}"
	removeLike: (yanId, userId) -> "#{serverUrl}yans/#{yanId}/like/#{userId}"
	numberYanLikes: (yanId) -> "#{serverUrl}yans/#{yanId}/like/count"
	#Notifications
	readNotification: (userId) -> "#{serverUrl}users/#{userId}/notifications/" #"readNotification"
	allUserNotifications: (userId, from, to) -> "#{serverUrl}users/#{userId}/notifications?from=#{from}&to=#{to}/" #"allUserNotifications"
	pendingUserNotifications: (userId, from, to) -> "#{serverUrl}users/#{userId}/notifications/pending?from=#{from}&to=#{to}/"
	deleteNotification: (userId, notificationId) -> "#{serverUrl}users/#{userId}/notifications/#{notificationId}/"
	numberPendingUserNotifications: (userId) -> "#{serverUrl}users/#{userId}/notifications/pending/count"

window.paths = 
	myHome: '/main/home/myhome'
	me: '/main/home/me'
	myDash: '/main/home/mydashboard'
	hisHome: '/main/attend/attendhome'
	hisDash: 'main/attend/attenddashboard'
	homeFavorites: '/main/home/homefavorites'
	notifications: '/main/home/notifications'
	root: '/root'
	login: '/login'
	signup: '/signup'
	singleYan: (yanId) -> "/main/home/singleYan/#{yanId}"

