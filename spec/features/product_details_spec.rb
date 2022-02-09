require 'rails_helper'

RSpec.feature "Visitor navigates to product details page", type: :feature, js: true do
  
  # SETUP
  before :each do
    @category = Category.create! name: 'Apparel'

    10.times do |n|
      @category.products.create!(
        name:  Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end

  scenario "They navigate from the home page to the product detail page by clicking on a product" do
    
    # ACT
    visit root_path

    page.find('.products').first(:link, 'Details').click
    
    sleep 5 # give page time to render before saving screenshot

    # DEBUGGING
    # save_screenshot
    # puts page.html

    # VERIFY
    expect(page).to have_css '.main-img'
  end

end
