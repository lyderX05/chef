#
# Author:: Ryan Davis (<ryand-ruby@zenspider.com>)
# Author:: Daniel DeLeo (<dan@chef.io>)
# Author:: Nuo Yan (<nuo@chef.io>)
# Copyright:: Copyright 2011-2016, Ryan Davis and Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require_relative "../knife"

class Chef
  class Knife
    class TagDelete < Knife

      deps do
        require_relative "../node"
      end

      banner "knife tag delete NODE TAG ..."

      def run
        name = @name_args[0]
        tags = @name_args[1..]

        if name.nil? || tags.nil? || tags.empty?
          show_usage
          ui.fatal("You must specify a node name and at least one tag.")
          exit 1
        end

        node = Chef::Node.load name
        deleted_tags = []
        tags.each do |tag|
          unless node.tags.delete(tag).nil?
            deleted_tags << tag
          end
        end
        node.save
        message = if deleted_tags.empty?
                    "Nothing has changed. The tags requested to be deleted do not exist."
                  else
                    "Deleted tags #{deleted_tags.join(", ")} for node #{name}."
                  end
        ui.info(message)
      end
    end
  end
end
