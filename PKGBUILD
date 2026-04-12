# Maintainer: hnchengzong
pkgname=jlu-drcom
pkgver=1.0.0
pkgrel=1
pkgdesc="吉林大学校园网客户端"
arch=('x86_64')
url="https://github.com/yourname/drclient"
license=('custom')
depends=()
makedepends=()
source=("jlu-drcom-$pkgver.tar.xz")
sha256sums=('SKIP')   
package() {
  cd "$srcdir/$pkgname-$pkgver"

  install -d "$pkgdir/opt/drclient/translator"

  install -Dm755 DrClientLinux "$pkgdir/opt/drclient/DrClientLinux"
  install -Dm644 libjpeg.so.62 "$pkgdir/opt/drclient/libjpeg.so.62"
  install -Dm644 libpng12.so.0 "$pkgdir/opt/drclient/libpng12.so.0"
  install -Dm644 DrClientLinux.rcc "$pkgdir/opt/drclient/DrClientLinux.rcc"
  install -Dm755 change.sh "$pkgdir/opt/drclient/change.sh"
  install -Dm755 privillege.sh "$pkgdir/opt/drclient/privillege.sh"
  install -Dm755 hostinfo.sh "$pkgdir/opt/drclient/hostinfo.sh"
  install -Dm755 pppoe-status "$pkgdir/opt/drclient/pppoe-status"
  install -Dm644 translator/localizer_chs.qm "$pkgdir/opt/drclient/translator/localizer_chs.qm"
  install -Dm755 drcomauthsvr "$pkgdir/opt/drclient/drcomauthsvr"
  install -Dm644 drcomauthsvr.drsc "$pkgdir/opt/drclient/drcomauthsvr.drsc"
  install -Dm644 drcomrulesvr.drsc "$pkgdir/opt/drclient/drcomrulesvr.drsc"

  chown root:root "$pkgdir/opt/drclient/drcomauthsvr"
  chmod 4755 "$pkgdir/opt/drclient/drcomauthsvr"

  install -d "$pkgdir/usr/bin"
  cat > "$pkgdir/usr/bin/jlu-drcom" << 'EOF'
#!/bin/sh
cd /opt/drclient || exit 1
export LD_LIBRARY_PATH=/opt/drclient:$LD_LIBRARY_PATH
exec /opt/drclient/DrClientLinux "$@"
EOF
  chmod 755 "$pkgdir/usr/bin/jlu-drcom"
}
