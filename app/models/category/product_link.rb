class Category::ProductLink < Category::Link
  belongs_to :product, class_name: '::Product', foreign_key: :liitos, primary_key: :tuoteno

  before_save :defaults

  def self.sti_name
    'tuote'
  end

  private

    def defaults
      self.kutsuja ||= ''
    end
end
