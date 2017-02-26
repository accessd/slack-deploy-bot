require 'open3'

module SlackDeployBot
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
        @output_to = if ENV['ENV'] == 'test'
                       File::NULL
                     else
                       STDOUT
                     end
      end

      def branch_exists?(branch)
        `cd #{base_path}; git ls-remote --heads origin #{branch}`.present?
      end

      def sync_branch(branch)
        checkout(branch) && system("cd #{base_path}; git reset --hard origin/#{branch}", out: @output_to)
      end

      def fetch_branches
        system "cd #{base_path}; git fetch --all", out: @output_to
      end

      def checkout(branch)
        system "cd #{base_path}; git checkout #{branch}", out: @output_to
      end

      def changelog(branch, against:)
        `cd #{base_path} ; git log --no-merges --pretty=format:'%s (%an)' #{against}..#{branch} | cat`
      end

      def update_branch(branch, against:)
        result = checkout(branch) && system("cd #{base_path}; git merge --no-ff --quiet #{against} && git push origin #{branch}", out: @output_to)
        system("cd #{base_path}; git reset --hard HEAD", out: @output_to) unless result
        result
      end
    end
  end
end
