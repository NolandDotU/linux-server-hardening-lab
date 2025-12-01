# Server Hardening Documentation

## 1. User & Access Management
Standard security practices mandate the disablement of the root account for remote access to enforce accountability and prevent dicitonary attack on kwon usernames.

### Configurations Applied:
- **Root Login:** `DIsabled`
- **Authentication:** Public Key Authenticaition (Recommended) / Strong Password Policy.

**Modifications in `/etc/ssh/sshd_config`:**
```bash
PermitRootLogin no
PasswordAuthentication yes # changed to 'no' after key exchange setup
MaxAuthTries 3
