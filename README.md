# Tasks Controller Documentation

Introduction:
The TasksController manages tasks within the application, providing endpoints for tasks. It also includes endpoints for assigning tasks to users, filtering tasks based on various criteria & generating task statistics.

Endpoints:

GET /api/v1/tasks
- Description: Retrieves all tasks.
- Response:
  - Status Code: 200 (OK)
  - Body: JSON array of tasks

POST /api/v1/tasks
- Description: Creates a new task.
- Parameters:
  - title (string): Title of the task
  - description (string): Description of the task
  - date_due (date): Due date of the task
  - date_completed (date, optional): Date the task was completed
  - status (string): Status of the task (e.g., "Pending", "Completed")
  - progress (integer): Progress of the task (0-100)
  - priority_level (string): Priority level of the task (e.g., "High", "Medium", "Low")
- Response:
  - Status Code: 200 (OK) if successful, 400 (Bad Request) if unsuccessful
  - Body: JSON object indicating success or failure

PUT /api/v1/tasks/:id
- Description: Updates an existing task.
- Parameters: Same as POST /api/v1/tasks
- Response:
  - Status Code: 200 (OK) if successful, 400 (Bad Request) if unsuccessful
  - Body: JSON object indicating success or failure

DELETE /api/v1/tasks/:id
- Description: Deletes a task.
- Response:
  - Status Code: 200 (OK) if successful, 400 (Bad Request) if unsuccessful
  - Body: JSON object indicating success or failure

POST /api/v1/tasks/:id/assign
- Description: Assigns a task to a user.
- Parameters:
  - user_id (integer): ID of the user to assign the task to
- Response:
  - Status Code: 200 (OK) if successful, 400 (Bad Request) if unsuccessful
  - Body: JSON object indicating success or failure

GET /api/v1/tasks/by_status
- Description: Retrieves tasks by status.
- Parameters:
  - status (string): Status of the tasks to retrieve
- Response:
  - Status Code: 200 (OK) if successful, 404 (Not Found) if no tasks found
  - Body: JSON array of tasks or error message

GET /api/v1/tasks/by_user
- Description: Retrieves tasks assigned to a specific user.
- Parameters:
  - user_id (integer): ID of the user
- Response:
  - Status Code: 200 (OK) if successful, 404 (Not Found) if user not found
  - Body: JSON array of tasks or error message

PUT /api/v1/tasks/:id/set_progress
- Description: Updates the progress of a task.
- Parameters:
  - progress (integer): Progress value (0-100)
- Response:
  - Status Code: 200 (OK) if successful, 400 (Bad Request) if progress value is invalid
  - Body: JSON object indicating success or failure

GET /api/v1/tasks/overdue
- Description: Retrieves overdue tasks.
- Response:
  - Status Code: 200 (OK) if successful, 404 (Not Found) if no overdue tasks found
  - Body: JSON array of overdue tasks or error message

GET /api/v1/tasks/completed
- Description: Retrieves completed tasks within a date range.
- Parameters:
  - start_date (date): Start date of the range
  - end_date (date): End date of the range
- Response:
  - Status Code: 200 (OK) if successful, 404 (Not Found) if no completed tasks found in the date range
  - Body: JSON array of completed tasks or error message

GET /api/v1/tasks/statistics
- Description: Retrieves task statistics.
- Response:
  - Status Code: 200 (OK) if successful, 404 (Not Found) if no statistics available
  - Body: JSON object containing task statistics or error message

GET /api/v1/tasks/prioritized_task_queue
- Description: Retrieves a prioritized task queue.
- Response:
  - Status Code: 200 (OK) if successful, 404 (Not Found) if no prioritized tasks found
  - Body: JSON array of prioritized tasks or error message

Private Methods:

user
- Description: Retrieves the user associated with the specified ID.
- Parameters:
  - user_id (integer): ID of the user
- Returns: User object