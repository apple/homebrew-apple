# Copyright (C) 2023 Apple, Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the “Software”), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
# 
# THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

class GamePortingToolkitCompiler < Formula
  desc "Compiler for Apple Game Porting Toolkit"
  homepage "https://developer.apple.com/"
  url "https://media.codeweavers.com/pub/crossover/source/crossover-sources-22.1.1.tar.gz", using: :nounzip
  sha256 "cdfe282ce33788bd4f969c8bfb1d3e2de060eb6c296fa1c3cdf4e4690b8b1831"
  version "22.1.1"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  keg_only :provided_by_macos

  def install
    # Extract the required clang files from the tarball
    system "tar", "-xf", "crossover-sources-#{version}.tar.gz", "--include=sources/clang/*", "--strip-components=2"

    # Build an x86_64-native clang
    mkdir "clang-build" do
      args = std_cmake_args + %W[
        -G Ninja
        -DCMAKE_BUILD_TYPE=Release
        -DCMAKE_OSX_ARCHITECTURES=x86_64
        -DLLVM_TARGETS_TO_BUILD=X86
        -DLLVM_NATIVE_ARCH=X86
        -DLLVM_HOST_TRIPLE=x86_64-apple-darwin
        -DLLVM_INSTALL_TOOLCHAIN_ONLY=On
        -DLLVM_ENABLE_PROJECTS=clang
      ]
      system "cmake", *args, buildpath/"sources/clang"
      system "ninja", "install"
    end

    # Create a symlink for compatibility with Wine
    bin.install_symlink "clang" => "gcc"
  end

  test do
    # Add test code here if applicable
    system "false"
  end
end


