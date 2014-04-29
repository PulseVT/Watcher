makeRequest = window.app.makeRequest
helpers = window.app.helpers

window.namespace 'app.controllers', ->

	class SignupCtrl
		constructor: (@scope, @element, @location, @AddUser) ->
			@scopeFunctions()
		
		watchers: =>

		scopeFunctions: =>
			@scope.init = => 
				@scope.location = @location
				@watchers()
				setTimeout => 
					$('#signup-datepicker').pickadate()

			@scope.signUp = =>
				errors = @checkFormErrors()
				if errors isnt ''
					alert errors
				else					
					picker = $('#signup-datepicker').pickadate 'picker'
					data =
						params: 
							gender: @scope.signupForm.gender.$viewValue
							birthday: picker.get('select').pick
							description: @scope.signupForm.description.$viewValue
							username: @scope.signupForm.nick.$viewValue
							firstName: @scope.signupForm.name.$viewValue
							lastName: @scope.signupForm.surname.$viewValue
							password: @scope.signupForm.password.$viewValue
							email: @scope.signupForm.email.$viewValue
					data.params.file = @scope.avatar if @scope.avatar? 

					makeRequest @AddUser, data, (user) =>
						@location.path paths.login
						setTimeout => alert 'signed up successfully'

			@scope.onAvatarChange = (elem) =>
				$('#subfile').val elem.files[0].name
				@scope.avatar = elem.files[0] or null

			@scope.onBirthdayChange = =>
				console.log @scope.signupForm.birthday.$viewValue

			@scope.showSignupDatepicker = =>
				event.stopPropagation()
				$('#signup-datepicker').pickadate 'open'
				null
				# window.plugins.datePicker.show
				# 	date : myNewDate
				# 	mode : 'date'
				# 	minDate: new Date
				# 	maxDate: new Date
				# , (returnDate) =>
				# 	if returnDate isnt ""
				# 		newDate = new Date returnDate
				# 		currentField.val getFormattedDate newDate
				# 	currentField.blur()

		checkFormErrors: =>
			error = ''
			# error += "Password is not confirmed\n" if @scope.signupForm.password.$viewValue isnt @scope.signupForm.confirmPassword.$viewValue
			# error += "Password too short (<6 symbols)" if @scope.signupForm.password.$viewValue.length < 6
			error

	@SignupCtrl = ($scope, $element, $location, AddUser) ->
		new SignupCtrl arguments...