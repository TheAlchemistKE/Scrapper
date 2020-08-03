require "nokogiri"
require "httparty"
require "byebug"


class Scrapper
    attr_reader :output, :url
    attr_accessor :input

    def initialize
        @data = []
    end

    def parse_page(url="https://www.brainyquote.com/topics/page-quotes")
        unparsed_page = HTTParty.get(url)
        parsed_page = Nokogiri::HTML(unparsed_page)
        parsed_page
    end

    def scrape_data
        page = parse_page
        quotes_list = page.css('div.m-brick')
        current_page = 1
        quotes_per_page = quotes_list.count
        last_page = 39
        counter = 1
        while current_page <= last_page
            pagination_url = "https://www.brainyquote.com/topics/page-quotes_#{current_page}"
            paginated_page = parse_page(url=pagination_url)
            puts pagination_url
            puts "You're on page #{current_page}"
            paginated_quotes_list = page.css('div.m-brick')
            paginated_quotes_list.each do |quote_item| 
                quote = {
                    quote_number: counter,
                    quote: quote_item.css('a.b-qt').text,
                    quote_author: quote_item.css('a.bq-aut').text
                }
                @data.push(quote)
                counter += 1
            end
            current_page += 1
        end
        output = {
            url: @url,
            number_of_quotes: quotes_list.count,
            data: @data
        }
        output
        byebug
    end

    def convert_to_json
        
    end
end