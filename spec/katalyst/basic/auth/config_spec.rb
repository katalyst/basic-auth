# frozen_string_literal: true

RSpec.describe Katalyst::Basic::Auth::Config do # rubocop:disable Metrics/BlockLength
  subject(:config) { described_class.new }

  let(:all_env_settings) do
    %w[
      KATALYST_BASIC_AUTH_ENABLED
      KATALYST_BASIC_AUTH_USER
      KATALYST_BASIC_AUTH_PASS
      KATALYST_BASIC_AUTH_IP_ALLOWLIST
    ]
  end

  def with_environment(name, value)
    orig      = ENV.fetch(name, nil)
    ENV[name] = value
    yield
    ENV[name] = orig
  end

  it "sets username from environment" do
    with_environment("KATALYST_BASIC_AUTH_USER", "user") do
      expect(config.username).to eq "user"
    end
  end

  it "sets password from environment" do
    with_environment("KATALYST_BASIC_AUTH_PASS", "pass") do
      expect(config.password).to eq "pass"
    end
  end

  it "sets IP allowlist from the environment" do
    with_environment("KATALYST_BASIC_AUTH_IP_ALLOWLIST", "192.168.1.0/24") do
      expect(config.ip_allowlist).to eq([IPAddr.new("192.168.1.0/24")])
    end
  end

  it "can be enabled from the environment" do
    with_environment("KATALYST_BASIC_AUTH_ENABLED", "true") do
      expect(config).to be_enabled
    end
  end

  it "can be disabled from the environment" do
    with_environment("KATALYST_BASIC_AUTH_ENABLED", "false") do
      expect(config).not_to be_enabled
    end
  end

  context "with a rails environment" do
    before do
      stub_const("Rails", DummyRails)
    end

    it "is disabled in development" do
      expect(config).not_to be_enabled
    end

    it "is enabled in staging" do
      DummyRails.env = "staging"
      expect(config).to be_enabled
    end

    it "is enabled in uat" do
      DummyRails.env = "uat"
      expect(config).to be_enabled
    end

    it "is disabled in production" do
      DummyRails.env = "production"
      expect(config).not_to be_enabled
    end
  end

  context "with default settings" do
    around do |example|
      orig_env = ENV.to_h.dup
      all_env_settings.each { |i| ENV.delete(i) }
      example.run
      all_env_settings.each { |i| ENV[i] = orig_env[i] }
    end

    it "has a default user name" do
      expect(config.username).to eq "katalyst"
    end

    it "has a default password" do
      expect(config.password).to eq "68ccde95e7b6267c"
    end

    it "has an empty IP allowlist" do
      expect(config.ip_allowlist).to eq []
    end

    it "is not enabled" do
      expect(config).not_to be_enabled
    end
  end

  describe "#description" do
    it "describes basic auth configuration" do
      expect(described_class.description).to be_a(String)
    end
  end

  describe "allow_ip?" do
    subject(:config) { described_class.new(ip_allowlist: [ip_allowlist]) }

    let(:ip_allowlist) { "192.168.1.0/24" }
    let(:remote_ip_header) { "REMOTE_ADDR" }

    it { expect(config).to be_allow_ip({ remote_ip_header => "192.168.1.1" }) }
    it { expect(config).not_to be_allow_ip({ remote_ip_header => "10.0.1.1" }) }
  end

  describe "#for_path" do
    let!(:config_a) { described_class.add(path: "/path_a", username: "user_a") }
    let!(:config_b) { described_class.add(path: "/path_b", username: "user_b") }

    it "matches path a" do
      expect(described_class.for_path("/path_a/foo/bar.html")).to eq(config_a)
    end

    it "matches path b" do
      expect(described_class.for_path("/path_b/foo/bar.html")).to eq(config_b)
    end

    it "matches the global config" do
      expect(described_class.for_path("/path_c/foo/bar.html")).to eq(described_class.global)
    end
  end
end
