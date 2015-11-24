class Attachment::AdministrationAttachment < Attachment
  def self.sti_name
    'Yllapito'
  end

  def self.logo
    where(kayttotarkoitus: "yhtion_parametrit.logo").first
  end
end
