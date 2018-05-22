RSpec.describe "AWS Basic" do
  let(:config) do
    Config.new("nodePools" => [{ "count" => 2, "name" => "master" },
                               { "count" => 3, "name" => "etcd" },
                               { "count" => 2, "name" => "worker" }],
               "master" => { "nodePools" => ["master"] },
               "worker" => { "nodePools" => ["worker"] },
               "etcd" => { "nodePools" => ["etcd"] },
               "networking" => { "podCIDR" => "10.2.0.0/16",
                                 "serviceCIDR" => "10.3.0.0/16" },
               "baseDomain" => "tectonic-ci.de",
               "aws" => { "region" => "eu-central-1" })
  end

  it "test" do
    cluster = config.init
    cluster.install
    cluster.destroy

    expect(true).to equal(true)
  end

  it "test2" do
    cluster = config.init
    cluster.install do
      expect(true).to equal(true)
    end
  end
end
