xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0", "xmlns:content"=> "http://purl.org/rss/1.0/modules/content/", "xmlns:atom" => "http://www.w3.org/2005/Atom" do
  xml.channel do
    xml.title @site || "USA.gov Family of sites"
    xml.description "Part of the USA.gov family of sites, the front page of the United States Government"
    xml.tag!("atom:link", "href"=> request.original_url, "rel" => "self", :type => "application/rss+xml")
    xml.link request.original_url

    for result in @results
      xml.item do
        xml.title result.page_title || "No Title"
        xml.description result.description
        xml.pubDate result.most_recent_update.try(:to_formatted_s,:rfc822)
        xml.tag!("content:encoded") do
          xml.cdata!(CGI.unescapeHTML(result.full_text_assets_content.force_encoding("UTF-8")))
        end
        xml.link result.full_url
        xml.guid result.full_url
      end
    end
  end
end