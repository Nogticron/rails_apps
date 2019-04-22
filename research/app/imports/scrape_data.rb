class ScrapeData
  def self.get
    CsvImport.get
    ScrapeEvents.get
  end
end