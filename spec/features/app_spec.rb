require "spec_helper"

feature "Homepage" do
  scenario "check homepage" do
    visit "/"
    expect(page).to have_button("Register")
    expect(page).to have_content("Username:")
    expect(page).to have_content("Password:")
    expect(page).to have_button("Login")
  end
end
feature "Register page" do
  scenario "visit registration page" do
    visit "/"
    click_button "Register"
    expect(page).to have_content("Username:")
    expect(page).to have_content("Password:")
  end
  scenario "empty username" do
    visit "/registration"
    fill_in 'Username:', with: ''
    fill_in 'Password:', with: 'Ilovekittens'
    click_button "Register"
    expect(page).to have_content("Username is required")
  end
  scenario "empty password" do
    visit "/registration"
    fill_in 'Username:', with: 'Lindsay'
    fill_in 'Password:', with: ''
    click_button "Register"
    expect(page).to have_content("Password is required")
  end
  scenario "empty all" do
    visit "/registration"
    fill_in 'Username:', with: ''
    fill_in 'Password:', with: ''
    click_button "Register"
    expect(page).to have_content("Username and password are required")
  end
  scenario "empty all" do
    visit "/registration"
    fill_in 'Username:', with:  "mandy"
    fill_in 'Password:', with: 'qwe'
    click_button "Register"
    click_button "Register"
    fill_in 'Username:', with: "mandy"
    fill_in 'Password:', with: 'qwe'
    click_button "Register"
    expect(page).to have_content("Username is already in use, please choose another.")
  end

end
feature "Fill in form and see greeting" do
  scenario "visit registration page" do
    visit "/registration"
    fill_in 'Username:', with: 'Lindsay'
    fill_in 'Password:', with: 'Ilovekittens'
    click_button "Register"
    expect(page).to have_content("Thank you for registering")
    end
end
feature "Login and out" do
  scenario "have logged out" do

    visit "/"
    click_button "Register"
    fill_in 'Username:', with:  'Alex'
    fill_in 'Password:', with: 'Ilovepuppies'
    click_button "Register"
    fill_in 'Username:', with:  'Alex'
    fill_in 'Password:', with: 'Ilovepuppies'
    click_button "Login"
    expect(page).to have_content("Welcome, Alex")
    expect(page).to have_button("Logout")
    expect(page).to have_no_button("Login")
    expect(page).to have_no_link("Registration")
    click_button "Logout"
    expect(page).to have_no_button("Logout")
    expect(page).to have_button("Login")
    expect(page).to have_button("Register")
  end
end
feature "Display users" do
  scenario "on user page display other current users" do
  visit "/"
  click_button "Register"
  fill_in 'Username:', with:  'Phil'
  fill_in 'Password:', with: 'Iloveponies'
  click_button "Register"
  visit "/"
  click_button "Register"
  fill_in 'Username:', with:  'Steve'
  fill_in 'Password:', with: 'Ilovefish'
  click_button "Register"
  visit "/"
  click_button "Register"
  fill_in 'Username:', with:  'John'
  fill_in 'Password:', with: 'Ilovebirds'
  click_button "Register"
  fill_in 'Username:', with: 'Phil'
  fill_in 'Password:', with: 'Iloveponies'
  click_button "Login"
  expect(page).to have_content("John")
  expect(page).to have_content("Steve")
  visit "/"
  # expect(page).to have_no_content("Phil")
  choose('Ascending')
  click_button "Submit"
  expect(page).to have_selector('table td:nth-child(1)', text: 'John')
  end
  feature "Delete users" do
    scenario "as a logged in user i can delete users from my page" do
    visit "/"
    click_button "Register"
    fill_in 'Username:', with: 'Phil'
    fill_in 'Password:', with: 'Iloveponies'
    click_button "Register"
    click_button "Register"
    fill_in 'Username:', with:  'Steve'
    fill_in 'Password:', with: 'Ilovefish'
    click_button "Register"
    fill_in 'Username:', with: 'Phil'
    fill_in 'Password:', with: 'Iloveponies'
    click_button "Login"
    expect(page).to have_content("Steve")
    click_link "Delete Steve"
    expect(page).to have_no_content("Steve")
    end
  end

  feature "fish activities" do
    scenario "Create a fish" do
      visit '/'
      click_button "Register"
      fill_in 'Username:', with:  'Steve'
      fill_in 'Password:', with: 'Ilovefish'
      click_button "Register"
      fill_in 'Username:', with: 'Steve'
      fill_in 'Password:', with: 'Ilovefish'
      click_button "Login"
      click_button "Create Fish"
      fill_in "Name:", with: "Shark"
      fill_in "Wiki:", with: "www.greatsharksite.com"
      click_button "Create"
      click_button "Logout"
      click_button "Register"
      fill_in 'Username:', with: 'Phil'
      fill_in 'Password:', with: 'Iloveponies'
      click_button "Register"
      fill_in 'Username:', with: 'Phil'
      fill_in 'Password:', with: 'Iloveponies'
      click_button "Login"
      click_button "Create Fish"
      fill_in "Name:", with: "Goldfish"
      fill_in "Wiki:", with: "www.greatfishsite.com"
      click_button "Create"
      expect(page).to have_content("Goldfish")
      expect(page).to have_no_content("Shark")
      click_link "Steve"
      expect(page).to have_content("Shark")
    end


  end


end




