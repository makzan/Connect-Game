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

		new DotsGrid
			superview: @
			x: 0
			y: 0			



		
	launchUI: -> yes

`exports = Game`