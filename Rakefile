require 'dotenv'
Dotenv.load!

module EWSDistribution
  class << self
    def project_path
      File.dirname(__FILE__)
    end

    def build_output_path
      File.join(project_path, "DistributionBuild")
    end

    def ipa_path
      File.join(build_output_path, "IPABinaries")
    end

    def provision_path
      File.join(project_path, "MobileProvisions")
    end

    def commit_sha
      `git rev-parse HEAD`.strip
    end

    def workspace
      Dir['*.xcworkspace'].first
    end

    def production_scheme
      File.basename(workspace, ".xcworkspace")
    end

    def ipa_filename(version)
      "#{production_scheme} #{version}.ipa"
    end

    def codes_signing_id
      "iPhone Distribution: Jooyoung Chae"
    end

    def app_binary
      "#{production_scheme}.app"
    end

    def ad_hoc_mobileprovision
      "#{provision_path}/AdHoc_APNSEWS.mobileprovision" 
    end
  end
end

desc "Build the scheme for Ad Hoc distribution"
task :build, [:sdk, :config] do |task, args|
  args.with_defaults(sdk: "7.0", config: "Ad Hoc")
  sh "xcodebuild -workspace #{EWSDistribution.workspace} "\
      "-sdk iphoneos#{args.sdk} "\
      "-scheme #{EWSDistribution.production_scheme} "\
      "-configuration '#{args.config}' "\
      "ARCHS='armv7 armv7s' ONLY_ACTIVE_ARCH=NO. "\
      "CONFIGURATION_BUILD_DIR=#{EWSDistribution.build_output_path}"
end

desc "Package the build output to an IPA"
task :archive, [:version] => [:build] do |t, args|
  args.with_defaults(version: "v1.0.3") 
  sh "/usr/bin/xcrun -sdk iphoneos PackageApplication "\
      "-v '#{EWSDistribution.build_output_path}/#{EWSDistribution.app_binary}' "\
      "-o '#{EWSDistribution.ipa_path}/#{EWSDistribution.ipa_filename("1.0.0")}' "\
      "--sign '#{EWSDistribution.codes_signing_id}' "\
      "--embed '#{EWSDistribution.ad_hoc_mobileprovision}' OUTPUT_DIR=#{EWSDistribution.ipa_path}"
end
 
namespace :distribute do
  desc "distribute to TestFlight"
  task :flight do
    sh "curl http://testflightapp.com/api/builds.json "\
        "-F file=@'#{EWSDistribution.ipa_path}/#{EWSDistribution.ipa_filename("1.0.0")}' "\
        "-F api_token='#{ENV['TEST_FLIGHT_API_TOKEN']}' "\
        "-F team_token='#{ENV['TEST_FLIGHT_TEAM_TOKEN']}' "\
        "-F notes='#{EWSDistribution.commit_sha}' -F notify=False "
  end
end

