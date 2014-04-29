iYansLogin = angular.module 'iyansLogin', ['ngRoute', 'route-segment', 'view-segment'] #'ngRoute', 'route-segment', 'view-segment'

iYansLogin.run ['$rootScope', '$compile', '$timeout', ($rootScope, $compile, $timeout) ->
	$rootScope.tryApply = (act) => if $rootScope.$$phase then act() else $rootScope.$apply act
	$rootScope.timeout = $timeout
	$rootScope.compile = $compile
]


iYansLogin.config ($routeSegmentProvider, $routeProvider) ->
	$routeSegmentProvider
		.when('/login', 'l')
		.when('/signup', 's')
		.segment('l', 
			template: loginHtml
		).
		segment('s',
			template: signupHtml
		)
	$routeProvider.otherwise 
		redirectTo: 'login'