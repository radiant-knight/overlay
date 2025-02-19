# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg-utils

DESCRIPTION="qBittorrent Enhanced, based on qBittorrent"
HOMEPAGE="https://github.com/c0re100/qBittorrent-Enhanced-Edition"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/c0re100/qBittorrent-Enhanced-Edition.git"
else
	SRC_URI="https://github.com/c0re100/qBittorrent-Enhanced-Edition/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/qBittorrent-Enhanced-Edition-release-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus debug webui +X"
REQUIRED_USE="dbus? ( X )"

RDEPEND="
	>=dev-libs/boost-1.62.0-r1:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtxml:5
	dev-qt/qtsql:5
	>=net-libs/libtorrent-rasterbar-1.2.12:0=
	sys-libs/zlib
	dbus? ( dev-qt/qtdbus:5 )
	X? (
		dev-libs/geoip
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
	!net-p2p/qbittorrent"
DEPEND="${RDEPEND}
	dev-qt/linguist-tools:5"

BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md TODO )

src_configure() {
	econf \
	$(use_enable dbus qt-dbus) \
	$(use_enable debug) \
	$(use_enable webui) \
	$(use_enable X gui) \
	--disable-stacktrace
}

src_install() {
	emake STRIP="/bin/false" INSTALL_ROOT="${D}" install
	einstalldocs
}

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
