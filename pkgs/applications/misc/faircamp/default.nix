{ lib
, rustPlatform
, fetchgit
, makeWrapper
, ffmpeg
, callPackage
, unstableGitUpdater
}:

rustPlatform.buildRustPackage {
  pname = "faircamp";
  version = "unstable-2022-01-19";

  # TODO when switching to a stable release, use fetchFromGitea and add a
  # version test. Meanwhile, fetchgit is used to make unstableGitUpdater work.
  src = fetchgit {
    url = "https://codeberg.org/simonrepp/faircamp.git";
    rev = "f8ffc7a35a12251b83966b35c63f72b4912f75a9";
    sha256 = "sha256-9t42+813IPLUChbLkcwzoCr7FXSL1g+ZG6I3d+7pmec=";
  };

  cargoHash = "sha256-24ALBede3W8rjlBRdtL0aazRyK1RmNLdHF/bt5i4S5Y=";

  nativeBuildInputs = [
    makeWrapper
  ];

  postInstall = ''
    wrapProgram $out/bin/faircamp \
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
  '';

  passthru.tests.wav = callPackage ./test-wav.nix { };

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A self-hostable, statically generated bandcamp alternative";
    longDescription = ''
      Faircamp takes a directory on your disk - your Catalog - and from it
      produces a fancy-looking (and technically simple and completely static)
      website, which presents your music in a way similar to how popular
      commercial service bandcamp does it.

      You can upload the files faircamp generates to any webspace - no database
      and no programming language support (PHP or such) is required. If your
      webspace supports SSH access, faircamp can be configured to upload your
      website for you automatically, otherwise you can use FTP or whichever
      means you prefer to do that manually.
    '';
    homepage = "https://codeberg.org/simonrepp/faircamp";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}
