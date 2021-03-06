# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# Set URI name based on version. Perhaps develop an eclass.

if [[ "${PV}" == "9999" ]]; then
	inherit bzr
	EBZR_REPO_URI="lp:${PN}"
	KEYWORDS=""
else
	SRC_URI="https://launchpad.net/${PN}/loki/${PV}/+download/${P}.tar.xz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Pantheon DE meta package"
HOMEPAGE="http://www.elementaryos.org/ http://launchpad.net/elementaryos/"

EBZR_REPO_URI="lp:~elementary-os/elementaryos/pantheon-xsession-settings"

LICENSE="GPL-3"
SLOT="0"
IUSE="+lightdm +screensaver web"

CDEPEND="
	lightdm? ( >=pantheon-base/pantheon-greeter-1.0 )"
RDEPEND="${CDEPEND}
	>=gnome-base/gnome-session-3.0
	>=gnome-base/gnome-settings-daemon-3.0
	>=pantheon-base/cerbere-0.2
	pantheon-base/plank
	>=pantheon-base/slingshot-0.7
	>=pantheon-base/wingpanel-0.2
	pantheon-base/pantheon-settings
	>=x11-themes/elementary-theme-3.4
	x11-wm/gala
	screensaver? ( || ( x11-misc/light-locker gnome-extra/gnome-screensaver x11-misc/xscreensaver ) )
	web? ( www-client/epiphany )"
DEPEND="${CDEPEND}"

src_prepare() {
	eapply_user

	# Use gnome as fallback instead of ubuntu and mutter instead of gala
	sed -i -e 's/ubuntu/gnome/' debian/pantheon.session

	# Use gnome-session wrapper that sets XDG_CURRENT_DESKTOP
	sed -i 's/gnome-session --session=pantheon/pantheon-session/' debian/pantheon.desktop

	# Correct paths
	sed -i 's#/usr/lib/[^/]*/#/usr/libexec/#' autostart/*
}

src_install() {
	insinto /usr/share/gnome-session/sessions
	doins gnome-session/*

	insinto /usr/share/xsessions
	doins xsessions/*

	insinto /usr/share/wayland-sessions
	doins wayland-sessions/*

	insinto /etc/xdg/autostart
	doins autostart/*

	insinto /usr/share/pantheon
	doins -r applications

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}/Pantheon"

	dobin "${FILESDIR}/pantheon-session"
}

