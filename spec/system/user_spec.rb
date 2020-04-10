require "rails_helper"

RSpec.describe "Users", type: :system do

  describe "user check test" do
    let(:user) {create(:user)}
    let(:other_user) { (create(:user)) }
    let(:task) {create(:task, title: 'たたた', user_id: user.id)}

    describe "before login" do
      describe "create new user" do
        context "when all value is true" do
          it "success create user" do
            user = build(:user)
            visit new_user_path
            fill_in 'Email', with: user.email
            fill_in 'Password', with: 'password'
            fill_in 'Password confirmation', with: 'password'
            click_button('SignUp')
            expect(current_path).to eq(login_path)
            expect(page).to have_content 'User was successfully created'
          end
        end
        context 'when it blank email' do
          it 'user create fail' do
            visit new_user_path
            fill_in 'Email', with: nil
            fill_in 'Password', with: 'password'
            fill_in 'Password confirmation', with: "password"
            click_button('SignUp')
            expect(current_path).to eq(users_path)
            expect(page).to have_content "Email can't be blank"
          end
        end

        context 'email already taken' do
          it 'create new User :fail' do
            user = create(:user)
            visit new_user_path
            fill_in 'Email', with: user.email
            fill_in 'Password', with: 'password'
            fill_in 'Password confirmation', with: 'password'
            click_button('SignUp')
            expect(current_path).to eq(users_path)
            expect(page).to have_content "Email has already been taken"
          end
        end
      end

      describe 'my page' do
        context 'before login' do
          it 'fail access to mypage' do
            user = create(:user)
            visit edit_user_path(user)
            expect(current_path).to eq(login_path)
            expect(page).to have_content 'Login required'
          end
        end
      end
    end

    describe 'after login' do
      describe 'edit user' do
        context 'form value is all true' do
          it 'success edit user' do
            user = create(:user)
            login(user)
            visit edit_user_path(user)
            fill_in 'Email', with: 'edit@example.com'
            fill_in 'Password', with: 'password2'
            fill_in 'Password confirmation', with: 'password2'
            click_button('Update')
            expect(current_path).to eq(user_path(user))
            expect(page).to have_content 'User was successfully updated.'
            expect(user.reload.email).to eq 'edit@example.com'
          end
        end
      end

      context 'when email blank' do
        it 'fail edit user' do
          user = create(:user)
          login(user)
          visit edit_user_path(user)
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'password2'
          fill_in 'Password confirmation', with: 'password2'
          click_button('Update')
          expect(current_path).to eq(user_path(user))
          expect(page).to have_content "Email can't be blank"
        end
      end

      context 'user email it has already taken' do
        it 'fail to registe User' do
          other_user = User.create(email: 'hoge2@example.com', password: 'hoge2', password_confirmation: 'hoge2')
          visit login_path
          fill_in 'Email', with: 'hoge2@example.com'
          fill_in 'Password', with: 'hoge2'
          click_button('Login')
          visit edit_user_path(other_user)
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'passwordhoge2'
          fill_in 'Password confirmation', with: 'passwordhoge2'
          click_button('Update')
          expect(current_path).to eq(user_path(other_user))
          expect(page).to have_content 'Email has already been taken'
        end
      end
      context 'access other user page' do
        it 'fail access' do
          user = create(:user)
          login(user)
          visit edit_user_path(other_user)
          expect(page).to have_content 'Forbidden access'
          expect(current_path).to eq(user_path(user))
        end
      end
    end

    describe 'my page' do
      context 'create task' do
        it 'show created new task' do
          user = create(:user)
          login(user)
          visit new_task_path
          fill_in 'Title', with: 'タスクのタイトル'
          fill_in 'Content', with: 'タスクのコンテンツ'
          select 'todo', from: 'Status'
          click_button('Create Task')
          visit user_path(user)
          expect(page).to have_content 'タスクのタイトル'
        end
      end
    end
  end
end
