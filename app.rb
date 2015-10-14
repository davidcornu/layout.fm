class App < Sinatra::Base
  get '/' do
    erb :home, locals: { episodes: episodes }
  end

  get '/episodes/:number' do
    file_path = Dir["**/#{params[:number]}.md"][0]
    redirect '/' unless file_path != ''
    episode = Page.new(file_path)
    erb :episode, locals: { episode: episode }
  end

  get '/rss' do
    builder :rss
  end

  def episodes
    episodes = Dir["episodes/*"].map do |file_path|
      Page.new(file_path)
    end
    episodes.sort! {|a, b| b.data['date'] <=> a.data['date']}
  end
end

class Page
  attr_reader :data, :body, :title, :url

  def initialize(file_path)
    file = File.new(file_path).read
    @data = YAML.load_file(file_path)
    @data['date'] = DateTime.parse @data['date']
    @data['number'] = File.basename(file_path, '.md')
    @title = "#{@data['number']}: #{@data['title']}"
    @body = render file.sub(/---[\s\S]*?---/, '')
    @url = "http://127.0.0.1:9393/episodes/#{@data['number']}"
  end

  def render(content)
    markdown = Redcarpet::Markdown.new(MarkdownRenderer, highlight: true, footnotes: true)
    markdown.render(content)
  end
end

class MarkdownRenderer < Redcarpet::Render::HTML
  include Redcarpet::Render::SmartyPants
end
