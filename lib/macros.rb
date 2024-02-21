# Wiki Extensions plugin for Redmine
# Copyright (C) 2009-2013  Haruyuki Iida
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
require 'redmine'

module Macros
    def extract_macro_options(args, *keys)
        options = {}
        while args.last.to_s.strip =~ %r{^(.+?)\=(.+)$} && keys.include?($1.downcase.to_sym)
        options[$1.downcase.to_sym] = $2
        args.pop
        end
        return [args, options]
    end
    Redmine::WikiFormatting::Macros.register do
    desc "Displays a comment form."
    macro :child_page_order do |obj, args|
        args, options = extract_macro_options(args, :parent, :depth)
        options[:depth] = options[:depth].to_i if options[:depth].present?

        page = nil
        if args.size > 0
          page = Wiki.find_page(args.first.to_s, :project => @project)
        elsif obj.is_a?(WikiContent) || obj.is_a?(WikiContentVersion)
          page = obj.page
        else
          raise t(:error_childpages_macro_no_argument)
        end
        raise t(:error_page_not_found) if page.nil? || !User.current.allowed_to?(:view_wiki_pages, page.wiki.project)

        pages = page.self_and_descendants(options[:depth]).group_by(&:parent_id)

        temp = pages.transform_values do |page_list|
            page_list
                .map { |page| WikiPageDetail.find_by(wiki_page: page) }
                .compact
                .sort_by { |detail| [detail.above_sibling_id ? 1 : 0, detail.above_sibling_id || 0] }
                .map(&:wiki_page)
        end
        render_page_hierarchy(temp, options[:parent] ? page.parent_id : page.id)
    end
  end
end
