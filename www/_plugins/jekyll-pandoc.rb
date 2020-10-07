require "jekyll"
require "pandoc-ruby"

class Jekyll::Converters::Markdown::PandocProcessor
    def initialize(config)
        @config = config
    end
    def convert(content)
        acropat = /\\acrodef\{(.*?)\}\{(.*?)\}/
        acros = content.scan(acropat)
        acros.each do |acro|
            pat = /\\acp?\{(#{acro[0]})\}/
            content = content.sub(pat){|r| "#{acro[1]}" + (r[3] == "p" ? "s" : "") + " (<span class='abbr'>#{r[$1]}" + (r[3] == "p" ? "s" : "") + "</span>)"}
            pat = /\\acs?p?\{(#{acro[0]})\}/
            content = content.gsub(pat){|r| "<abbr title='#{acro[1]}'>#{r[$1]}" + (r[3] == "p" || r[4] == "p" ? "s" : "") + "</abbr>"}
        end

        @converter = PandocRuby.new(
            content,
            :from => :"markdown"
        )
        @converter.to_html(
            :mathjax,
            :N,
            {
                :bibliography => :"_includes/references.bib",
                :csl => :"_includes/bibstyle.csl",
                :"default-image-extension" => :"png"
            },
            "-F pandoc-crossref -F pandoc-citeproc",
            "-M link-citations=true -M linkReferences=true -M figPrefix=Figure -M eqnPrefix=Equation -M tblPrefix=Table -M lstPrefix=List -M secPrefix=Section"
        )
    end
end

module Jekyll
  module PandocFilter
    def pandoc(input)
      PandocRuby.convert(input, :from => "markdown", :to => "html", :mathjax)
    end
  end
end

Liquid::Template.register_filter(Jekyll::PandocFilter)
