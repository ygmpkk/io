roundToPowerOf2 := method(v,
	v = v - 1
	v = v | (v shiftRight(1))
	v = v | (v shiftRight(2))
	v = v | (v shiftRight(4))
	v = v | (v shiftRight(8))
	v = v | (v shiftRight(16))
	v = v + 1
)
	
Texture := Object clone do(
	appendProto(OpenGL)
	
	originalWidth := 0
	originalHeight := 0
	width := 0
	height := 0
	format := nil
	
	with := method(anImage,
		clone uploadImage(anImage)
	)
	
	id := lazySlot(
		ids := List clone
		glGenTextures(1, ids)
			
		glBindTexture(GL_TEXTURE_2D, ids at(0))

		# Set the default parameters.
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT)
	
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR)
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR)
	
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE)

		ids at(0)
	)
	
	bind := method(
		glBindTexture(GL_TEXTURE_2D, id)
		self
	)
	
	uploadImage := method(anImage,
		bind
	
		sizeIsSame := anImage width == originalWidth and anImage height == originalHeight and anImage glFormat == format
		if (sizeIsSame == false,
			self width = self originalWidth = anImage width
			self height = self originalHeight = anImage height
			self format = anImage glFormat
		)

		glPixelStorei(GL_UNPACK_ALIGNMENT, 1)

		if (anImage sizeIsPowerOf2 == false,
			if (sizeIsSame == false,
				self width := roundToPowerOf2(originalWidth)
				self height := roundToPowerOf2(originalHeight)
				data := Sequence clone setSize(width * height * anImage componentCount)
				glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, data)
			)

			glPixelStorei(GL_UNPACK_ROW_LENGTH, originalWidth)
			glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, originalWidth, originalHeight, format, GL_UNSIGNED_BYTE, anImage data)
			,

			glPixelStorei(GL_UNPACK_ROW_LENGTH, width)
			glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, anImage data)
		)
		
		self
	)
	
	uploadSubImage := method(anImage, x, y,
		bind
		glTexSubImage2D(GL_TEXTURE_2D, 0, x, y, anImage width, anImage height, anImage glFormat, GL_UNSIGNED_BYTE, anImage data)
		self
	)

	setParameter := method(param, value,
		bind
		glTexParameteri(param, value)
		self
	)
	
	setSWrap := method(value,
		setParameter(GL_TEXTURE_WRAP_S, value)
	)

	setTWrap := method(value,
		setParameter(GL_TEXTURE_WRAP_T, value)
	)
		
	setMinFilter := method(value,
		setParameter(GL_TEXTURE_MIN_FILTER, value)
	)

	setMagFilter := method(value,
		setParameter(GL_TEXTURE_MAG_FILTER, value)
	)
	
	setEnvMode := method(value,
		bind
		glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, value)
		self
	)
	
	draw := method(w, h,
		glPushAttrib(GL_TEXTURE_BIT)
		glEnable(GL_TEXTURE_2D)
		bind
	
		w = w ifNilEval(originalWidth)
		h = h ifNilEval(originalHeight)
		wr := w / width
		hr := h / height
		
		# the y texture coords are flipped since the image data starts with y=0
		glBegin(GL_QUADS)

		glTexCoord2f(0,  0)
		glVertex2i(0, h)
	
		glTexCoord2f(0,  hr)
		glVertex2i(0, 0)

		glTexCoord2f(wr,  hr)
		glVertex2i(w, 0)

		glTexCoord2f(wr, 0)
		glVertex2i(w, h)

		glEnd
		glPopAttrib

		self
	)
	
	drawScaled := method(w, h,
		glPushAttrib(GL_TEXTURE_BIT)
		glEnable(GL_TEXTURE_2D)
		bind

		w = w ifNilEval(originalWidth)
		h = h ifNilEval(originalHeight)

		# the y texture coords are flipped since the image data starts with y=0
		glBegin(GL_QUADS)

		glTexCoord2f(0,  0)
		glVertex2i(0, h)

		glTexCoord2f(0,  1)
		glVertex2i(0, 0)

		glTexCoord2f(1,  1)
		glVertex2i(w, 0)

		glTexCoord2f(1, 0)
		glVertex2i(w, h)

		glEnd
		glPopAttrib

		self
	)
	
	willFree := method(
		glDeleteTextures(1, list(id))
	)
)
