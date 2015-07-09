require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 5

describe 'authenticated user', type: :feature do
  include Capybara::DSL

	before do
		user = create(:user, id: 1, first_name: 'joe', email: 'abc@example.com', password: 'asdf', password_confirmation: 'asdf')
    @restaurant_1 = create(:restaurant, name: "Pizza Palace", cuisine: "food")
    create(:restaurant, name: "Jorges Garden", cuisine: "mexican")
    create(:restaurant, name: "Sergios", cuisine: "italian")
    category = Category.create(title: 'Small Plates', restaurant_id: @restaurant_1.id)
    @item = Item.create(title: 'Second Food', category_ids: category.id, description: "foodn' shit", price: 10, restaurant_id: @restaurant_1.id)
    visit '/'
    fill_in 'email', with: "#{user.email}"
    fill_in 'password', with: "#{user.password}"
    click_on 'login'
	end

	it 'can browse all items' do
		visit '/'
    click_link 'pizza-palace'
    expect(current_path).to eq(restaurant_path(@restaurant_1))
    expect(page).to have_content 'Pizza Palace'
	end

	it 'can browse items by category', js: true do
    visit '/'
    click_link 'pizza-palace'
    expect(page).to have_content 'Pizza Palace'
    click_link 'Small Plates'
    expect(page).to have_content 'Small Plates'
    expect(page).to have_content 'Second Food'
	end

	it 'can add item to cart', js: true do
    visit restaurant_path(@restaurant_1)
    find('#add_to_cart').click
    expect(page).to have_content 'Item added to your cart!'
    within('.cart-container') do
        expect(page).to have_content '1'
      end
	end

	it 'can view my cart' do
		within('.cart-container') do
        find('a').click
      end
		expect(current_path).to eq(cart_edit_path)
    expect(page).to have_content('Your Cart')
	end

	it 'can remove an item from my cart', js: true do
    visit restaurant_path(@restaurant_1)
    find('#add_to_cart').click
    expect(page).to have_content 'Item added to your cart!'
    visit cart_edit_path
    find("#remove_item").click
    within('.cart-container') do
      expect(page).to have_content '0'
    end
	end

	it "can update the quantity of an item in the cart", js: true do
    visit restaurant_path(@restaurant_1)
    find('#add_to_cart').click
    expect(page).to have_content 'Item added to your cart!'
    visit cart_edit_path
    fill_in('quantity', with: '2')
    find('#update_quantity').click
    within('.cart-container') do
      expect(page).to have_content '2'
    end
    selected = find('#quantity').value
    expect(selected).to eq('2')
  end

  it "can logout" do
  	visit '/'
    expect(page).to have_content 'Logout'
    click_on 'Logout'
    expect(page).to have_css '#email'
    expect(page).to have_css '#password'
  end

  it 'can view past orders with links to display each order' do
    visit '/'
    click_on 'My Profile'
    click_on 'Your Orders'
    expect(page).to have_content 'Order Status'
  end

	it 'cannot view another users order' do
    #this should work? Any other way to expect a routing error?
    expect{visit '/users/3/orders'}.to raise_error( ActionController::RoutingError)
  end

	it 'cannot access admin item pages' do
		visit edit_restaurant_admin_item_path(@restaurant_1, @item)
		expect(page).to_not have_content "Edit Item"
		expect(current_path).to eq(root_path)
		expect(page).to have_content "You are not authorized to access this page."
		visit new_restaurant_admin_item_path(@restaurant_1)
		expect(page).to_not have_content "Create New Item"

		expect(page).to have_content "You are not authorized to access this page."
	end

  it 'cannot access admin user pages' do
    visit edit_restaurant_admin_user_path(@restaurant_1, 1)
    expect(page).to_not have_content "User or Admin?"
  end

	it 'cannot make itself an admin' do
		visit '/users/1/edit'
		expect(page).to_not have_content "User or Admin"
	end

  it 'cannot add a retired item to the cart' do
    restaurant = create(:restaurant, name: "bobs", cuisine: "dogs")
    category = Category.create(title: 'Big Plates', restaurant_id: restaurant.id)
    item = Item.create(title: 'First Food', category_ids: category.id, description: "shit", price: 10, restaurant_id: restaurant.id, active: false)
      visit restaurant_item_path(restaurant, item)
      expect(page).to have_content "First Food"
      visit restaurant_path(restaurant)
      expect(page).to_not have_content "First Food"
  end

end

describe 'authenticated user order display page' do
    before do
      user = create(:user, id: 1, first_name: 'joe', email: 'abc@example.com', password: 'asdf', password_confirmation: 'asdf')
      @restaurant_1 = create(:restaurant, name: "Pizza Palace", cuisine: "food")
      create(:restaurant, name: "Jorges Garden", cuisine: "mexican")
      create(:restaurant, name: "Sergios", cuisine: "italian")
      category = Category.create(title: 'Small Plates', restaurant_id: @restaurant_1.id)
      @item = Item.create(title: 'Second Food', category_ids: category.id, description: "foodn' shit", price: 10, restaurant_id: @restaurant_1.id)
      @order = create(:order, user_id: 1, items: [@item] )
      visit '/'
      fill_in 'email', with: "#{user.email}"
      fill_in 'password', with: "#{user.password}"
      click_on 'login'
      click_on 'My Profile'
      click_on 'Your Orders'
    end

    it 'displays item with quantity ordered' do
      click_on '1'
      expect(page).to have_content "Second Food"
      expect(page).to have_content "1"
    end

    it 'shows line-item subtotals' do
      click_on '2'
      expect(page).to have_content 'Second Food 1 $10.00'
    end

    it 'links to each item description' do
      click_on '3'
      click_on 'Second Food'
      expect(page).to have_content "Second Food"
    end
    it 'shows current status of an order' do
      @order.status = 'pending'
      click_on '4'
      expect(page).to have_content "Order Status"
    end

    it 'shows total order price' do
      click_on '5'
      expect(page).to have_content "Price $10.00"
    end
end
