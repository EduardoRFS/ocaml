#! /bin/bash

set -e
set -u
set -x

## Parameters
OCAML_HOST=$(dirname $(which ocamlrun))/../
ROOTDIR=$PWD

## Advanced
TARGET_BINDIR="$OCAML_HOST/bin"

CAMLRUN="$OCAML_HOST/bin/ocamlrun"
CAMLLEX="$OCAML_HOST/bin/ocamllex"
CAMLYACC="$OCAML_HOST/bin/ocamlyacc"
CAMLDOC="$OCAML_HOST/bin/ocamldoc"
CAMLDEP="$OCAML_HOST/bin/ocamlc -depend"

HOST_CAMLC="$OCAML_HOST/bin/ocamlc"
HOST_CAMLOPT="$OCAML_HOST/bin/ocamlopt"

TARGET_CAMLC="$ROOTDIR/ocamlc.opt"
TARGET_CAMLOPT="$ROOTDIR/ocamlopt.opt"

HOST_STATIC_LIBS="-I $OCAML_HOST/lib/ocaml"
DYNAMIC_LIBS="-I $OCAML_HOST/lib/ocaml/stublibs"

TARGET_STATIC_LIBS="-I $ROOTDIR/stdlib -I $ROOTDIR/otherlibs/unix"

make_caml () {
  CAMLC_FLAGS="-nostdlib $STATIC_LIBS $DYNAMIC_LIBS"
  CAMLOPT_FLAGS="-nostdlib $STATIC_LIBS"

  CAMLC="$CAMLC $CAMLC_FLAGS"
  CAMLOPT="$CAMLOPT $CAMLOPT_FLAGS"

  make -j8 \
    TARGET_BINDIR="$TARGET_BINDIR" \
    \
    CAMLRUN="$CAMLRUN" \
    CAMLC="$CAMLC" \
    CAMLOPT="$CAMLOPT" \
    CAMLLEX="$CAMLLEX" \
    CAMLYACC="$CAMLYACC" \
    \
    COMPILER="" \
    OPTCOMPILER="" \
    CAMLDEP="$CAMLDEP" \
    \
    OCAMLRUN="$CAMLRUN" \
    OCAMLC="$CAMLC" \
    OCAMLOPT="$CAMLOPT" \
    OCAMLLEX="$CAMLLEX" \
    OCAMLYACC="$CAMLYACC" \
    \
    OCAMLDOC_RUN="$CAMLDOC" \
    $@
}

make_host () {
  STATIC_LIBS="$HOST_STATIC_LIBS"
  CAMLC=$HOST_CAMLC
  CAMLOPT=$HOST_CAMLOPT
  make_caml $@
}

make_target () {
  STATIC_LIBS="$TARGET_STATIC_LIBS"
  CAMLC=$TARGET_CAMLC
  CAMLOPT=$TARGET_CAMLOPT
  make_caml $@
}

## missing ocamldoc, ocamltest, ocamldoc.opt, ocamltest.opt, so copy them?
## mostly extracted from opt.opt on ocaml/Makefile, but no coldstart
make_host runtime coreall
make_host \
  opt-core \
  ocaml \
  ocamlc.opt \
  ocamlopt.opt \
  otherlibraries \
  ocamldebugger \
  ocamllex.opt \
  ocamltoolsopt \
  ocamltoolsopt.opt

rm $(find | grep -e '\.cm.$')
make_target -C stdlib all allopt
make_target ocaml ocamlc ocamlopt
make_target otherlibraries otherlibrariesopt ocamltoolsopt
make_target \
  driver/main.cmx \
  driver/optmain.cmx \
  compilerlibs/ocamlcommon.cmxa \
  compilerlibs/ocamlbytecomp.cmxa \
  compilerlibs/ocamloptcomp.cmxa

## Install

make_host install
make_host -C debugger install
