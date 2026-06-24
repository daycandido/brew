# frozen_string_literal: true

require "utils/curl"

RSpec.describe "Utils::Curl" do
  include Utils::Curl

  describe "::curl_args" do
    let(:args) { ["foo"] }

    context "when curl version is sufficient" do
      before do
        allow(self).to receive(:curl_version).and_return(Version.new("7.20.0"))
      end

      it "adds --proto-redir restriction" do
        expect(curl_args(*args).join(" ")).to include("--proto-redir -all,https,http,ftp,ftps")
      end
    end

    context "when curl version is insufficient" do
      before do
        allow(self).to receive(:curl_version).and_return(Version.new("7.19.0"))
      end

      it "does not add --proto-redir restriction" do
        expect(curl_args(*args).join(" ")).not_to include("--proto-redir")
      end
    end

    context "when checking version" do
      it "does not add --proto-redir restriction to avoid recursion" do
        expect(curl_args("-V").join(" ")).not_to include("--proto-redir")
      end
    end
  end
end
