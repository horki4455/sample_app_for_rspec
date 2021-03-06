require 'rails_helper'

RSpec.describe 'Tasks', type: :system do
  describe 'action test' do
    let(:user) { create(:user)}
    let(:task) { create(:task, user_id: user.id)}
    let(:other_user) { create(:user) }
    let(:other_task) { create(:task, user_id: other_user.id) }

    describe 'before login' do
      describe 'task new create page' do
        context 'no permission' do
          it 'faile to access' do
            user = create(:user)
            visit new_task_path
            expect(page).to have_content 'Login required'
            expect(current_path).to eq(login_path)
          end
        end
      end

      describe 'edit task page' do
        context 'no parmission' do
          it 'faile access' do
            visit edit_task_path(task)
            expect(current_path).to eq(login_path)
            expect(page).to have_content 'Login required'
          end
        end
      end
    end

    describe 'after login' do
      describe 'new task create page' do
        before do
          login(user)
          create(:task, user_id: user.id)
        end
        context 'when all filled in content' do
          it 'success create task' do
            visit new_task_path
            fill_in 'Title', with: 'Task1'
            fill_in 'Content', with: 'cont1'
            select 'todo', from: 'Status'
            click_button('Create Task')
            expect(page).to have_content 'Task was successfully created'
            expect(page).to have_content 'Task1'
            expect(page).to have_content 'cont1'
          end
        end
      end
      describe 'edit task' do
        context 'content is valid' do
          it 'success create task' do
            visit login_path
            fill_in 'Email', with: user.email
            fill_in 'Password', with: 'password'
            click_button('Login')
            visit edit_task_path(task)
            fill_in 'Title', with: 'Task2'
            fill_in 'Content', with: 'Task2'
            select 'doing', from: 'Status'
            fill_in 'Deadline', with: 'Time.current.since'
            click_button('Update Task')
            expect(page).to have_content 'Task was successfully updated.'
            expect(page).to have_content task.reload.title
            expect(page).to have_content task.reload.content
          end
        end
      end
    end
      context '他ユーザーの編集ページにアクセスした時' do
        it '権限がないため、アクセス失敗' do
          user = create(:user)
          visit login_path
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          click_button('Login')
          visit edit_task_path(other_task)
          expect(page).to have_content 'Forbidden access'
          expect(current_path).to eq(root_path)
        end
      end


    describe 'task index' do
      context 'when click destroy button' do
        before do
          login(user)
        end
        it 'success destroy task' do
          task　= create(:task, user_id: user.id)
          visit tasks_path
          click_link('Destroy')
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content 'Task was successfully destroyed.'
          expect(page).not_to have_content task.title
        end
      end
    end
  end
end
