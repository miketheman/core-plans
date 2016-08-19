pkg_name=mongodb
pkg_origin=core
pkg_version=3.2.9
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_description="High-performance, schema-free, document-oriented database"
pkg_upstream_url="https://www.mongodb.org/"
pkg_license=('AGPL-3.0')
pkg_source=https://fastdl.mongodb.org/src/mongodb-src-r${pkg_version}.tar.gz
pkg_shasum=25f8817762b784ce870edbeaef14141c7561eb6d7c14cd3197370c2f9790061b
pkg_deps=(core/gcc-libs core/glibc)
pkg_build_deps=(
  core/coreutils
  core/gcc
  core/python2
  core/scons
)
pkg_bin_dirs=(bin)
pkg_lib_dirs=(lib)
pkg_include_dirs=(include)
pkg_dirname=${pkg_name}-r${pkg_version}

do_prepare() {
  if [[ ! -r /usr/bin/basename ]]; then
    ln -sv "$(pkg_path_for coreutils)/bin/basename" /usr/bin/basename
    _clean_basename=true
  fi

  if [[ ! -r /usr/bin/tr ]]; then
    ln -sv "$(pkg_path_for coreutils)/bin/tr" /usr/bin/tr
    _clean_tr=true
  fi
}

do_unpack() {
  mkdir -p $pkg_dirname
  tar -xzf "$pkg_filename" -C $pkg_dirname --strip-components=1
}

do_build() {
  CC="$(pkg_path_for gcc)/bin/gcc"
  CXX="$(pkg_path_for gcc)/bin/g++"
  scons --prefix="$pkg_prefix" CXX="$CXX" CC="$CC" --release core
}

do_check() {
  scons --prefix="$pkg_prefix" CXX="$CXX" CC="$CC" --release dbtests
}

do_install() {
  scons install
}

do_end() {
  if [[ -n "$_clean_basename" ]]; then
    rm -fv /usr/bin/basename
  fi

  if [[ -n "$_clean_tr" ]]; then
    rm -fv /usr/bin/tr
  fi
}
