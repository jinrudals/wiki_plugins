module WikiPlugins
    module WikiPagePatch
        def self.included(base) # :nodoc:
            base.extend(ClassMethods)
            base.send(:include, InstanceMethods)

            base.class_eval do
                after_create :create_wiki_page_detail
                before_save :handle_page_move
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

            def handle_page_move
                if self.parent_id_changed? && !self.new_record?
                    # Unset the current module
                    page = self
                    tempO = WikiPageDetail.find_by(wiki_page: page)
                    previous = tempO.above_sibling

                    # If the page has siblings
                    if page.siblings.any?
                        # Get the WikiPageDetails for siblings in a single query
                        sibling_details = WikiPageDetail.where(wiki_page: page.siblings)

                        # Sort by 'above_sibling_id' presence and value
                        sorted_siblings = sibling_details.sort_by do |detail|
                            [detail.above_sibling_id ? 1 : 0, detail.above_sibling_id || 0]
                        end

                        # Assign the last sibling as the above_sibling
                        tempO.above_sibling = sorted_siblings.last
                    else
                        # If there are no siblings
                        tempO.above_sibling = nil
                    end

                    tempO.save

                    # Change any WikiPageDetail that has current tempO
                    if WikiPageDetail.find_by(above_sibling: tempO)
                        t = WikiPageDetail.find_by(above_sibling: tempO)
                        t.above_sibling = previous
                        t.save
                    end
                end
            end
        end
    end
end

