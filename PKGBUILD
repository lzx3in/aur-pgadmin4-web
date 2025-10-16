pkgname=pgadmin4-web
pkgver=9.9
pkgrel=1
pkgdesc='The web interface for pgAdmin, hosted under Apache HTTPD. pgAdmin is the most popular and feature rich Open Source administration and development platform for PostgreSQL, the most advanced Open Source database in the world.'
arch=('x86_64')
license=('PostgreSQL')
url='https://www.pgadmin.org/'
depends=("pgadmin4-server>=${pkgver}-1")
makedepends=("syft")
provides=('pgadmin4-web')
source=("pgadmin4-${pkgver}.tar.gz::https://ftp.postgresql.org/pub/pgadmin/pgadmin4/v${pkgver}/source/pgadmin4-${pkgver}.tar.gz")
sha256sums=('108e16272f82a87eb6483f401f54e46326da8c48e014ab2dd742640dc6f995f2')

build() {
  cd "$srcdir/pgadmin4-${pkgver}"

  WEBROOT="${srcdir}/pgadmin4-${pkgver}/arch-build/web"

  mkdir -p "${WEBROOT}/usr/pgadmin4/bin/"
  cp "pkg/linux/setup-web.sh" "${WEBROOT}/usr/pgadmin4/bin/"

  syft "${WEBROOT}/" -o cyclonedx-json > "${WEBROOT}/usr/pgadmin4/sbom-web.json"

  mkdir -p "${WEBROOT}/etc/apache2/conf-available"
  cp "pkg/debian/pgadmin4.conf" "${WEBROOT}/etc/apache2/conf-available"
}

package() {
  cp -r "${srcdir}/pgadmin4-${pkgver}/arch-build/web/usr"  "${pkgdir}/"
  cp -r "${srcdir}/pgadmin4-${pkgver}/arch-build/web/etc"  "${pkgdir}/"
}
