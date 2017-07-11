module Fastlane
  module Actions
    module SharedValues
      CC_REMOVE_EXIST_TAG_CUSTOM_VALUE = :CC_REMOVE_EXIST_TAG_CUSTOM_VALUE
    end

    class CcRemoveExistTagAction < Action
      def self.run(params) # action 真正的执行逻辑
        UI.message "Parameter API Token: #{params[:tag]}"

        t = params[:tag] #取出传递的参数 , 下面无外界传递就使用默认值

        cmd = [] #数组定义
        cmd << ["git tag -d #{t}"] if params[:isLocal]
        cmd << ["git push origin :#{t}"] if params[:isRemote]

        UI.message " Ready to remove tag #{t} .👌"
        Actions.sh(cmd.join(" & ")) #脚本执行 , 必须是字符串
      end

      def self.description # action 的描述
        "删除已经存在的 tag"
      end

      def self.details # action 具体描述 (详情描述)
        [
          "根据 传入的 tag 值 , 删除已经存在的 tag",
          "例如 cc_remove_exist_tag(tag:0.1.0)"
        ].join("\n")
        
      end

      def self.available_options #定义参数
        [
          FastlaneCore::ConfigItem.new(key: :tag,
                                       env_name:"FL_CC_REMOVE_EXIST_TAG_TAG",
                                       description: "需要删除的 tag", 
                                       is_string:true,
                                       optional:false,
                                       verify_block: proc do |value|
                                          UI.user_error!("No tag given, pass using `tag: 'token'`") unless (value and not value.empty?)
                                          # UI.user_error!("Couldn't find file at path '#{value}'") unless File.exist?(value)
                                       end),
          FastlaneCore::ConfigItem.new(key: :isLocal,
                                        env_name:"FL_CC_REMOVE_EXIST_TAG_IS_LOCAL",
                                        description:"是否删除本地标签",
                                        default_value:true,
                                        optional:true),
          FastlaneCore::ConfigItem.new(key: :isRemote,
                                        env_name:"FL_CC_REMOVE_EXIST_TAG_IS_REMOTE",
                                        description:"是否删除远程标签",
                                        default_value:true,
                                        optional:true)
        ]
      end

      def self.example_code
        [
          # for simple use
          'cc_remove_exist_tag(
            tag:"0.1.0"
          )',
          # for more infomation
          'cc_remove_exist_tag(
            tag: "0.1.0",
            isLocal: true, #optional
            isRemote: true #optional
          )'
        ]
      end

      def self.authors 
        ["https://github.com/VArbiter"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end

      def self.category
        :source_control
      end

    end
  end
end
