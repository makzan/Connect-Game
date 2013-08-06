`import ui.View`
`import src.gameobject.Dot as Dot`
`import src.Setting as Setting`
`import animate`

class DotsGrid extends ui.View
	init: (opts) ->

		@columns = 5
		@rows = 5

		@margin = 30

		@dot_width = 25
		@dot_height = @dot_width		
		grid_width = Setting.game_width - @margin * 2
		@dot_col_space = (grid_width - @columns * @dot_width) / (@columns - 1)
		@dot_row_space = @dot_col_space
		@grid_height = @rows * (@dot_row_space + @dot_height)

		
		@offset_y = 50

		opts = merge opts,
			x: 0
			y: 0
			width: Setting.game_width
			height: Setting.game_height

		super opts

		@data = []
		@dots_array = []

		@current_pattern = undefined
		@selected_dots = []

		that = this

		for i in [0...@columns]
			@data[i] = []
			@dots_array[i] = []
			for j in [0...@rows]
				pattern = Dot.random_pattern()

				# for data array
				@data[i].push pattern

				# for visual
				dot = @create_new_dot i, j, pattern				

				@dots_array[i].push dot

		@on "InputSelect", @finish_selection
		return yes

	create_new_dot: (i, j, pattern) ->
		that = this
		dot = new Dot i, j, pattern, 
			superview: @
			x: @margin + i * (@dot_col_space + @dot_width)
			y: @offset_y + @grid_height - @dot_height - j * (@dot_row_space + @dot_height)
			width: @dot_width
			height: @dot_height					
		dot.on "InputOver", (over, overCount, atTarget) ->
			that.select_dot @
		return dot

	finish_selection: ->
		# console.log "Finish selection"

		# remove all dots
		console.log "--------------------------"
		for dot in @selected_dots
			console.log "(#{dot.grid_i}, #{dot.grid_j})"

			# in data
			@data[dot.grid_i][dot.grid_j] = -1			

			# visually
			dot.removeFromSuperview()
		@selected_dots.length = 0
		
		@fall_dots()
		@new_dots()

	fall_dots: ->
		# data: fall the dots
		for i in [0...@columns]
			for j in [@rows-1..0]
				if @data[i][j] < 0
					@dots_array[i].splice j, 1
					@data[i].splice j, 1

		@update_data_array()

		# visual: fall the dots
		for i of @dots_array
			for j of @dots_array[i]
				dot = @dots_array[i][j]
				dot.grid_j = j
				animate(dot).then
					y: @offset_y + @grid_height - @dot_height - j * (@dot_row_space + @dot_height)
				, 300, animate.easeOut

	new_dots: ->
		# data: fill in the dots
		for i in [0...@columns]
			if @data[i].length < @rows
				for j in [@data[i].length...@rows]
					pattern = Dot.random_pattern()
					dot = @create_new_dot i, j, pattern
					dot.style.y = -Setting.game_height-@dot_height
					animate(dot).wait(300).then(
						{y: @offset_y + @grid_height - @dot_height - j * (@dot_row_space + @dot_height)}
					, 300, animate.easeOut)
					@dots_array[i].push dot

		@update_data_array()

	update_data_array: -> 
		for i of @dots_array
			@data[i].length = 0
			for j of @dots_array[i]
				@data[i].push @dots_array[i][j].pattern_no

	select_dot: (dot) ->
		is_adjacent = (dot1, dot2) ->
			return no if dot1 == dot2
			return yes if dot1.grid_i == dot2.grid_i && Math.abs(dot1.grid_j - dot2.grid_j) == 1
			return yes if dot1.grid_j == dot2.grid_j && Math.abs(dot1.grid_i - dot2.grid_i) == 1
			return no

		# console.log "Selected dot:", dot.grid_i, dot.grid_j, dot.pattern_no, "current pattern:", @current_pattern
		if @selected_dots.length == 0
			@current_pattern = dot.pattern_no
			@selected_dots.push dot
		else if @current_pattern == dot.pattern_no
			if is_adjacent(dot, @selected_dots[@selected_dots.length - 1])
				@selected_dots.push dot

`exports = DotsGrid`