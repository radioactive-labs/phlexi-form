# frozen_string_literal: true

ActiveRecord::Schema.define do
  create_table :users, force: true do |t|
    t.string :name
    t.string :email
    t.timestamps null: false
  end

  create_table :posts, force: true do |t|
    t.belongs_to :user
    t.string :body
    t.timestamps null: false
  end
end
