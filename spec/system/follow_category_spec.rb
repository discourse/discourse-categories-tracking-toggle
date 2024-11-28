# frozen_string_literal: true

RSpec.describe "Category Tracking Toggle", system: true do
  fab!(:user)
  fab!(:category)

  let!(:theme) { upload_theme_component }

  before do
    sign_in(user)
    CategoryUser.set_notification_level_for_category(
      user,
      NotificationLevels.all[:regular],
      category.id,
    )
  end

  context "when visiting the categories page" do
    before { visit "/categories" }

    it "displays the category toggle button" do
      expect(page).to have_css("[data-category-id='#{category.id}'] .custom-category-toggle")
    end

    it "mutes the category when clicking the toggle" do
      find("[data-category-id='#{category.id}'] .custom-category-toggle").click

      try_until_success do
        expect(CategoryUser.lookup(user, :muted).pluck(:category_id)).to include(category.id)
      end
    end

    it "unmutes the category when clicking the toggle again" do
      find("[data-category-id='#{category.id}'] .custom-category-toggle").click

      try_until_success do
        expect(CategoryUser.lookup(user, :regular).pluck(:category_id)).to include(category.id)
      end
    end
  end
end
