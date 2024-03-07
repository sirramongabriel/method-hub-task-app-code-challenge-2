class Api::V1::TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def create
    task_params = params.require(:task).permit(
                    :title, 
                    :description, 
                    :date_due, 
                    :date_completed, 
                    :status, 
                    :progress, 
                    :priority_level
                  )
    @task = Task.new(task_params)

    if @task.save
      render json: { status: 200, body: 'Task created successfully.' }
    else
      render json: { status: 400, body: "Task creation failed: #{@task.errors.full_messages.join(', ')}" }
    end
  end

  def update
    @task = Task.find(params[:id])

    task_params = params.require(:task).permit(
                    :title, 
                    :description, 
                    :date_due, 
                    :date_completed, 
                    :status, 
                    :progress, 
                    :priority_level
                  )

    if @task.update(task_params)
      if @task.status == 'Completed'
        @task.date_completed = Date.current
      end
      render json: { status: 200, body: 'Task updated successfully.' }
    else
      render json: { status: 400, body: "Task update failed: #{@task.errors.full_messages.join(', ')}" }
    end
  end

  def destroy
    @task = Task.find(params[:id])

    @task.destroy 
    if @task.destroyed?
      render json: { status: 200, body: "Task deleted successfully." }
    else 
      render json: { status: 400, body: "Task deletion failed: #{@task.errors.full_messages.join(', ')}" }
    end
  end

  def assign
    @user = User.find(params[:user_id])
    @task = Task.find(params[:id])
    @user.tasks.create!(@task)
    if @user.tasks.save 
      render json: { status: 200, body: "Task assigned to #{@user.name} successfully."}
    else 
      render json: { status: 400, body: "Task assignment for #{@user.name} failed: #{@task.errors.full_messages.join(', ')}" }
    end
  end

  def by_status
    @tasks = Task.where(status: params[:status])
    if @tasks.empty?
      render json: { status: 404, body: "No tasks found with status of #{params[:status]}" }
    else 
      render json: { status: 200, body: @tasks }
    end
  end

  def by_user
    @user = User.find(params[:user_id])

    if @user
      render json: { status: 200, body: @user.tasks }
    else 
      render json: { status: 404, body: "User not found." }
    end
  end

  def set_progress
    @task = Task.find(params[:id])
    @task.progress = params[:progress]
    if @task.progress > 100 || @task.progress < 0
      render json: { status: 400, body: 'Unable to accept progress values less than 0% or more than 100%' }
    else  
      render json: { status: 200, body: @task.progress }
    end
  end

  def overdue
    overdue_tasks = []
    @tasks = Task.all
    today = Date.current

    @tasks.map do |task|
      if tasks.date_due < today
        overdue_tasks << task 
      end
    end

    if overdue_tasks.empty?
      render json: { status: 404, body: 'No overdue tasks found.' }
    else
      render json: { status: 200, body: overdue_tasks }
    end
  end

  def completed
    completed_tasks = []
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    
    @tasks_in_date_range = Task.where(date_completed: (@start_date..@end_date))
    @completed_tasks_in_date_range = @tasks_in_date_range.where(status: "Completed")

    if @completed_tasks_in_date_range.empty?
      render json: { status: 404, body: 'No completed task exist in date range.'}
    else
      render json: { status: 200, body: @completed_tasks_in_date_range }
    end
  end

  def statistics
    @total_tasks = Task.all.count
    @completed_tasks = Task.where(status: "Completed").count
    completed_task_percentage = @completed_tasks.to_f / @total_tasks * 100 
    if @total_tasks.empty? || @completed_tasks.empty?
      render json: { status: 404, body: 'No statistics avaiable.'}
    else
      render json: { status: 200, body: "#{completed_task_percentage}%" }
    end
  end

  def prioritized_task_queue
    p_queue = []
    high = []
    medium = []
    low = []

    @tasks = Task.all
    @tasks.map do |task|
      if task.priority === 'High'
        high << task
      end

      if task.priority === 'Medium'
        medium << task
      end 

      if task.priority === 'Low'
        low << task
      end
      p_queue = high.sort_by! { |task| task.date_due } + medium.sorted! + low.sorted!
      prioritized_tasks = p_queue.sort_by { |hash| (hash[:date] - Time.now).abs }

      if prioritized_tasks.empty? 
        render json: { status: 404, body: 'No prioritized tasks found.'}
      else 
        render json: { status: 200, body: prioritized_tasks }
      end
    end
  end

  private 

  def user 
    @user = User.find(params[:user_id])
  end
end
