class ThirdScraping

  def initialize
    mechanize = Mechanize.new
    @page = mechanize.get('http://localhost:3000/works/third_scraping')
  end

  def get_list
    @page.search('.etc div').each do |page|
      puts page.inner_text
    end
  end

end
