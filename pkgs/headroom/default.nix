# headroom.ai — https://docs.headroomlabs.ai
#
# Not in nixpkgs and upstream ships no flake, so the `headroom-ai[all]` install
# is pinned in ./uv.lock and turned into derivations by uv2nix. Refresh with
# `make headroom-update`.
{ lib
, callPackage
, runCommand
, python313
, pyproject-nix
, uv2nix
, pyproject-build-systems
}:
let
  workspace = uv2nix.lib.workspace.loadWorkspace { workspaceRoot = ./.; };

  # Prefer binary wheels: torch, onnxruntime and headroom's own _core.abi3.so
  # all publish prebuilt aarch64-darwin wheels, so nothing is compiled here.
  overlay = workspace.mkPyprojectOverlay { sourcePreference = "wheel"; };

  # Everything else in the lock resolves to a wheel; this one is an sdist
  # predating PEP 517 and never declares its setuptools build dependency.
  overrides = final: prev: {
    antlr4-python3-runtime = prev.antlr4-python3-runtime.overrideAttrs (old: {
      nativeBuildInputs =
        (old.nativeBuildInputs or [ ]) ++ final.resolveBuildSystem { setuptools = [ ]; };
    });
  };

  pythonSet =
    (callPackage pyproject-nix.build.packages { python = python313; }).overrideScope
      (lib.composeManyExtensions [
        pyproject-build-systems.overlays.default
        overlay
        overrides
      ]);

  venv = pythonSet.mkVirtualEnv "headroom-env" workspace.deps.default;
in
# Expose only headroom's own entry points. The venv also carries `python` and
# every dependency's scripts, which should not land in the system profile.
runCommand "headroom-${pythonSet.headroom-ai.version}"
  {
    passthru = { inherit venv pythonSet; };
    meta = {
      description = "Context optimization layer for LLM applications";
      homepage = "https://docs.headroomlabs.ai";
      license = lib.licenses.asl20;
      platforms = [ "aarch64-darwin" ];
      mainProgram = "headroom";
    };
  }
  ''
    mkdir -p $out/bin
    for bin in headroom headroom-cache-ttl; do
      ln -s ${venv}/bin/$bin $out/bin/$bin
    done
  ''
