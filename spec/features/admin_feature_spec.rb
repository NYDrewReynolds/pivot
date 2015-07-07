require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 5

describe 'admin user', type: :feature do

	before do
		@user = create(:user, first_name: 'joe', email: 'abc@example.com', password: 'asdf', password_confirmation: 'asdf', role:'admin')
    visit '/'
    fill_in 'email', with: "#{@user.email}"
    fill_in 'password', with: "#{@user.password}"
    click_on 'login'
	end

	it 'has a role of admin' do
		visit '/'
		expect(page).to have_content("Admin Dashboard")
	end

	it 'is redirected to an admin dashboard upon login' do
		click_on 'Logout'
		expect(current_path).to eq root_path
		fill_in 'email', with: "#{@user.email}"
		fill_in 'password', with: "#{@user.password}"
		click_on 'login'
		expect(page).to have_content("Administrator")
		expect(current_path).to eq admin_path
		expect(page).to have_content "Site Administrator Dashboard"
	end

describe 'admin dashboard' do

		it 'has link to create new items' do
		  visit admin_path
			expect(page).to have_content('Site Administrator Dashboard')
			expect(page).to have_content('Create A New Menu Item')
		end

		it 'has link to manage users' do
			visit admin_path
			expect(page).to have_content('View Current Users')
		end

		it 'has link to manage orders' do
			visit admin_path
			expect(page).to have_content('View Current Orders')
		end
	end

	it 'can create item listings' do
		small_plates_category = create(:category, title: 'Small Plates')
		visit '/admin'
		click_on('Create A New Menu Item')
		expect(page).to have_content("Create New Item")
		fill_in 'Title', with: "Test Item"
		fill_in 'Description', with: "Test Description"
		fill_in 'Price', with: '19.22'
    find(:css, ".category_checkbox").set(true)
		click_on('Create Item')
		expect(page).to have_content("Your item has been successfully added to the menu!")
	end

	it 'can edit item listings' do
		small_plates_category = create(:category, title: 'Small Plates')
		create(:item, id: 1, title: 'Second Food', categories: [small_plates_category])
		visit 'admin/items/1/edit'
		expect(page).to have_content("You are currently editing")
		fill_in "item_title", with: "Edited Item"
		fill_in "item_description", with: "Edited Description"
		fill_in "item_price", with: "12.00"
		click_on('Save Changes')
		expect(page).to have_content("Your item has been successfully updated!")
	end

	it 'can create named categories for items' do
		visit '/admin'
		click_on('Create A New Category')
		expect(page).to have_content("Create New Category")
		fill_in "category_title", with: "New Category"
		click_on('Create Category')
		expect(page).to have_content("Your category has been successfully created!")
	end

	it 'can assign items to categories' do
		small_plates_category = create(:category, title: 'Small Plates')
		create(:item, id: 1, title: 'Second Food', categories: [small_plates_category])
		visit '/admin/items/1/edit'
		find(:css, ".category_checkbox").set(true)
		click_on("Save Changes")
		visit '/admin/items/1'
		expect(page).to have_content("Small Plates")
	end

	it 'can remove items from categories' do
		small_plates_category = create(:category, title: 'Small Plates')
		create(:item, id: 1, title: 'Second Food', categories: [small_plates_category])
		visit '/admin/items/1/edit'
		find(:css, ".category_checkbox").set(false)
		checkbox = find(".category_checkbox")
		expect(checkbox).to_not be_checked
		click_on("Save Changes")
		visit '/admin/items/1'
		expect(page).to_not have_content("Small Plates")
	end

	it 'can retire items from being sold' do
		small_plates_category = create(:category, title: 'Small Plates')
		create(:item, id: 1, title: 'Second Food', categories: [small_plates_category])
		visit '/admin/items/1/edit'
		expect(page).to have_content("Active")
		click_on 'Save Changes'
		expect(page).to have_content("Your item has been successfully updated!")
	end

	it 'can see retired items only as an admin' do
		small_plates_category = create(:category, title: 'Small Plates')
		item = create(:item, id: 1, title: 'Second Food', categories: [small_plates_category], active: 'false')
		visit '/admin/items/1/edit'
		expect(page).to have_content("Active")
		click_on 'Save Changes'
		expect(page).to have_content("Your item has been successfully updated!")
		click_link 'Return to Your Admin Dashboard'
		expect(page).to have_content"#{item.active}"
		expect(page).to have_content"#{item.id}"
	end

  it "can see all users" do
    visit '/admin'
		click_on 'Create New User or Administrator'
		expect(current_path).to eq new_admin_user_path
    expect(page).to have_content("Create A New User or Administrator")
  end

	it "can create a new user with admin role" do
		visit '/admin/users/new'
		fill_in 'First name', with: 'abc'
		fill_in 'Last name', with: 'poptart'
		fill_in 'Email', with: 'tartkins@example.com'
		fill_in 'Password', with: "abc123"
		fill_in 'Password confirmation', with: "abc123"
		select 'admin', from: 'user_role'
		click_on 'Create New User'
		expect(current_path).to eq admin_users_path
		expect(User.last.role).to eq 'admin'
	end

  it "can see all existing users" do
    visit "/admin/users"
    expect(page).to have_content("Current List of Caussa Users")
  end

	it "can modify an existing user's role" do
		nonadmin_user = create(:user, first_name: 'jojo', email: 'jojojo@example.com', password: 'asdf', password_confirmation: 'asdf', role:'user')
		visit '/admin'
		click_on 'View Current Users'
		expect(current_path).to eq admin_users_path
		click_on('user')
		expect(current_path).to eq edit_admin_user_path(nonadmin_user)
		select 'Admin', from: 'user_role'
		click_on 'Save Changes'
		expect(User.last.role).to eq 'Admin'
	end

