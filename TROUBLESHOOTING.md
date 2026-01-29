# Domain Join Troubleshooting Guide

## 🔴 Error: "The specified domain either does not exist or could not be contacted"

This error means the computer cannot reach the domain controller. Follow these steps:

---

## Step 1: Configure DNS First ⚙️

**IMPORTANT:** You MUST configure DNS before joining the domain!

### Option A: Use the Setup-DNS.bat script (Easiest)
1. Run `Setup-DNS.bat` as Administrator
2. Press Enter to use default DNS (192.168.0.10) or enter your DNS server
3. Verify all tests pass
4. Then run `Domain-Join.bat`

### Option B: Configure DNS Manually
1. Open **Settings** → **Network & Internet** → **Ethernet** or **Wi-Fi**
2. Click **Properties**
3. Click **Edit** next to "IP assignment"
4. Select **Manual**
5. Enable **IPv4**
6. Enter:
   - **DNS server:** `192.168.0.10`
   - Click **Save**

7. In the same network properties:
   - Scroll to **DNS suffix** section
   - Set DNS suffix to: `company.ac.lk`

---

## Step 2: Test DNS Connectivity 🔍

Open Command Prompt and test:

```cmd
# Test 1: Ping DNS server
ping 192.168.0.10

# Test 2: Resolve domain name
nslookup company.ac.lk

# Test 3: Check current DNS settings
ipconfig /all
```

### What to Look For:
✅ **Ping successful:** DNS server is reachable  
✅ **nslookup returns IP addresses:** Domain is resolvable  
✅ **DNS Suffix shows:** company.ac.lk  

❌ If any test fails, DNS is not configured correctly

---

## Step 3: Verify Network Configuration 🌐

### Check Your Network Settings:

**Open PowerShell as Administrator:**
```powershell
Get-NetIPConfiguration
Get-DnsClientServerAddress -AddressFamily IPv4
```

**You should see:**
- IP Address in range: 192.168.130.x
- DNS Server: 192.168.0.10
- DNS Suffix: company.ac.lk

---

## Common Issues & Solutions

### Issue 1: DNS Server Not Responding
**Symptoms:**
- Cannot ping 192.168.0.10
- nslookup fails

**Solutions:**
1. Check network cable is connected
2. Verify switch/router is powered on
3. Ask IT to verify DNS server (192.168.0.10) is running
4. Try pinging gateway: `ping 192.168.130.1`

---

### Issue 2: Domain Cannot Be Resolved
**Symptoms:**
- DNS server responds to ping
- But nslookup company.ac.lk fails

**Solutions:**
1. DNS server may not have the domain configured
2. Contact your IT administrator to verify DNS zone exists
3. Check if DNS server IP is correct (should be 192.168.0.10)

---

### Issue 3: Wrong DNS Configured
**Symptoms:**
- Domain join fails
- DNS points to wrong server (like 8.8.8.8)

**Solution:**
Run `Setup-DNS.bat` to configure correct DNS settings

---

### Issue 4: Computer Already in Domain
**Symptoms:**
- Error about computer account already exists

**Solution:**
Ask IT administrator to:
1. Remove old computer account from Active Directory
2. Or reset the computer account password
3. Then try joining again

---

### Issue 5: Firewall Blocking
**Symptoms:**
- DNS works but domain join fails
- Network seems fine

**Solution:**
1. Temporarily disable Windows Firewall:
   ```cmd
   netsh advfirewall set allprofiles state off
   ```
2. Try joining domain
3. Re-enable firewall after:
   ```cmd
   netsh advfirewall set allprofiles state on
   ```

---

## Correct Process Order 📝

**ALWAYS follow this order:**

1. ✅ Connect network cable
2. ✅ Configure IP address (if using static IP)
3. ✅ **Configure DNS** (use Setup-DNS.bat or manual)
4. ✅ Test DNS connectivity (ping + nslookup)
5. ✅ Run Domain-Join.bat
6. ✅ Computer restarts and joins domain

---

## Quick Check Commands 🔧

**Check current computer name:**
```cmd
hostname
```

**Check if joined to domain:**
```powershell
(Get-WmiObject Win32_ComputerSystem).Domain
```

**Check DNS configuration:**
```cmd
ipconfig /all | findstr DNS
```

**Flush DNS cache:**
```cmd
ipconfig /flushdns
```

**Test domain controller connectivity:**
```cmd
nltest /dsgetdc:company.ac.lk
```

---

## Expected Final Configuration ✅

After successful domain join:

- **Computer Name:** VA-ITL2-01N (example)
- **Full Computer Name:** VA-ITL2-01N.company.ac.lk
- **Domain:** company.ac.lk
- **DNS Server:** 192.168.0.10
- **DNS Suffix:** company.ac.lk

---

## Still Not Working? 🆘

Contact your IT administrator with:
1. Screenshot of error message
2. Output of: `ipconfig /all`
3. Output of: `nslookup company.ac.lk`
4. Computer number you're trying to use

---

## Additional Notes 📌

- Domain join requires the computer to be renamed first
- Restart is required after renaming
- Domain credentials must be correct: ittreainee@company.ac.lk
- Domain credentials must be correct: ittreainee@company.ac.lk
- Make sure you're on the correct network segment (192.168.130.x)
