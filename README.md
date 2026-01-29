# Domain Join Automation Script - Complete Usage Guide

Purpose: Automates the process of renaming Windows 11 Pro computers and joining them to the student.vpa.ac.lk Active Directory domain.
What it does:

- Prompts for a computer number (e.g., 01, 02, 12)
- Creates standardized computer names (VA-ITL2-##N format)
- Joins the computer to the domain with the new name
- Automatically restarts to apply changes

## 📋 Table of Contents
1. [Quick Start](#quick-start)
2. [How to Use](#how-to-use)
3. [Customizing the Script](#customizing-the-script)
4. [Expected Results](#expected-results)
5. [Troubleshooting](#troubleshooting)

---

## 🚀 Quick Start

### Prerequisites (IMPORTANT!)
**Before running Domain-Join.bat, you MUST configure DNS first!**

#### Step 0: Configure DNS
Run `Setup-DNS.bat` as Administrator to configure DNS settings.

OR manually set:
- DNS Server: 192.168.0.10
- DNS Suffix: company.ac.lk

### Main Process

#### Step 1: Run Domain-Join.bat
1. Right-click `Domain-Join.bat`
2. Select "Run as administrator"

#### Step 2: Enter Computer Number
- Type the number (e.g., `01`, `02`, `12`, `004`)
- Script will create name: VA-ITL2-##N

#### Step 3: Confirm
- Review the settings
- Type `Y` to continue

#### Step 4: Wait for Restart
- Computer restarts automatically after 15 seconds
- After restart, everything is applied:
  - ✅ Computer name: VA-ITL2-01N
  - ✅ Full name: VA-ITL2-01N.company.ac.lk
  - ✅ Domain: company.ac.lk

---

## 🔧 Customizing the Script

### How to Change Default Variables

You can customize the script to match your organization's settings by editing the batch file.

#### 1. Open the Script for Editing

**Method 1: Using Notepad**
1. Right-click `Domain-Join.bat`
2. Select "Edit" or "Open with" → "Notepad"

**Method 2: Using Command**
```cmd
notepad Domain-Join.bat
```

---

#### 2. Change Domain Name

**Find this line:**
```batch
echo $domain = 'company.ac.lk' > %temp%\domain-join-temp.ps1
```

**Change to your domain:**
```batch
echo $domain = 'yourcompany.com' > %temp%\domain-join-temp.ps1
```

**Examples:**
- For domain `office.local`: `echo $domain = 'office.local' > %temp%\domain-join-temp.ps1`
- For domain `corp.company.net`: `echo $domain = 'corp.company.net' > %temp%\domain-join-temp.ps1`

---

#### 3. Change Domain Admin Account

**Find these lines:**
```batch
echo $domainUser = 'ittreainee@company.ac.lk' >> %temp%\domain-join-temp.ps1
echo $domainPassword = '12345' >> %temp%\domain-join-temp.ps1
```

**Change to your admin credentials:**
```batch
echo $domainUser = 'administrator@yourcompany.com' >> %temp%\domain-join-temp.ps1
echo $domainPassword = 'YourSecurePassword' >> %temp%\domain-join-temp.ps1
```

**Examples:**
- Username: `echo $domainUser = 'admin@corp.local' >> %temp%\domain-join-temp.ps1`
- Password: `echo $domainPassword = 'P@ssw0rd123' >> %temp%\domain-join-temp.ps1`

⚠️ **Security Warning:** The password is stored in plain text. For better security, consider using a more secure method or prompting for password.

---

#### 4. Change Computer Name Format

**Find this line:**
```batch
echo $newComputerName = 'VA-ITL2-' + $computerNumber + 'N' >> %temp%\domain-join-temp.ps1
```

**Change the naming format:**

**Example 1: Different prefix**
```batch
echo $newComputerName = 'OFFICE-PC-' + $computerNumber >> %temp%\domain-join-temp.ps1
```
- Input: `01` → Output: `OFFICE-PC-01`

**Example 2: Different suffix**
```batch
echo $newComputerName = 'LAB-' + $computerNumber + '-DESK' >> %temp%\domain-join-temp.ps1
```
- Input: `01` → Output: `LAB-01-DESK`

**Example 3: Department codes**
```batch
echo $newComputerName = 'IT-WKS-' + $computerNumber >> %temp%\domain-join-temp.ps1
```
- Input: `001` → Output: `IT-WKS-001`

**Example 4: No suffix**
```batch
echo $newComputerName = 'COMPUTER-' + $computerNumber >> %temp%\domain-join-temp.ps1
```
- Input: `12` → Output: `COMPUTER-12`

---

#### 5. Change Display Messages

**Find these lines to customize the header:**
```batch
echo    Domain Join Tool Launcher
echo    Domain: company.ac.lk
```

**Change to:**
```batch
echo    YourCompany Domain Join Tool
echo    Domain: yourcompany.com
```

**Find the format message:**
```batch
echo Write-Host '    Format: VA-ITL2-##N (e.g., VA-ITL2-01N, VA-ITL2-12N)' -ForegroundColor Gray >> %temp%\domain-join-temp.ps1
```

**Change to match your format:**
```batch
echo Write-Host '    Format: OFFICE-PC-## (e.g., OFFICE-PC-01, OFFICE-PC-12)' -ForegroundColor Gray >> %temp%\domain-join-temp.ps1
```

---

### 📝 Complete Customization Example

**Scenario:** Your company is "TechCorp" with domain `techcorp.local`

**Before:**
```batch
echo $domain = 'company.ac.lk' > %temp%\domain-join-temp.ps1
echo $domainUser = 'ittreainee@company.ac.lk' >> %temp%\domain-join-temp.ps1
echo $domainPassword = '12345' >> %temp%\domain-join-temp.ps1
echo $newComputerName = 'VA-ITL2-' + $computerNumber + 'N' >> %temp%\domain-join-temp.ps1
```

**After:**
```batch
echo $domain = 'techcorp.local' > %temp%\domain-join-temp.ps1
echo $domainUser = 'domainadmin@techcorp.local' >> %temp%\domain-join-temp.ps1
echo $domainPassword = 'SecurePass2024!' >> %temp%\domain-join-temp.ps1
echo $newComputerName = 'TC-DESK-' + $computerNumber >> %temp%\domain-join-temp.ps1
```

**Result:** Input `05` creates computer name `TC-DESK-05` in domain `techcorp.local`

---

### 🎨 Advanced Customizations

#### Add Location Prefix Dynamically

You can modify the script to ask for location code:

**Add this before computer number input:**
```batch
echo $location = Read-Host 'Enter location code (e.g., NYC, LAX, LON)' >> %temp%\domain-join-temp.ps1
echo $newComputerName = $location + '-PC-' + $computerNumber >> %temp%\domain-join-temp.ps1
```

**Usage:**
- Enter location: `NYC`
- Enter number: `01`
- Result: `NYC-PC-01`

---

#### Add Department Code

```batch
echo $dept = Read-Host 'Enter department (IT, HR, FIN)' >> %temp%\domain-join-temp.ps1
echo $newComputerName = $dept + '-WKS-' + $computerNumber >> %temp%\domain-join-temp.ps1
```

**Usage:**
- Enter department: `IT`
- Enter number: `05`
- Result: `IT-WKS-05`

---

#### Change Restart Delay

**Find this line:**
```batch
echo Start-Sleep -Seconds 15 >> %temp%\domain-join-temp.ps1
```

**Change delay time:**
```batch
echo Start-Sleep -Seconds 30 >> %temp%\domain-join-temp.ps1
```
- 30 seconds instead of 15
- Or 60 for 1 minute
- Or 5 for quick restart

---

### 💾 Save Your Changes

After editing:
1. **File** → **Save** (or press `Ctrl+S`)
2. Close Notepad
3. Run the modified script

⚠️ **Important:** Save the file with `.bat` extension, not `.txt`

---

### 📋 Quick Reference - Common Customizations

| What to Change | Find This | Change To (Example) |
|----------------|-----------|---------------------|
| Domain | `company.ac.lk` | `yourcompany.com` |
| Admin User | `ittreainee@company.ac.lk` | `admin@yourcompany.com` |
| Password | `12345` | `YourPassword123` |
| Computer Prefix | `VA-ITL2-` | `OFFICE-PC-` |
| Computer Suffix | `+ 'N'` | (remove or change) |
| Restart Delay | `Start-Sleep -Seconds 15` | `Start-Sleep -Seconds 30` |

---

### ⚠️ Important Notes When Customizing

1. **Computer Name Limits:**
   - Maximum 15 characters
   - No spaces or special characters (except hyphen `-`)
   - Letters, numbers, and hyphens only
   - Cannot be all numbers

2. **Domain Name:**
   - Must be fully qualified (e.g., `domain.local` not just `domain`)
   - Must match your actual Active Directory domain

3. **Credentials:**
   - User must have permission to join computers to domain
   - Usually needs to be domain admin or delegated account
   - Password is case-sensitive

4. **Testing:**
   - Test on one computer first before rolling out
   - Verify all settings are correct
   - Check computer name format meets your standards

---

### 🔄 Reverting Changes

If you make a mistake, you can:

1. **Re-download** the original script
2. **Use version control** (save backup before editing)
3. **Copy original** before customizing

**Recommended:** Keep a backup copy of the original script:
```
Domain-Join-ORIGINAL.bat (backup)
Domain-Join.bat (customized)
```

---

## 📊 Expected Results

### Before Running Script:
- Computer Name: DESKTOP-1E0B55C (or similar)
- Workgroup: WORKGROUP
- Domain: None

### After Running Script (After Restart):
- Computer Name: VA-ITL2-01N (or your custom format)
- Full Computer Name: VA-ITL2-01N.company.ac.lk
- Domain: company.ac.lk
- DNS Suffix: company.ac.lk

---

## 🔍 How to Verify After Restart

Press `Windows + R`, type `sysdm.cpl`, press Enter

You should see:
- **Computer name:** VA-ITL2-01N
- **Full computer name:** VA-ITL2-01N.company.ac.lk
- **Domain:** company.ac.lk

Or run this in PowerShell:
```powershell
Get-ComputerInfo | Select-Object CsName, CsDomain, CsDNSHostName
```

---

## 🆘 Troubleshooting

### Error: "Domain could not be contacted"
**Solution:** DNS not configured correctly
- Run `Setup-DNS.bat` first
- Or check TROUBLESHOOTING.md for manual DNS setup

### Error: "Computer account already exists"
**Solution:** Ask IT admin to:
- Delete old computer account from Active Directory
- Or reset the computer account password

### Error: "Access is denied"
**Solution:** 
- Make sure you ran as Administrator
- Verify domain credentials are correct

### Computer name doesn't meet requirements
**Solution:**
- Check your custom format
- Ensure total length is 15 characters or less
- Remove any invalid characters

---

## 💡 Tips

- Always test DNS connectivity first: `ping 192.168.0.10`
- Use leading zeros for single digits: `01` not `1`
- Keep a list of which numbers you've used
- If join fails, computer name won't change (safe!)
- Document your customizations for future reference
- Test customized script on one computer before mass deployment

---

## 📞 Support

For issues or questions:
1. Check TROUBLESHOOTING.md
2. Verify your customizations are correct
3. Test DNS connectivity
4. Contact : viduradewantha@gmail.com

---

## 📝 Customization Checklist

Before deploying your customized script:

- [ ] Domain name is correct
- [ ] Admin credentials are valid and have permissions
- [ ] Computer naming format follows company standards
- [ ] Computer name length is 15 characters or less
- [ ] Tested on one computer successfully
- [ ] DNS settings are documented
- [ ] Backup of original script is saved
- [ ] Custom script is documented for other IT staff
