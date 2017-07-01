class Widget < ActiveRecord::Base
  validates :title, :section_name, :position, :ad_code, presence: true
  validates :position, uniqueness: {scope: :section_name, message: "position already occupied"}

  def self.page_values
    [["Yes", true], ["No", false]]
  end

  def self.sections
    # [['Header', 'header'], ['Body', 'body'], ['Footer', 'footer']]
    {'Header' => 'header', 'Body' =>'body', 'Footer' => 'footer'}
  end

  def self.positions
    [['First','first'],['Second','second'],['Third','third'],['Fourth','fourth'], ['Fifth', 'fifth']]
  end
end
