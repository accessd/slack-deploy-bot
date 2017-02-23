require 'open3'

module Utils
  class Subprocess
    def initialize(cmd, &block)
      Open3.popen3(cmd) do |stdin, stdout, stderr, thread|
        { :out => stdout, :err => stderr }.each do |key, stream|
          Thread.new do
            until (line = stream.gets).nil? do
              if key == :out
                yield line, nil, thread if block_given?
              else
                yield nil, line, thread if block_given?
              end
            end
          end
        end

        thread.join # don't exit until the external process is done
      end
    end
  end

  class Git
    attr_reader :base_path

    def initialize(base_path)
      @base_path = base_path
    end

    def branch_exists?(branch)
      `cd #{base_path}; git ls-remote --heads origin #{branch}`.present?
    end

    def sync_branch(branch)
      checkout(branch) && system("cd #{base_path}; git reset --hard origin/#{branch}")
    end

    def fetch_branches
      system "cd #{base_path}; git fetch --all"
    end

    def checkout(branch)
      system "cd #{base_path}; git checkout #{branch}"
    end

    def changelog(branch, against:)
      `cd #{base_path} ; git log --no-merges --pretty=format:'%s (%an)' #{against}..#{branch} | cat`
    end

    def update_branch(branch, against:)
      result = checkout(branch) && system("cd #{base_path}; git merge --no-ff --quiet #{against} && git push origin #{branch}")
      system("cd #{base_path}; git reset --hard HEAD") unless result
      result
    end
  end
end

class SlackRubyBot::Client
  include Slack::Web::Api::Mixins::Channels
  include Slack::Web::Api::Endpoints::Channels
  include Slack::Web::Faraday::Connection
  include Slack::Web::Faraday::Request

  def user_agent
  end

  def proxy
  end

  def ca_path
    @ca_path ||= `openssl version -a | grep OPENSSLDIR | awk '{print $2}'|sed -e 's/\"//g'`
  end

  def ca_file
    @ca_file ||= "#{ca_path}/ca-certificates.crt"
  end

  def endpoint
    @endpoint ||= 'https://slack.com/api/'
  end
end
