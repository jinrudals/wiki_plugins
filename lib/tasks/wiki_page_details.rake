namespace :wiki_page_details do
  desc "Create WikiPageDetail records for existing WikiPages"
  task create_for_existing: :environment do
    WikiPage.find_each do |page|
      next if WikiPageDetail.exists?(wiki_page_id: page.id)
      # Logic to create WikiPageDetail record for 'page'
      # Similar to the logic in create_wiki_page_detail method
    end
  end
end