# Real Bank Frontend

Static responsive frontend for the MuleSoft real-bank-api.

Features:
- Dashboard and account summary
- Account search and ACTIVE/INACTIVE filtering
- Account details
- Create account
- Deposit and withdraw
- Transaction / mini-statement view
- Banking assistant
- Mobile responsive UI

Default API base:
http://localhost:8081/api

For a deployed API, set this in the browser console before reloading:
localStorage.setItem("realBankApiBase","https://YOUR-HOST/api")

Deploy the frontend folder as a static site. For Render Static Site use root directory frontend, no build command, and publish directory .