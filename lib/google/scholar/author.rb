require 'nokogiri'
module Google
  module Scholar
    class Author
      #attr_accessor :summary_doc
      def initialize(document)
        @summary_doc = document
      end
      def name
        @name ||= @summary_doc.css(".gsc_oai_name").text.strip
      end
      def citation_count
        @citation_count ||= @summary_doc.css(".gsc_oai_cby").children.reject{|x| !x.text?}.last.text.split(" ").last.to_i
      end
      def author_url
        @author_url ||= "#{Google::Scholar.google_url}#{@summary_doc.css('.gsc_oai_name').children.attr('href').value}&pagesize=100"
      end
      def full_profile
        @full_profile ||= Google::Scholar::Scraper.new(author_url).documents.first
      end
      def citations
        full_profile.css("#stats td.cit-data").first.text.to_i
      end
      def id
        @id ||= @summary_doc.css("td:last a:first").attr("href").to_s.match(/user=(.*)&/)[1]
      end
      def articles
        @articles ||= Google::Scholar::ArticleEnumerator.new(Google::Scholar::Scraper.new(nil,self.full_profile))
      end
    end
  end
end
