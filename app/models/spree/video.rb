module Spree
  class Video < ActiveRecord::Base
    belongs_to :watchable, :polymorphic => true, :touch => true

    # attr_accessor :youtube_ref
    validates_presence_of :youtube_ref
    validates_uniqueness_of :youtube_ref, :scope => [:watchable_id, :watchable_type]

    def youtube_data
      youtube_data = YouTubeIt::Model::Video.new({})
      youtube_data.instance_variable_set(:@unique_id, youtube_ref)
      youtube_data.instance_variable_set(:@thumbnails, [OpenStruct.new(url: "https://i.ytimg.com/vi/#{youtube_ref}/default.jpg")])
      youtube_data
    end

    def youtube_link
      "https://www.youtube.com/watch?v=#{youtube_ref}"
    end

    after_validation do
      youtube_ref.match(/(v=|\/)([\w-]+)(&.+)?$/) { |m| self.youtube_ref = m[2] }
    end
  end
end
