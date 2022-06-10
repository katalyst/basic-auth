# frozen_string_literal: true

RSpec.describe Katalyst::Basic::Auth::Middleware do # rubocop:disable Metrics/BlockLength
  subject { middleware }

  let(:middleware) { described_class.new(app) }
  let(:app) do
    app = Object.new
    app.define_singleton_method(:call) {}
    app
  end
  let(:basic_auth) do
    app = Object.new
    app.define_singleton_method(:call) {}
    app
  end
  let(:env) { { "PATH_INFO" => request_path, "REMOTE_ADDR" => request_ip } }
  let(:request_path) { "/" }
  let(:request_ip) { "127.0.0.1" }

  before do
    allow(app).to receive(:call)
    allow(basic_auth).to receive(:call)
    allow(Rack::Auth::Basic).to receive(:new).and_return(basic_auth)
  end

  around(:each) do |example|
    Katalyst::Basic::Auth::Config.add(path: "/", enabled: true, username: "test", password: "test")
    Katalyst::Basic::Auth::Config.add(path: "/no_auth", enabled: false)
    Katalyst::Basic::Auth::Config.add(path: "/test_path", ip_allowlist: ["192.168.1.0/24"])
    example.run
    Katalyst::Basic::Auth::Config.reset!
  end

  context "with a basic auth protected path" do
    let(:request_path) { "/path" }

    before { middleware.call(env) }

    it { expect(app).not_to have_received(:call) }
    it { expect(basic_auth).to have_received(:call) }
  end

  context "with an excluded path" do
    let(:request_path) { "/no_auth/path" }

    before { middleware.call(env) }

    it { expect(app).to have_received(:call) }
    it { expect(basic_auth).not_to have_received(:call) }
  end

  context "with a request from a allowlisted IP address" do
    let(:request_path) { "/test_path/path" }
    let(:request_ip) { "192.168.1.1" }

    before { middleware.call(env) }

    it { expect(app).to have_received(:call) }
    it { expect(basic_auth).not_to have_received(:call) }
  end
end
