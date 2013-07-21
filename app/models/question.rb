class Question < ActiveRecord::Base
  default_scope :include => :options
  attr_accessible :created_by, :description, :qtype, :options_attributes
  has_many :options
  validates :description, :presence => true, :uniqueness => true
  validates :qtype, :presence => true
  accepts_nested_attributes_for :options, :allow_destroy => true, :reject_if => proc { |option| option['content'].blank? }
  validate :options_duplicated?, :answer_picked?
  
  def type?(type)
    if qtype.nil? && type == 'text'
      true
    else
      qtype == type
    end
  end
  def answers
    # Option.where('selected = ? AND question_id = ?', true, id)
    options.where('selected = true')
  end
  def check_answer(answers)
    self.answers == answers 
  end
  private
  def answer_picked?
    if type?('multi-select')
      errors.add(:answer, "at least 1 choosen") if !options.any? { |option| option.selected }
    else
      errors.add(:answer, "needs to be choosen") if options.select{|o| o.selected?}.size != 1
    end
  end
  def options_duplicated?
    errors.add(:options, "has duplicate options") if options.size > options.map(&:content).uniq.size
  end
end
