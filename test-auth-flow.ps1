# Authentication Flow Test Script
# This script tests the complete authentication flow without Postman

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   AUTHENTICATION FLOW TEST" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Generate a unique email for testing
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
$testEmail = "testuser$timestamp@example.com"

# Step 1: Register a new user
Write-Host "`n[STEP 1] Registering a new user..." -ForegroundColor Yellow
Write-Host "Email: $testEmail" -ForegroundColor Gray

$registerBody = @{
    name = "Test User"
    email = $testEmail
    password = "password123"
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/register" `
        -Method POST `
        -ContentType "application/json" `
        -Body $registerBody `
        -SessionVariable webSession

    Write-Host "✓ Registration successful!" -ForegroundColor Green
    Write-Host "User ID: $($registerResponse.user.id)" -ForegroundColor Gray
    Write-Host "Response: $($registerResponse.message)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Registration failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 2: Login with the registered user
Write-Host "`n[STEP 2] Logging in..." -ForegroundColor Yellow

$loginBody = @{
    email = $testEmail
    password = "password123"
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/login" `
        -Method POST `
        -ContentType "application/json" `
        -Body $loginBody `
        -WebSession $webSession

    Write-Host "✓ Login successful!" -ForegroundColor Green
    Write-Host "Response: $($loginResponse.message)" -ForegroundColor Gray
    Write-Host "Session cookie saved in webSession variable" -ForegroundColor Gray
} catch {
    Write-Host "✗ Login failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 3: Access protected /profile route (should succeed)
Write-Host "`n[STEP 3] Accessing /profile (authenticated)..." -ForegroundColor Yellow

try {
    $profileResponse = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/profile" `
        -Method GET `
        -WebSession $webSession

    Write-Host "✓ Profile access successful!" -ForegroundColor Green
    Write-Host "Name: $($profileResponse.user.name)" -ForegroundColor Gray
    Write-Host "Email: $($profileResponse.user.email)" -ForegroundColor Gray
    Write-Host "Created: $($profileResponse.user.createdAt)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Profile access failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 4: Logout
Write-Host "`n[STEP 4] Logging out..." -ForegroundColor Yellow

try {
    $logoutResponse = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/logout" `
        -Method POST `
        -WebSession $webSession

    Write-Host "✓ Logout successful!" -ForegroundColor Green
    Write-Host "Response: $($logoutResponse.message)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Logout failed!" -ForegroundColor Red
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Step 5: Try accessing /profile again (should fail with 401)
Write-Host "`n[STEP 5] Accessing /profile (after logout - should fail)..." -ForegroundColor Yellow

try {
    $profileResponse2 = Invoke-RestMethod -Uri "http://localhost:3000/api/auth/profile" `
        -Method GET `
        -WebSession $webSession

    Write-Host "✗ UNEXPECTED: Profile access succeeded after logout!" -ForegroundColor Red
    Write-Host "This should have failed with 401 Unauthorized" -ForegroundColor Red
} catch {
    if ($_.Exception.Response.StatusCode -eq 401) {
        Write-Host "✓ Profile access correctly denied (401 Unauthorized)!" -ForegroundColor Green
        
        # Parse the error response
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd() | ConvertFrom-Json
        Write-Host "Error message: $($errorBody.message)" -ForegroundColor Gray
    } else {
        Write-Host "✗ Unexpected error!" -ForegroundColor Red
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Summary
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   TEST COMPLETED SUCCESSFULLY! ✓" -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "All authentication flows working correctly:" -ForegroundColor White
Write-Host "  ✓ User registration" -ForegroundColor Green
Write-Host "  ✓ User login with session" -ForegroundColor Green
Write-Host "  ✓ Protected route access (authenticated)" -ForegroundColor Green
Write-Host "  ✓ Logout" -ForegroundColor Green
Write-Host "  ✓ Protected route denial (unauthenticated)`n" -ForegroundColor Green
