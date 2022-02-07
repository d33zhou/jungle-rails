require 'rails_helper'

RSpec.describe Product, type: :model do
  
  describe 'Validations' do

    before do
      @category = Category.new(name: 'Food')
      @category.save!
    end

    it 'should allow a fully completed form to save' do
      @product = @category.products.create({
        name: 'Potato Chips',
        price: 4.99,
        quantity: 105,
        # category is auto-generated
      })
      @product.save! # using bang as test should error out if save here fails

      expect(@product.id).to be_present
    end

    it 'should verify that a name exists' do
      @product = @category.products.create({
        name: nil,
        price: 4.99,
        quantity: 105,
        # category is auto-generated
      })
      @product.save

      expect(@product.id).not_to be_present
      expect(@product.errors.full_messages).to include(/Name can't be blank/)
    end

    it 'should verify that a price exists' do
      @product = @category.products.create({
        name: 'Potato Chips',
        price: nil,
        quantity: 105,
        # category is auto-generated
      })
      @product.save

      expect(@product.id).not_to be_present
      expect(@product.errors.full_messages).to include(/Price can't be blank/)
    end

    it 'should verify that a quantity exists' do
      @product = @category.products.create({
        name: 'Potato Chips',
        price: 4.99,
        quantity: nil,
        # category is auto-generated
      })
      @product.save

      expect(@product.id).not_to be_present
      expect(@product.errors.full_messages).to include(/Quantity can't be blank/)
    end

    it 'should verify that a category exists' do
      @product = Product.create({
        name: 'Potato Chips',
        price: 4.99,
        quantity: 105,
        category: nil
      })
      @product.save

      expect(@product.id).not_to be_present
      expect(@product.errors.full_messages).to include(/Category can't be blank/)
    end

  end

end
