author = "Kevin Clark and Rafael Conde"
artwork = 'http://layout.fm/assets/artwork.jpg'

xml.instruct! :xml, :version => '1.0'
xml.rss "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd", :version => "2.0" do
  xml.channel do
    xml.title "Layout"
    xml.link "http://layout.fm"
    xml.description "Layout is a weekly podcast about design, technology, programming and everything else."
    xml.language 'en'
    xml.pubDate episodes.first.data['date'].rfc822()
    xml.lastBuildDate episodes.first.data['date'].rfc822()
    xml.itunes :author, author
    xml.itunes :keywords, "design, development, tech"
    xml.itunes :explicit, 'no'
    xml.itunes :image, :href => artwork
    xml.itunes :owner do
      xml.itunes :name, 'Kevin Clark'
      xml.itunes :email, 'kevin@kevinclark.ca'
    end
    xml.itunes :category, :text => 'Technology' do
      xml.itunes :category, :text => 'Tech News'
    end

    episodes.each do |episode|
      xml.item do
        xml.title episode.title
        xml.link episode.url
        xml.guid episode.url
        xml.pubDate Time.parse(episode.data['date'].to_s).rfc822()
        xml.descrition do
          xml.cdata!(episode.body)
        end
        xml.itunes :summary, episode.data['description']
        xml.itunes :duration, episode.data['duration']
        xml.enclosure :url => episode.data['audio_url'], :length => episode.data['file_size'], :type => 'audio/mpeg'
        xml.itunes :explicit, 'no'
        xml.itunes :author, author
        xml.itunes :image, :href => artwork
      end
    end
  end
end
