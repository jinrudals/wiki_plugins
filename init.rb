require_dependency 'wiki_page'

unless WikiPage.included_modules.include?(WikiPlugins::WikiPagePatch)
  WikiPage.send(:include, WikiPlugins::WikiPagePatch)
end

$LOAD_PATH.unshift "#{File.dirname(__FILE__)}/lib"
Dir::foreach(File.join(File.dirname(__FILE__), 'lib')) do |file|
  next unless /\.rb$/ =~ file
  require file
end


Redmine::Plugin.register :wiki_plugins do
  name 'Wiki Plugins plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'
end
