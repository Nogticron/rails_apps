class ImportData
  def self.get
    CsvImport.get
    ScrapeEvents.get
    ScrapeWeather.get
  end
end