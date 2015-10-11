FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

# workaround linaro gcc bug
#  https://bugs.linaro.org/show_bug.cgi?id=534
SRC_URI_append = " file://0001-Removed-CXX11-flags-that-confuzed-Linaro-GCC.patch "
   
# switch to GLES 2 support
PACKAGECONFIG_GL = "${@base_contains('DISTRO_FEATURES', 'opengl', 'gles2', '', d)}"
PACKAGECONFIG[gles2] = "-opengl es2 -no-eglfs,,virtual/libgles2 virtual/egl"
PACKAGECONFIG_X11_remove = "${@base_contains('DISTRO_FEATURES', 'wayland', 'xcb xvideo xsync xshape xrender xrandr xfixes xinput2 xinput xinerama xcursor gtkstyle xkb', '', d)}"

# add necessary packages
PACKAGECONFIG_append = " \
	sql-sqlite \
	sql-sqlite2 \
	openssl \
	icu \
	accessibility \
	examples \
	alsa \
"

CONF_ADD_X11 = "${@base_contains('DISTRO_FEATURES', 'x11', ' -qpa xcb', '', d)}"
CONF_REM_X11 = ""
CONF_ADD_WAYLAND = "${@base_contains('DISTRO_FEATURES', 'wayland', ' -qpa wayland -wayland', '', d)}"
CONF_REM_WAYLAND = "${@base_contains('DISTRO_FEATURES', 'wayland', ' -xcb -xcb-xlib -system-xcb', '', d)}"

# Select wayland as the default platform abstraction plugin for Qt
EXTRA_OECONF_remove = " \
			${CONF_REM_X11} \
			${CONF_REM_WAYLAND} \
			"

EXTRA_OECONF_append = " \
			${CONF_ADD_X11} \
			${CONF_ADD_WAYLAND} \
"

DEPENDS += "gles-user-module"
