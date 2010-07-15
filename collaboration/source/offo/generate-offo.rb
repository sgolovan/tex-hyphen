#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# this file generates FOP XML Hyphenation Patterns

# use 'gem install unicode' if unicode is missing on your computer
# require 'jcode'
# require 'rubygems'
# require 'unicode'

# this script
# collaboration/source/offo
$path_to_top = '../../..'

# languages.rb
# hyph-utf8/source/generic/hyph-utf8
$path_lang = 'hyph-utf8/source/generic/hyph-utf8'
load "#{$path_to_top}/#{$path_lang}/languages-txt.rb"

# source patterns
# hyph-utf8/tex/generic/hyph-utf8/patterns/txt
$path_src_pat = 'hyph-utf8/tex/generic/hyph-utf8/patterns/txt'

# XML patterns
# collaboration/repository/offo
$path_offo = "collaboration/repository/offo"

$rel_path_offo = "#{$path_to_top}/#{$path_offo}"
$rel_path_patterns = "#{$path_to_top}/#{$path_src_pat}"

$l = Languages.new($rel_path_patterns)
# TODO: should be singleton
languages = $l.list.sort{|a,b| a.name <=> b.name}

# TODO: we should rewrite this
# not using: eo, el
# todo: mn, no!, sa, sh
# codes = ['bg', 'ca', 'cs', 'cy', 'da', 'de-1901', 'de-1996', 'de-ch-1901', 'en-gb', 'en-us', 'es', 'et', 'eu', 'fi', 'fr', 'ga', 'gl', 'hr', 'hsb', 'hu', 'ia', 'id', 'is', 'it', 'kmr', 'la', 'lt', 'lv', 'nl', 'no', 'pl', 'pt', 'ro', 'ru', 'sk', 'sl', 'sr-cyrl', 'sv', 'tr', 'uk']

language_codes = Hash.new
languages.each do |language|
	language_codes[language.code] = language.code
end
language_codes['de-1901']      = 'de_1901'
language_codes['de-1996']      = 'de'
language_codes['de-ch-1901']   = 'de_CH'
language_codes['el-monoton']   = 'el'
language_codes['el-polyton']   = 'el_Polyton'
language_codes['en-gb']        = 'en_GB'
language_codes['en-us']        = 'en_US'
# hu patterns cause a stack overflow when compiled with FOP
language_codes['hu']           = nil
language_codes['mn-cyrl']      = 'mn'
language_codes['mn-cyrl-x-lmc'] = nil # no such pattern
language_codes['sh-cyrl']      = nil # no such pattern
language_codes['sh-latn']      = nil # no such pattern
language_codes['sr-cyrl']      = 'sr_Cyrl'
language_codes['sr-latn']      = 'sr_Latn'
language_codes['zh-latn']      = 'zh_Latn'

languages.each do |language|
	include_language = language.use_new_loader
	code = language_codes[language.code]
	if code == nil
		include_language = false
	end
	if code == 'en_US'
		include_language = true
	end

	if include_language
		puts "generating #{code}"
	
		$file_offo_pattern = File.open("#{$rel_path_offo}/#{code}.xml", 'w')

        comments_and_licence = language.get_comments_and_licence
        classes    = language.get_classes
		exceptions = language.get_exceptions
		patterns   = language.get_patterns

		# if code == 'nn' or code == 'nb'
		# 	patterns = ""
		# 	patterns = $l['no'].get_patterns
		# end

		$file_offo_pattern.puts '<?xml version="1.0" encoding="utf-8"?>'
		$file_offo_pattern.puts '<hyphenation-info>'
		$file_offo_pattern.puts

        # comments and license, optional
        if comments_and_licence != "" then
            comments_and_licence.each do |line|
               $file_offo_pattern.puts line.
                   gsub(/--/,'‐‐').
                   gsub(/%/,'').
                   gsub(/^\s*(\S+.*)$/, '<!-- \1 -->')
            end
    		$file_offo_pattern.puts
        end
        
        # hyphenmin, optional
		if language.hyphenmin != nil and language.hyphenmin.length != 0 then
            $file_offo_pattern.puts "<hyphen-min before=\"#{language.hyphenmin[0]}\" after=\"#{language.hyphenmin[1]}\"/>"
            $file_offo_pattern.puts
        end
      
        # classes, optional
        if classes != nil then
            $file_offo_pattern.puts '<classes>'
			$file_offo_pattern.puts classes
            $file_offo_pattern.puts '</classes>'
		    $file_offo_pattern.puts
		end
            
        # exceptions, optional
		if exceptions != ""
            $file_offo_pattern.puts '<exceptions>'
			$file_offo_pattern.puts exceptions
            $file_offo_pattern.puts '</exceptions>'
            $file_offo_pattern.puts
		end

        # patterns
		$file_offo_pattern.puts '<patterns>'
		patterns.each do |pattern|
			$file_offo_pattern.puts pattern.gsub(/'/,"’")
		end
		$file_offo_pattern.puts '</patterns>'
		$file_offo_pattern.puts

		$file_offo_pattern.puts '</hyphenation-info>'

		$file_offo_pattern.close
	end
end
