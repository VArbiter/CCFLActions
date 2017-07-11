module Fastlane
  module Actions
    module SharedValues
      CC_FETCH_REPO_CUSTOM_VALUE = :CC_FETCH_REPO_CUSTOM_VALUE
    end

    class CcFetchRepoAction < Action
      def self.run(params)
        UI.message "fetcheing repo info..."

        # 如果存在多个 repo , 将返回第一个

        if params[:repo]
          
          r = params[:repo]
          UI.message "#{r}"
        else

          cmd = "pod repo"
          r = Actions.sh(cmd)
          a = r.split(" ")
          l = a.length - 1  
          for i in 0..l do  
            s = a[i]
            if (s.include? "http://") || (s.include? "https://")
              r = s
              break;
            end
          end
          UI.message "repo 为 : #{r}"
        end

        return r

      end

      def self.description
        "自动获得 git 仓库 的 repo"
      end

      def self.details
        ["自动获得仓库的 repo",
          "如果传入了 repo , 将不做检测 , 直接返回",
        "例如 cc_fetch_repo"].join("\n")
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :repo,
                                       env_name:"FL_CC_FETCH_REPO_T",
                                       description: " 判断是否 有 repo ", 
                                       is_string:true,
                                       optional:true),
        ]
      end

      def self.return_value
        "repo 的地址"
      end

      def self.authors
        ["https://github.com/VArbiter"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.example_code
        [
          'repo = cc_fetch_repo',
          'repo = cc_fetch_repo(repo:https://EXAMPLE)'
        ].join("\n")
      end

      def self.category
        :source_control
      end

    end
  end
end
