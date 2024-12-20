module SignInSupport
  def sign_in(user)
    visit(root_path)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    find('input[name="commit"]').click
    expect(page).to have_current_path(root_path)
  end
end
