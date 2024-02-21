class CreateWikiPageDetails < ActiveRecord::Migration[6.1]
  def change
    if table_exists?(:wiki_page_details)
      drop_table :wiki_page_details
    end

    create_table :wiki_page_details do |t|
      t.integer :wiki_page_id, null: false  # Changed from bigint to integer
      t.bigint :above_sibling_id, null: true  # Assuming this also needs to be an integer

      t.index :wiki_page_id
      t.index :above_sibling_id
    end

    # Add foreign keys separately with explicit column type matching
    add_foreign_key :wiki_page_details, :wiki_pages, column: :wiki_page_id
    add_foreign_key :wiki_page_details, :wiki_page_details, column: :above_sibling_id
  end
end