AddonBuilder clone do(
	dependsOnLib("cairo")
	dependsOnHeader("cairo.h")
	
	// cairo has its headers in /usr/local/lib/cairo on my system.  Is this not strange?
	headerSearchPaths foreach(path, appendHeaderSearchPath(path .. "/cairo"))
)
