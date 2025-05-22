# Exact Deployment Steps for Production Server

## Prerequisites
- Docker and Docker Compose installed on the server
- Git installed on the server
- Port 3006 available on the server
- Basic firewall knowledge (to open port 3006 if needed)

## Deployment Steps (Linux Server)

1. **Clone the repository with the docker branch**:
   ```bash
   git clone https://github.com/bashhh89/sg22.git -b docker
   cd sg22
   ```

2. **Make the setup script executable**:
   ```bash
   chmod +x docker-setup.sh
   ```

3. **Run the setup script**:
   ```bash
   ./docker-setup.sh
   ```

4. **Verify the application is running**:
   - Open a web browser and navigate to: `http://YOUR_SERVER_IP:3006`
   - If you can't access it, ensure port 3006 is open in your firewall:
     ```bash
     sudo ufw allow 3006/tcp
     sudo ufw status
     ```

## Deployment Steps (Windows Server)

1. **Clone the repository with the docker branch**:
   ```powershell
   git clone https://github.com/bashhh89/sg22.git -b docker
   cd sg22
   ```

2. **Run the setup script**:
   ```powershell
   .\docker-setup.ps1
   ```

3. **Verify the application is running**:
   - Open a web browser and navigate to: `http://YOUR_SERVER_IP:3006`
   - If you can't access it, ensure port 3006 is allowed in Windows Firewall

## Troubleshooting

If you encounter any issues during deployment:

1. **Check Docker container logs**:
   ```bash
   docker-compose logs
   ```

2. **Verify Docker container is running**:
   ```bash
   docker ps
   ```

3. **Restart the container**:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

4. **Check if port 3006 is in use**:
   - Linux: `sudo lsof -i :3006`
   - Windows: `netstat -ano | findstr :3006`

5. **Verify Docker is running**:
   ```bash
   docker info
   ```

## Updating the Application

To update the application when new code is pushed:

1. **Pull the latest changes**:
   ```bash
   git pull origin docker
   ```

2. **Rebuild and restart the container**:
   ```bash
   docker-compose down
   docker-compose up -d --build
   ``` 