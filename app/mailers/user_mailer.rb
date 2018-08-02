class UserMailer < ApplicationMailer
  def active_task user, task
    @user = user
    @task = task
    check_done = true
    @task.subtasks.each do |subtask|
      unless subtask.done
        check_done = false
        break
      end
    end

    return if check_done
    mail to: user.email, subject: t("mail.subject") + task.content
  end
end
