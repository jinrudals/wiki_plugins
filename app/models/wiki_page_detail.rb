class WikiPageDetail < ActiveRecord::Base
    belongs_to :wiki_page
    belongs_to :above_sibling, class_name: 'WikiPageDetail', optional: true

    has_one :below_sibling, class_name: 'WikiPageDetail', foreign_key: 'above_sibling_id'


    def create_row

    end
end
