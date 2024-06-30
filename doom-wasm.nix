{ stdenv, writeText, emscripten, ccls, autoconf, automake, gnumake, python3, pkg-config, simple-http-server, SDL2, SDL2_mixer, SDL2_net, bash, binaryen, nodejs-18_x }:

stdenv.mkDerivation {
  name = "doom-wasm";
  src = ./.;
  EM_CONFIG = writeText ".emscripten" ''
    EMSCRIPTEN_ROOT = '${emscripten}/share/emscripten'
    LLVM_ROOT = '${emscripten.llvmEnv}/bin'
    BINARYEN_ROOT = '${binaryen}'
    NODE_JS = '${nodejs-18_x}/bin/node'
    # FIXME: Should use a better place, but needs to be an absolute path.
    CACHE = '/tmp/emscriptencache'
  '';
  buildInputs = [
    # build tools
    bash
    emscripten
    ccls
    autoconf
    automake
    gnumake
    python3
    pkg-config
    simple-http-server
    # libs
    SDL2
    SDL2_mixer
    SDL2_net
    stdenv.cc
  ];
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];
  buildPhase = ''
    ls -hal
    ls -hal scripts
    bash ./scripts/build.sh
  '';
  installPhase = ''
    mkdir -p $out
    cp src/websockets-doom.html $out
    cp src/websockets-doom.js $out
    cp src/websockets-doom.wasm $out
    cp src/websockets-doom.wasm.map $out
  '';

}
