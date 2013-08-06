`import ui.TextView as TextView`
`import ui.View as View`
`import src.Setting as Setting`
`import src.gameobject.DotsGrid as DotsGrid`
`import device`

class Game extends GC.Application

	initUI: -> 		
		bg = new View
			superview: @
			width: Setting.game_width
			height: Setting.game_height
			backgroundColor: '#efefef'

		if device.width / 2 >= Setting.game_width && device.height / 2 >= Setting.game_height
			GC.app.view.style.scale = 2
			GC.app.view.style.x = 0
			GC.app.view.style.y = 0
			@style.x = device.width/2/GC.app.view.style.scale - Setting.game_width/2
			@style.y = device.height/2/GC.app.view.style.scale - Setting.game_height/2

		dot_grid = new DotsGrid
			superview: @
			x: 0
			y: 0
		dot_grid.on "score:update", (count) =>
			@score += Math.floor(Math.pow(2, count-1)) # score is 2^(count-1)
			score_text.setText @score_in_text @score

		@score = 0
		score_text = new TextView
			superview: @
			x: 6
			y: 4
			width: Setting.game_width/2
			height: 20
			horizontalAlign: "left"
			text: "00000"
			size: 24
			color: '#222222'

		new TextView
			superview: @
			x: 6
			y: 28
			width: Setting.game_width/2
			height: 20
			horizontalAlign: "left"
			text: @score_in_text @highest_score()
			size: 24
			color: '#666666'

		@timer = 60
		@timer_text = new TextView
			superview: @
			x: Setting.game_width/2
			y: 4
			width: Setting.game_width/2 - 6
			height: 20
			horizontalAlign: "right"
			text: @timer+""
			size: 24
			color: '#222222'

		@tick_time = 0

		@is_game_over = false

	update_timer: ->
		@timer -= 1
		if @timer <= 0
			@timer = 0
			@is_game_over = true
			@save_highest_score(@score)

		@timer_text.setText @timer
		@timer_text.updateOpts {color: '#db8200'} if @timer < 15
		@timer_text.updateOpts {color: '#db2300'} if @timer < 10
			
	save_highest_score: (score) ->		
		localStorage['game:score:highest'] = score if score >= @highest_score()
	highest_score: -> localStorage['game:score:highest'] || 0
	score_in_text: (score) ->
		text = score + ""
		text = "0000" + text if text.length == 1
		text = "000" + text if text.length == 2
		text = "00" + text if text.length == 3
		text = "0" + text if text.length == 4
		return text



	tick: (dt)->
		@tick_time += dt
		if @tick_time > 1000
			@tick_time = 0
			@update_timer()




		
	launchUI: -> yes

`exports = Game`