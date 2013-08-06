`import ui.View`
`import math.util`

class Dot extends ui.View
	@patterns = [
		'#3482ec'
		'#814000'
		'#e0d430'
		'#d74dbe'
		'#54ca5d'
	]
	@random_pattern: -> math.util.random(0, Dot.patterns.length)
	init: (@grid_i, @grid_j, @pattern_no, opts)->
		opts = merge opts, 			
			backgroundColor: Dot.patterns[@pattern_no]

		super opts


`exports = Dot`