describe 'admin order dashboard' do

	before do
		category = create(:category, title: 'Test Category')
		item = create(:item, title: 'Test Item', categories:[category])

		@order = create(:order)
	end

	it 'can see listings of all orders' do
		visit '/admin'
		click_on 'View Current Orders'
		expect(current_path).to eq admin_orders_path
		expect(page).to have_content("Current Orders in System")
	end

	it 'can see the total number of orders by status' do
		visit '/admin/orders'
		expect(page).to have_content('Cancelled: ')
		expect(page).to have_content('Completed: ')
		expect(page).to have_content('Ordered: ')
		expect(page).to have_content('Paid: ')
	end

	it 'can see the links for each individual order' do
		visit '/admin/orders'
		expect(page).to have_content('View/Edit Order')
	end

	it 'can filter orders to display by status type' do
		visit '/admin/orders'
		click_on "Completed:"
		expect(page).to have_content('Completed Orders')
		visit '/admin/orders'
		click_on "Paid:"
		expect(page).to have_content('Paid Orders')
		visit '/admin/orders'
		click_on "Cancelled:"
		expect(page).to have_content('Cancelled Orders')
		visit '/admin/orders'
		click_on "Ordered:"
		expect(page).to have_content('Ordered Orders')
	end

	it 'can link to transition to a different status', js: true do
		visit '/admin/orders'
		click_on('View/Edit Order')
		expect(current_path).to eq edit_admin_order_path(@order)
		click_on('Mark as Paid')
		expect(page).to have_content('paid')
		click_on('Mark as Completed')
		expect(page).to have_content('completed')
		click_on('Cancel My Order')
		expect(page).to have_content('cancelled')
	end

	it 'can access details of an individual order' do
		visit '/admin/orders'
		click_on('View/Edit Order')
		expect(current_path).to eq edit_admin_order_path(@order)
	end

	it 'can access order date and time' do
		visit '/admin/orders'
		expect(page).to have_content('Creation Date')
	end

	it 'can access purchaser full name and email address' do
		visit '/admin/orders'
		click_on('View/Edit Order')
		expect(current_path).to eq edit_admin_order_path(@order)
		expect(page).to have_content('Customer Name:')
		expect(page).to have_content('Customer Email Address:')
	end

	it 'can access order details for each item' do
		small_plates_category = create(:category, title: 'Small Plates')
		create(:item, id: 1, title: 'Second Food', categories: [small_plates_category])
		visit '/admin/orders'
		click_on('View/Edit Order')
		expect(current_path).to eq edit_admin_order_path(@order)
		expect(page).to have_content('Total Price')
	end

	it 'can access total for order' do
		visit '/admin/orders'
		click_on('View/Edit Order')
		expect(current_path).to eq edit_admin_order_path(@order)
		expect(page).to have_content('Total Price')
	end

	it 'can access status of order' do
		visit '/admin/orders'
		click_on('View/Edit Order')
		expect(current_path).to eq edit_admin_order_path(@order)
		expect(page).to have_content('Order Status')
	end

	it 'update an individual order', js: true do
		visit '/admin/orders'
		click_on('View/Edit Order')
		expect(page).to have_selector("#quantity[value='1']")
		fill_in 'quantity', with: '2'
		click_on 'Update Quantity'
		expect(page).to have_content("Total Price: $2.00")
	end

	it 'can view and edit orders', js: true do
		visit '/admin/orders'
		click_on('View/Edit Order')
		expect(current_path).to eq edit_admin_order_path(@order)
		click_on('Remove Item')
		expect(page).to have_content("Total Price: $0.00")
	end

	it 'cannot modify any personal data aside from their own' do
		visit '/admin/users'
		click_on('user')
		expect(page).to_not have_css('first_name[type="text"]')
	end

end

end
