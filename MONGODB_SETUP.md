# MongoDB Installation Guide for Windows

## Option 1: MongoDB Community Edition (Local)

### Download and Install

1. Download MongoDB Community Server from:
   https://www.mongodb.com/try/download/community

2. Choose:
   - Version: Latest (7.0 or higher)
   - Platform: Windows
   - Package: MSI

3. Run the installer:
   - Choose "Complete" installation
   - Install MongoDB as a Service (recommended)
   - Install MongoDB Compass (optional GUI)

4. Add MongoDB to PATH:
   - Default location: `C:\Program Files\MongoDB\Server\7.0\bin`
   - Add to System Environment Variables

5. Verify installation:
```powershell
mongod --version
```

### Create Data Directory (Required)

MongoDB needs a data directory to store databases. Create it first:

```powershell
# Create the data directory
mkdir C:\data\db
```

### Start MongoDB Service

**Option A: As a Windows Service (if installed as service)**
```powershell
# Start MongoDB service
net start MongoDB
```

**Option B: Manual Start (if not installed as service)**
```powershell
# Start MongoDB manually with the data directory
mongod --dbpath="C:\data\db"

# Keep this terminal open - MongoDB will run here
# Open a new terminal for your Node.js application
```

## Option 2: MongoDB Atlas (Cloud - Easiest)

1. Go to https://www.mongodb.com/cloud/atlas/register
2. Create a free account
3. Create a free M0 cluster
4. Create a database user (username/password)
5. Whitelist your IP (or use 0.0.0.0/0 for testing)
6. Get connection string from "Connect" button
7. Update `.env` file:

```
MONGO_URI=mongodb+srv://username:password@cluster0.xxxxx.mongodb.net/auth_system?retryWrites=true&w=majority
```

## Option 3: Docker (If you have Docker installed)

```powershell
docker run -d -p 27017:27017 --name mongodb mongo:latest
```

Then use:
```
MONGO_URI=mongodb://localhost:27017/auth_system
```

## Troubleshooting

### MongoDB not recognized
- Make sure MongoDB bin folder is in PATH
- Restart PowerShell after adding to PATH

### Connection refused
- Check if MongoDB service is running
- Verify port 27017 is not blocked

### Authentication failed
- Check username/password in connection string
- Verify database user permissions
