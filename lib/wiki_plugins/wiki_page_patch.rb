module WikiPlugins
    module WikiPagePatch
        def self.included(base) # :nodoc:
            base.extend(ClassMethods)
            base.send(:include, InstanceMethods)

            base.class_eval do
                after_create :create_wiki_page_detail
            end
        end

        module ClassMethods
        end

        module InstanceMethods
            private
            def create_wiki_page_detail
                page = self

                if !page.siblings.length
                    WikiPageDetail.create(wiki_page: page)
                else
                    siblings = page.siblings.map do |each|
                        temp = WikiPageDetail.find_by(wiki_page: each)
                        temp
                    end.sort_by{ |item| [item[:above_sibling_id] ? 1 :0, item[:above_sibling_id] || 0]}
                    WikiPageDetail.create(wiki_page: page, above_sibling: siblings.last)
                end
            end
        end
    end
end