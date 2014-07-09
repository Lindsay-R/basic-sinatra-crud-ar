require "spec_helper"

feature "Homepage" do
  scenario "check homepage" do
    visit "/"
    expect(page).to have_button("Registration")
  end
end
feature "Register page" do
  scenario "visit registration page" do
    visit "/"
    click_link "Registration"
    expect(page).to have_content("username")
    expect(page).to have_content("password")
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