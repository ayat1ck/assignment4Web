# Authentication System

A secure authentication system built with Node.js, Express, MongoDB, and bcrypt.

## Features

- User registration with password hashing
- Secure login with session management
- Protected routes requiring authentication
- Modern, responsive UI with dark theme
- Session-based authentication with cookies

## Prerequisites

- Node.js installed
- MongoDB installed and running

## Installation

1. Install dependencies:
```bash
npm install
```

2. Configure environment variables in `.env`:
```
PORT=3000
MONGO_URI=mongodb://localhost:27017/auth_system
SESSION_SECRET=your_secret_key_here_change_in_production
```

3. Start MongoDB (if not already running):
```bash
mongod
```

4. Start the server:
```bash
npm start
```

5. Open your browser and navigate to:
```
http://localhost:3000
```

## API Endpoints

### POST /api/auth/register
Register a new user
- Body: `{ name, email, password }`
- Returns: User object (without password)

### POST /api/auth/login
Login with email and password
- Body: `{ email, password }`
- Returns: User object and creates session

### POST /api/auth/logout
Logout and destroy session
- Returns: Success message

### GET /api/auth/profile
Get user profile (protected route)
- Requires: Valid session
- Returns: User profile data

## Project Structure

```
assignment4/
├── config/
│   └── db.js              # Database connection
├── models/
│   └── User.js            # User model with bcrypt
├── routes/
│   └── authRoutes.js      # Authentication routes
├── public/
│   ├── index.html         # Login page
│   ├── register.html      # Registration page
│   ├── profile.html       # Profile page
│   └── styles.css         # Styling
├── .env                   # Environment variables
├── server.js              # Main server file
└── package.json
```

## Testing with Postman

1. **Register**: POST to `http://localhost:3000/api/auth/register`
2. **Login**: POST to `http://localhost:3000/api/auth/login`
3. **Profile**: GET to `http://localhost:3000/api/auth/profile`
4. **Logout**: POST to `http://localhost:3000/api/auth/logout`

## Security Features

- Passwords hashed with bcrypt (10 salt rounds)
- Session cookies with httpOnly flag
- Session expiration (1 hour)
- Email uniqueness validation
- Input validation on all routes
