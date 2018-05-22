require "open3"

module Bazel
  class Tarball
    def initialize(path)
      @path = path
    end

    def untar(dir)
      stdout, stderr, status = Open3.capture3("tar -zxf #{@path} -C #{dir}")
      unless status.success?
        STDOUT.puts(stdout)
        STDERR.puts(stderr)

        exit(1)
      end
    end
  end

  module_function

  def build(target)
    case target
    when :tarball
      stdout, stderr, status = Open3.capture3("bazel build #{target}")
      unless status.success?
        STDOUT.puts(stdout)
        STDERR.puts(stderr)

        exit(1)
      end

      Tarball.new("bazel-bin/tectonic-dev.tar.gz")
    else
      raise "target not supported"
    end
  end
end
