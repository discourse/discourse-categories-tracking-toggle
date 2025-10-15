# frozen_string_literal: true

RSpec.describe "Category Tracking Toggle", system: true do
  fab!(:user)
  fab!(:category)

  let!(:theme) { upload_theme_component }

  before { sign_in(user) }

  context "when visiting the categories page" do
    it "mutes the category when clicking the toggle" do
      CategoryUser.set_notification_level_for_category(
        user,
        NotificationLevels.all[:regular],
        category.id,
      )

      visit "/categories"

      find("[data-category-id='#{category.id}'] .custom-category-toggle").click

      expect(CategoryUser.lookup(user, :muted).pluck(:category_id)).to include(category.id)
    end

    it "unmutes the category when clicking the toggle again" do
      CategoryUser.set_notification_level_for_category(
        user,
        NotificationLevels.all[:muted],
        category.id,
      )

      visit "/categories"

      find(".muted-categories").click
      find("[data-category-id='#{category.id}'] .custom-category-toggle").click

      expect(CategoryUser.lookup(user, :regular).pluck(:category_id)).to include(category.id)
    end
  end
end
