class CreaterepoC < Formula
  desc "C implementation of createrepo, builds RPM repository metadata"
  homepage "https://github.com/ThomasPi0/createrepo_c"
  url "https://github.com/ThomasPi0/createrepo_c/archive/refs/tags/2.0.0.tar.gz"
  sha256 "f4cf852c3bf1753c2f38748683438398c8e4dd16b3e5f2965894b9f2507fddc6"
  license "GPL-2.0-or-later"
  head "https://github.com/ThomasPi0/createrepo_c.git", branch: "master"

  bottle do
    root_url "https://github.com/ThomasPi0/createrepo_c/releases/download/2.0.0"
    sha256 cellar: :any, arm64_sequoia: "e00a33f4db7acdf181d2effe685a6d983e36e2aa5c217ab02acbc064aab5ac3e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "glib"
  depends_on "openssl@3"
  depends_on "rpm"
  depends_on "sqlite"
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def install
    # zchunk and libmodulemd are not packaged in Homebrew; Python bindings ship via PyPI.
    system "cmake", "-S", ".", "-B", "build",
           "-DCMAKE_INSTALL_RPATH=#{rpath}",
           "-DENABLE_PYTHON=OFF",
           "-DWITH_ZCHUNK=OFF",
           "-DWITH_LIBMODULEMD=OFF",
           "-DBUILD_DOC_C=OFF",
           "-DENABLE_BASHCOMP=OFF",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"createrepo_c", testpath
    assert_path_exists testpath/"repodata/repomd.xml"
  end
end
