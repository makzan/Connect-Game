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
			@score += Math.pow(2, count-1)
			text = @score + ""
			text = "0000" + text if text.length == 1
			text = "000" + text if text.length == 2
			text = "00" + text if text.length == 3
			text = "0" + text if text.length == 4

			score_text.setText text

		@score = 0
		score_text = new TextView
			superview: @
			x: 4
			y: 4
			width: Setting.game_width
			height: 20
			horizontalAlign: "left"
			text: "00000"
			size: 24
			color: '#222222'




		
	launchUI: -> yes

`exports = Game`