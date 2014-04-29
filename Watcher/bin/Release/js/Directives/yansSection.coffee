window.namespace 'app.directives', ->

	class YansSection
		constructor: (@scope, @element, @attrs) ->
			@onChange()
			
		onChange: =>
			return unless @attrs.yansSection
			@element.html @generateYansSection JSON.parse @attrs.yansSection
			@scope.compile(@element.contents()) @scope

		generateYansSection: (params) =>
			html = ''
			html += @generateAddYanField() if params.forCurrentUser
			html += "<ul class='yans-list span12'>
						<li ng-repeat='yan in #{params.yansObjectName}' ng-controller='app.controllers.YanCtrl' ng-init='init()'>
							<div class='yan span12'>
								<div class='span2'>
									<img class='yan-img' ng-click='goToAnotherUser(\"{{yan.author}}\")' ng-src='{{usersById[yan.author].img}}'></img>
								</div>
								<div class='yan-content span7'>
									<div class='span12 user-name' ng-click='goToAnotherUser(\"{{yan.author}}\")' user-name-format='{{usersById[yan.author]}}'>
									</div>
									<div class='span12 yan-text'>
										{{yan.content}}
									</div>
								</div>
								<div class='span3 buttons'>
									<button class='remove-button' ng-show='yan.author==currentUser._id' ng-click='deleteYan()'>Delete</button>
									<button ng-show='currentUser._id!=yan.author && !reyansById[yan._id]' ng-click='addReyan({{yan}})'>Re-yan</button>
									<button class='remove-button' ng-show='currentUser._id!=yan.author && reyansById[yan._id]' ng-click='removeReyan(\"{{yan._id}}\")'>Remove re-yan</button>
								</div>
								Time: <span class='bolder'>{{dateFormat(yan.createdAt)}}</span>
							</div>
						</li>
					</ul>"
			html

		generateAddYanField: =>
			"<div class='add-yan span12'>
				<div class='add-yan-label'>What's up to you?</div>
				<div class='add-yan-text'>
					<textarea rows='2' cols='50' ng-model='newYanText'></textarea>
				</div>
				<button ng-click='addYan()' ng-disabled='!newYanText'>Yan!</button>
			</div>"

	@YansSection = ($scope, $element, $attrs) ->
		new YansSection arguments...
	