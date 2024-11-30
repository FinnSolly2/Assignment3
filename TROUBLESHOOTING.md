# Troubleshooting Documentation

## Deployment and Implementation Issues Log

| Problem | Cause | Solution |
|---------|--------|----------|
| Docker Compose Configuration Not Found | Running commands from incorrect directory | 1. Check current directory location<br>2. Navigate to project root: `cd /path/to/project`<br>3. Verify docker-compose.yml exists: `ls docker-compose.yml`<br>4. Run docker-compose commands from root directory |
| Docker Desktop Connection Error | Docker Desktop not running or improperly installed | 1. Check Docker Desktop installation<br>2. Start Docker Desktop application<br>3. Wait for whale icon to stop animating<br>4. Verify Docker is running: `docker info`<br>5. If issues persist, try:<br>   - Restart Docker Desktop<br>   - Restart computer<br>   - Reinstall Docker Desktop |
| GitHub Repository Access Error | Attempting to clone repository without proper authentication | 1. For public repos:<br>   ```dockerfile RUN git clone https://github.com/user/repo.git .```<br>2. For private repos:<br>   - Add to docker-compose.yml:<br>     ```yaml args: - GITHUB_TOKEN=${GITHUB_TOKEN}```<br>   - Modify Dockerfile:<br>     ```dockerfile ARG GITHUB_TOKEN RUN git clone https://${GITHUB_TOKEN}@github.com/user/repo.git .``` |
| FromAsCasing Warning | Inconsistent casing in Dockerfile syntax | 1. Standardize Dockerfile commands:<br>   ```dockerfile FROM python:3.9-slim AS production```<br>2. Review all Dockerfile commands for consistent casing<br>3. Follow Docker best practices for syntax |
| Flask/Werkzeug Compatibility Error | Version mismatch between Flask and Werkzeug | 1. Create requirements.txt:<br>```Flask==2.0.1 Flask-SQLAlchemy==2.5.1 SQLAlchemy==1.4.23 Werkzeug==2.0.3```<br>2. Add to Dockerfile:<br>```dockerfile COPY requirements.txt . RUN pip install -r requirements.txt```<br>3. If needed, uninstall current versions:<br>```RUN pip uninstall -y flask werkzeug``` |
| Database Initialization Error | Wrong database initialization approach in init_db.py | 1. Update init_db.py:<br>```python from app import app, db with app.app_context(): db.create_all() print("Tables created!")```<br>2. Add to docker-compose.yml:<br>```yaml environment: - DATABASE_URL=postgresql://user:pass@db:5432/dbname```<br>3. Create initialization script:<br>```bash #!/bin/bash python init_db.py python app.py``` |
| HTTP 405 Method Not Allowed | Incorrect template format and form submission setup | 1. Update form in add.html:<br>```html <form action="{{ url_for('add_book') }}" method="POST"> <input name="title" required> <input name="author" required> <button type="submit">Add</button> </form>```<br>2. Update route in app.py:<br>```python @app.route('/add', methods=['GET', 'POST'])```<br>3. Handle both GET and POST methods in route |
| Static Files 404 Error | Missing static directory and improper URL routing | 1. Create directory structure:<br>```/project /static /css style.css /templates```<br>2. Update HTML templates:<br>```html <link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}">```<br>3. Create __init__.py for package recognition |
| Database Connection Issues | Environment variable mismatch | 1. In docker-compose.yml:<br>```yaml environment: - DATABASE_URL=postgresql://postgres:postgres@db:5432/postgres```<br>2. In app.py:<br>```python app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL')```<br>3. Add wait-for-db script:<br>```bash while ! nc -z db 5432; do sleep 0.1; done``` |

## Common Issues by Category

### Docker Setup Issues
- Ensure Docker Desktop is running
- Run commands from project root directory
- Verify proper installation and configuration
- Handle service initialization properly

### Authentication Issues
- Use public repositories when possible
- Implement secure credential management
- Document authentication requirements
- Consider multiple access methods

### Flask Application Issues
- Match versions between Flask and its dependencies
- Properly structure templates and static files
- Use correct HTTP methods in routes
- Initialize database correctly

