iYans = angular.module 'iyans', ['ngRoute', 'route-segment', 'view-segment']

iYans.service 'Login', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).Login
iYans.service 'GetToken', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).GetToken
iYans.service 'RefreshToken', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).RefreshToken
iYans.service 'LoginWithToken', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).LoginWithToken
iYans.service 'Logout', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).Logout
iYans.service 'UsersById', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).UsersById
iYans.service 'UserById', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).UserById
iYans.service 'AllUsers', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AllUsers
iYans.service 'AddUser', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AddUser
iYans.service 'AddYan', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AddYan
iYans.service 'GetYan', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).GetYan
iYans.service 'DeleteYan', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).DeleteYan
iYans.service 'AllUserHomeYans', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AllUserHomeYans
iYans.service 'AllUserYans', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AllUserYans
iYans.service 'AllUserReyans', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AllUserReyans
iYans.service 'AllUserYansAndReyans', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AllUserYansAndReyans
iYans.service 'FollowUser', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).FollowUser
iYans.service 'UnfollowUser', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).UnfollowUser
iYans.service 'AllUserFollowers', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AllUserFollowers
iYans.service 'AddReyan', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AddReyan
iYans.service 'RemoveReyan', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).RemoveReyan
iYans.service 'AddComment', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AddComment
iYans.service 'GetComments', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).GetComments
iYans.service 'DeleteComment', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).DeleteComment
iYans.service 'NumberUsers', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).NumberUsers
iYans.service 'NumberUserFollowers', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).NumberUserFollowers
iYans.service 'AttachFile', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AttachFile
iYans.service 'AddFavorite', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AddFavorite
iYans.service 'RemoveFavorite', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).RemoveFavorite
iYans.service 'NumberYanFavourites', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).NumberYanFavourites
iYans.service 'GetYanFavorites', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).GetYanFavorites
iYans.service 'GetUserFavorites', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).GetUserFavorites
iYans.service 'AddLike', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AddLike
iYans.service 'RemoveLike', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).RemoveLike
iYans.service 'NumberYanLikes', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).NumberYanLikes
iYans.service 'ReadNotification', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).ReadNotification
iYans.service 'AllUserNotifications', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).AllUserNotifications
iYans.service 'PendingUserNotifications', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).PendingUserNotifications
iYans.service 'DeleteNotification', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).DeleteNotification
iYans.service 'NumberPendingUserNotifications', ($rootScope, $q, $http) -> @get = app.services($rootScope, $q, $http).NumberPendingUserNotifications


iYans.directive 'makeYan', -> window.app.directives.MakeYan
iYans.directive 'userNameFormat', -> window.app.directives.UserNameFormat
iYans.directive 'yansSection', -> window.app.directives.YansSection
iYans.directive 'addVideo', -> window.app.directives.AddVideo
iYans.directive 'addImage', -> window.app.directives.AddImage
iYans.directive 'showNotification', -> window.app.directives.ShowNotification

iYans.run ['$rootScope', '$compile', '$timeout', ($rootScope, $compile, $timeout) ->
	$rootScope.tryApply = (act) => if $rootScope.$$phase then act() else $rootScope.$apply act
	$rootScope.timeout = $timeout
	$rootScope.compile = $compile
]

html = window.html
ctrls = window.app.controllers

iYans.config ($routeSegmentProvider, $routeProvider) ->
	$routeSegmentProvider
		.when('/root', 'root')
		.when('/login', 'login')
		.when('/signup', 'signup')
		.when('/main', 'main')
		.when('/main/home', 'main.home')
		.when('/main/home/singleYan', 'main.home.singleYan')
		.when('/main/home/singleYan/:yanId', 'main.home.singleYan.yan')
		.when('/main/home/notifications', 'main.home.notifications')
		.when('/main/home/homefavorites', 'main.home.homefavorites')
		.when('/main/home/myhome', 'main.home.myhome')
		.when('/main/home/me', 'main.home.me')
		.when('/main/home/mydashboard', 'main.home.mydashboard')
		.when('/main/attend', 'main.attend')
		.when('/main/attend/attendhome', 'main.attend.attendhome')
		.when('/main/attend/attenddashboard', 'main.attend.attenddashboard')
		.segment('root',
			template: html.root
		)
		.segment('login', 
			template: html.login
		)
		.segment('signup',
			template: html.signup
		)	
		.segment('main',
			template: html.main
		)
		.within()
			.segment('home',
				template: html.home
			)
			.within()
				.segment('singleYan',
					template: ''
				)
				.within()
					.segment('yan',
						template: html.singleYan
					)
					.up()
				.segment('notifications',
					template: html.notifications
				)
				.segment('homefavorites',
					template: html.homefavorites
				)
				.segment('mydashboard',
					template: html.homeDashboard
				)
				.segment('myhome',
					template: html.yans
				)
				.segment('me',
					template: html.yans
				)
				.up()
			.segment('attend',
				template: html.attend
			)
			.within()
				.segment('attendhome'
					template: html.yans
				)
				.segment('attenddashboard',
					template: html.attendDashboard
				)

	$routeProvider.otherwise 
		redirectTo: '/root'