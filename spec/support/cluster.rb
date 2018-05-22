require "open3"
require "yaml"

class Cluster
  Error = Class.new(StandardError)

  attr_reader :cluster_name

  def initialize(config_path, *args)
    config = YAML.load_file(config_path)
    @cluster_name = config.fetch("name")

    run(:init, "--config=#{config_path}", *args)
  end

  def destroy(*args)
    run_cluster_command(:destroy, *args)
  end

  def install(*args)
    run_cluster_command(:install, *args)

    if block_given?
      begin
        yield
      ensure
        destroy
      end
    end
  end

  private

  def run(*args)
    cmd = "#{File.join("installer", "tectonic")} #{args.join(" ")}"
    puts cmd.inspect if ENV.key?("DEBUG")
    Open3.popen2e(cmd) do |_, stdout_stderr, wait_thr|
      Thread.new { stdout_stderr.each {|line| puts line } } if ENV.key?("DEBUG")
      raise Error, "#{stdout_stderr}" unless exit_status = wait_thr.value.success?
    end
  end

  def run_cluster_command(action, *args)
    run(action, "--dir=#{cluster_name}", *args)
  end
end
