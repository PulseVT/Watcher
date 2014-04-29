makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class MainCtrl
		constructor: (@scope, @location, @element) ->
			@scope.location = @location
			@scopeFunctions()
			@cssAddons()
			window.helpers = helpers
			window.scope = @scope

		watchers: =>

		cssAddons: =>
			bgIterator = 0
			backgrounds = ['img/resources/backgrounds/homepage-background@2x.jpg', 'img/resources/backgrounds/innerpage-background2@2x.jpg']
			chBg = => @scope.tryApply =>
				@scope.rootBackground = backgrounds[bgIterator]
				bgIterator++
				bgIterator = 0 if bgIterator is backgrounds.length
			@scope.headerButtonsConfig = 
				left:
					name: ''
					backButton:
						src: 'img/resources/header/back-icon@2x.png'
						fcn: => @location.path @scope.headerButtonsConfig.left.backButton.backLocation
				right:
					name: ''
			# setInterval chBg, 2000
			# chBg()

		scopeFunctions: =>
			@scope.init = =>
				setTimeout =>
					$(document).on 'hidden.bs.modal', '#attachFile', =>
						@scope.setProgressVisible no
						@scope.setParsingVisible no
						@scope.setNewYanText ''
					$(document).on 'show.bs.modal', '#attachFile', => 
						@scope.tryApply =>
							angular.element('#attachFile').scope().newYanTextFromCurrentScope = @scope.newYanText
				@scope.paths = paths
				@scope.newYanText = ''
				@scope.pages = #object for loaded data pages
					currentUser: {}
					attendedUser: {}
					yansComments: {}
					userNotifications: {}
					userFavorites: {}
				#@scope.videoUrl = 'http://video-js.zencoder.com/oceans-clip'#'http://www.youtube.com/watch?v=9qfVSVWScvc'#'file:///D:/Films/UVVideoRecord_1_009.avi'
				@watchers()

			@scope.setCurrentUser = (val) => @scope.tryApply =>
				@scope.currentUser = val

			@scope.setProgressVisible = (val) => @scope.tryApply =>
				@scope.progressVisible = val

			@scope.setVideoDuration = (val) => @scope.tryApply =>
				@scope.videoDuration = val

			@scope.setImageParsed = (val) => @scope.tryApply =>
				@scope.imageParsed = val

			@scope.setParsingVisible = (val) => @scope.tryApply =>
				@scope.parsingVisible = val

			@scope.setFile = (val) => @scope.tryApply =>
				@scope.file = val

			@scope.setNewYanText = (val) => @scope.tryApply =>
				@scope.newYanText = val

			@scope.go = (path) => @location.path path

			@scope.tabClass = (tab) =>
				'active' if tab is @location.path()

			@scope.isAtHome = => @scope.tryApply =>
				@location.path().indexOf('/main/home') > -1

			@scope.fileName = (yan) =>
				return yan.content.caption unless yan.content.caption in ['','undefined']
				yan.content.originalFilename

			@scope.objLen = helpers.objLen

			@scope.initSlideshow = =>
				$('.cycle-slideshow').cycle()
				null

			@scope.setPageHeader = (show, val, img, bL, bR) => @scope.timeout => setTimeout => @scope.tryApply => 
				if show 
					@scope.pageHeaderName = val
					@scope.pageHeaderImg = "img/resources/header/header-bg-#{img}.png"
					@scope.headerButtonsConfig.left.name = bL?.name
					@scope.headerButtonsConfig.right.name = bR?.name
					for k, v of bL
						@scope.headerButtonsConfig.left[bL.name][k] = v if k isnt 'name'
					for k, v of bR
						@scope.headerButtonsConfig.right[bR.name][k] = v if k isnt 'name'
				else 
					@scope.pageHeaderName = null
					@scope.pageHeaderImg = null

			@scope.firstSegmentClass = =>
				if @scope.pageHeaderName? then 'marginTop40' else ''



		
			@scope.dbWrite = =>
				db = window.openDatabase "Database", "1.0", "Cordova Demo", 200000
				db.transaction (tx) =>
					tx.executeSql 'DROP TABLE IF EXISTS TOKENS'
					tx.executeSql 'CREATE TABLE IF NOT EXISTS TOKENS (key, data)'
					tx.executeSql 'INSERT INTO TOKENS (key, data) VALUES ("access_token", "First row")'
					tx.executeSql 'INSERT INTO TOKENS (key, data) VALUES ("refresh_token", "Second row")'
				, (e) =>
					console.log e
				, (e) =>
					console.log e

			@scope.dbRead = =>
				db = window.openDatabase "Database", "1.0", "Cordova Demo", 200000
				db.transaction (tx) =>
					tx.executeSql "SELECT * FROM TOKENS", [], (tx, res) =>
						console.log res
					, (e) =>
						console.log e
				, (e) =>
					console.log e
				, (e) =>
					console.log e

	@MainCtrl = ($scope, $location, $element) ->
		new MainCtrl arguments...