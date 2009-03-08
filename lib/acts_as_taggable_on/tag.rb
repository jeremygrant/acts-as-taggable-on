class Tag < ActiveRecord::Base
  has_many :taggings
  
  validates_presence_of :name
  validates_uniqueness_of :name

  before_destroy :stop_destroy_if_check_for_contains_taggings

  # case-insensitive like used
  def self.find_or_create_with_like_by_name(name)
    find(:first, :conditions => ["name LIKE ?", name]) || create(:name => name)
  end
  
  def ==(object)
    super || (object.is_a?(Tag) && name == object.name)
  end
  
  def to_s
    name
  end
  
  def count
    read_attribute(:count).to_i
  end
  
  @@check_for_option_keys = [:context, :contexts, :taggable_type, :taggable_types]
  
  def check_for(options = {})
    @check_for_options = options.reject{ |key, value| ! @@check_for_option_keys.include?(key) }
    @check_for = true
    self
  end

private
  def stop_destroy_if_check_for_contains_taggings
    taggings = self.taggings
    @check_for_options.each_pair do |key, value| 
      taggings = taggings.send("for_#{key}", value) if @@check_for_option_keys.include? key
    end
    check_for_taggings_count = taggings.count
    if @check_for && check_for_taggings_count > 0
      errors.add(:taggings, "Failed to delete tag #{self.name}. You need to remove the items associated to it before you can delete it")
      false
    end
  end
end
