require "spec_helper"

describe "pipeline" do
  let(:cluster) { "live-1.cloud-platform.service.justice.gov.uk" }
  let(:success) { double(success?: true) }
  let(:failure) { double(success?: false) }

  context "set_kube_context" do
  end

  context "apply_cluster_level_resources" do
  end

  context "all_namespace_dirs" do
  end

  context "apply_namespace_dir" do
  end

  context "changed_namespace_dirs" do
    let(:cmd) { "git diff --no-commit-id --name-only -r HEAD~1..HEAD" }

    let(:files) {
      "bin/namespace-reporter.rb
namespaces/#{cluster}/court-probation-preprod/resources/dynamodb.tf
namespaces/#{cluster}/offender-management-staging/resources/elasticache.tf
namespaces/#{cluster}/licences-prod/07-certificates.yaml
namespaces/#{cluster}/pecs-move-platform-backend-staging/00-namespace.yaml
namespaces/#{cluster}/offender-management-preprod/resources/elasticache.tf
namespaces/#{cluster}/poornima-dev/resources/elasticsearch.tf"
    }

    let(:namespace_dirs) { [
      "namespaces/#{cluster}/court-probation-preprod",
      "namespaces/#{cluster}/licences-prod",
      "namespaces/#{cluster}/offender-management-preprod",
      "namespaces/#{cluster}/offender-management-staging",
      "namespaces/#{cluster}/pecs-move-platform-backend-staging",
      "namespaces/#{cluster}/poornima-dev",
    ] }


    it "gets dirs from latest commit" do
      expect(Open3).to receive(:capture3).with(cmd).and_return([files, "", success])
      allow($stdout).to receive(:puts).with("\e[34mexecuting: #{cmd}\e[0m")
      allow($stdout).to receive(:puts).with("")
      allow($stdout).to receive(:puts).with(files)

      expect(changed_namespace_dirs(cluster)).to eq(namespace_dirs)
    end
  end

  context "execute" do
    let(:cmd) { "ls" }

    it "executes and returns status" do
      expect(Open3).to receive(:capture3).with(cmd).and_return(["", "", success])
      allow($stdout).to receive(:puts).with("\e[34mexecuting: #{cmd}\e[0m")
      allow($stdout).to receive(:puts).with("")

      execute(cmd)
    end

    it "logs" do
      allow(Open3).to receive(:capture3).with(cmd).and_return(["", "", success])
      expect($stdout).to receive(:puts).with("\e[34mexecuting: #{cmd}\e[0m")
      expect($stdout).to receive(:puts).with("")

      execute(cmd)
    end

    context "on failure" do

      it "raises an error" do
        allow(Open3).to receive(:capture3).with(cmd).and_return(["", "", failure])
        expect($stdout).to receive(:puts).with("\e[34mexecuting: #{cmd}\e[0m")
        expect($stdout).to receive(:puts).with("\e[31mCommand: #{cmd} failed.\e[0m")
        expect($stdout).to receive(:puts).with("")

        expect {
          execute(cmd)
        }.to raise_error(RuntimeError)
      end

      it "does not raise if can_fail is set" do
        allow(Open3).to receive(:capture3).with(cmd).and_return(["", "", failure])
        expect($stdout).to receive(:puts).with("\e[34mexecuting: #{cmd}\e[0m")
        expect($stdout).to receive(:puts).with("")
        expect {
          execute(cmd, can_fail: true)
        }.to_not raise_error
      end
    end
  end

  context "log" do
    context "green" do
      let(:colour) { "green" }
      let(:message) { "green message" }

      specify {
        expect($stdout).to receive(:puts).with("\e[32m#{message}\e[0m")
        log(colour, message)
      }
    end

    context "blue" do
      let(:colour) { "blue" }
      let(:message) { "blue message" }

      specify {
        expect($stdout).to receive(:puts).with("\e[34m#{message}\e[0m")
        log(colour, message)
      }
    end

    context "red" do
      let(:colour) { "red" }
      let(:message) { "red message" }

      specify {
        expect($stdout).to receive(:puts).with("\e[31m#{message}\e[0m")
        log(colour, message)
      }
    end

    context "unknown colour" do
      let(:colour) { "puce" }
      let(:message) { "wibble" }

      specify {
        expect {
          log(colour, message)
        }.to raise_error(RuntimeError, "Unknown colour puce passed to 'log' method")
      }
    end

  end
end
