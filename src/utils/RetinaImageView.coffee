`import ui.ImageView`
`import ui.resource.Image as Image`

# this class try to find @2x version of image when the scale is 2.
class RetinaImageView extends ui.ImageView
	init: (opts) ->
		
		imagePath = opts.image
		opts.image = undefined # deleted the opts.image because we are goint to use setImage method
		super opts
		
		if GC.app.view.style.scale == 2
			img = new Image
				url: imagePath[0..-5] + '@2x' + imagePath[-4..999]			
			img.doOnLoad (e) =>				
				if e != null && e.NoImage
					img2 = new Image
						url: imagePath
					@setImage img2
				else
					@setImage img					

		else
			img = new Image
				url: imagePath
			@setImage img

		

		return yes

`exports = RetinaImageView`