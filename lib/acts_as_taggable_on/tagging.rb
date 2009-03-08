class Tagging < ActiveRecord::Base #:nodoc:
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
  belongs_to :tagger, :polymorphic => true
  validates_presence_of :context

  named_scope :for_contexts, lambda{ |contexts|
    {:conditions => ["context in (?)", context]}
  }

  named_scope :for_context, lambda{ |context|
    {:conditions => ["context = ?", context]}
  }

  named_scope :for_taggable_types, lambda{ |taggable_types|
    {:conditions => ["taggable_type in (?)", taggable_types.collect { |taggable_type| taggable_type.to_s }]}
  }

  named_scope :for_taggable_type, lambda{ |taggable_type|
    {:conditions => ["taggable_type = ?", taggable_type.to_s]}
  }
end