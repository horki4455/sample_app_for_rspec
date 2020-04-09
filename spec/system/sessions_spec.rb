require 'rails_helper'

RSpec.describe 'Sessions', type: :system do
  describe 'login behavior test' do
    let!(:user) { create(:user, email: 'loginuser@example.com', password: 'password') }
    describe 'before login' do
      context 'input value: true' do
        before do
          login(user)
        end
        it 'login success' do
          expect(page).to have_current_path root_path
          expect(page).to have_content 'Login successful'
        end
      end

      context 'fill out form' do
        it 'fail login' do
          visit login_path
          fill_in 'email',with: nil
          fill_in 'password', with: 'password'
          click_button('Login')
          expect(page).to have_current_path login_path
          expect(page).to have_content 'Login failed'
        end
      end
      describe 'after login' do
        before do
          login(user)
        end
        context 'click click_button' do
          it 'success logout' do
            click_link('Logout')
            expect(current_path).to eq(root_path)
            expect(page).to have_content 'Logged out'
            expect(page).to have_content 'Tasks'
          end
        end
      end
    end
  end
end
