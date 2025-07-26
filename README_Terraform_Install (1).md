# 🌍 Terraform Installation Guide

This guide explains how to install **Terraform** on:

- ✅ Amazon EC2 (Ubuntu)
- ✅ Windows 10/11

---

## 🚀 1. Installing Terraform on EC2 (Ubuntu)

### 🧾 Steps:

```bash
# Update and install prerequisites
sudo apt update -y
sudo apt install -y gnupg software-properties-common curl unzip

# Add the HashiCorp GPG key
curl -fsSL https://apt.releases.hashicorp.com/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and install Terraform
sudo apt update && sudo apt install terraform -y

# Verify installation
terraform -version
```

---

## 🪟 2. Installing Terraform on Windows

### 🧾 Steps:

1. Go to the Terraform download page:  
   👉 https://developer.hashicorp.com/terraform/downloads

2. Download the **Windows (amd64)** `.zip` file.

3. Extract it to a folder like `C:\Terraform`.

4. Add the folder to the system `Path`:
   - Open **Start** → Search **"Environment Variables"**
   - Click **"Edit the system environment variables"**
   - In the **System Properties** window, click **Environment Variables**
   - Select **Path** → Edit → Add `C:\Terraform`
   - Click OK on all windows

5. Open a new **Command Prompt** or **PowerShell**, and verify:

```powershell
terraform -version
```

---

## 🧠 Notes

- Ensure you have **admin access** for installing and editing environment variables.
- On EC2, ensure you have internet access or a NAT Gateway to fetch packages.

---

## ✅ Done!

You now have **Terraform** installed and ready to use on both **Ubuntu (EC2)** and **Windows** machines.

---