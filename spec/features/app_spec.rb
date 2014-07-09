require "spec_helper"

feature "Homepage" do
  scenario "check homepage" do
    visit "/"
    expect(page).to have_button("Registration")
    expect(page).to have_content("username")
    expect(page).to have_content("password")
    expect(page).to have_button("Login")
  end
end
feature "Register page" do
  scenario "visit registration page" do
    visit "/"
    click_link "Registration"
    expect(page).to have_content("username")
    expect(page).to have_content("password")
  end
  scenario "empty username" do
    visit "/registration"
    fill_in 'username', with: ''
    fill_in 'password', with: 'Ilovekittens'
    click_button "Submit"
    expect(page).to have_content("Please fill in username")
  end
  scenario "empty password" do
    visit "/registration"
    fill_in 'username', with: 'Lindsay'
    fill_in 'password', with: ''
    click_button "Submit"
    expect(page).to have_content("Please fill in password")
  end
  scenario "empty all" do
    visit "/registration"
    fill_in 'username', with: ''
    fill_in 'password', with: ''
    click_button "Submit"
    expect(page).to have_content("Please fill in username and password")
  end
  scenario "empty all" do
    visit "/registration"
    fill_in 'username', with: 'asd'
    fill_in 'password', with: 'qwe'
    click_button "Submit"
    click_link "Registration"
    fill_in 'username', with: 'asd'
    fill_in 'password', with: 'qwe'
    click_button "Submit"
    expect(page).to have_content("Username is already in use.")
  end

end
feature "Fill in form and see greeting" do
  scenario "visit registration page" do
    visit "/registration"
    fill_in 'username', with: 'Lindsay'
    fill_in 'password', with: 'Ilovekittens'
    click_button "Submit"
    expect(page).to have_content("Thank you for registering")
    end
end
feature "Login" do
  scenario "have logged out" do
    visit "/"
    fill_in 'username', with: 'Alex'
    fill_in 'password', with: 'Ilovepuppies'
    click_button "Login"
    expect(page).to have_content("Welcome, Alex")
    expect(page).to have_button("Logout")
    expect(page).to have_no_button("Login")
    expect(page).to have_no_button("Registration")
  end
  scenario "log out" do
    visit "/"
    fill_in 'username', with: 'Alex'
    fill_in 'password', with: 'Ilovepuppies'
    click_button "Login"
    click_link "Logout"
    expect(page).to have_no_button("Logout")
    expect(page).to have_button("Login")
    expect(page).to have_button("Registration")
  end
end
