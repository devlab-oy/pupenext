class PackageKeyword < Keyword

  default_scope where(:laji => 'PAKKAUSKV')

  validates :selitetark, presence: true
end
