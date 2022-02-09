require 'rails_helper'

RSpec.feature "Visitor adds an item to cart which increases cart count", type: :feature, js: true do
  
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

    # ACT
    visit root_path # start from home page

  end

  scenario "They click the 'Add' button to add item to cart, which increases cart count by 1" do
    
    page.find('.products').first(:button, 'Add').click
    
    sleep 5 # give page time to render before saving screenshot

    # DEBUGGING
    # save_screenshot
    # puts page.html

    # VERIFY
    expect(page).to have_content 'My Cart (1)'
  end

end
