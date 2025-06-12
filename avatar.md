To set user avatars in **Hyprland** (or any display manager or lock screen that supports avatars) on **Arch Linux**, the standard method is to place the avatar image in a location that user managers like `accountsservice` can read — typically:

```
/var/lib/AccountsService/icons/<username>
```

---

## ✅ Step-by-Step: Set User Avatar in Hyprland (Arch)

### 📸 1. **Prepare an Avatar Image**

* Make sure the image is square (e.g., 256×256) and in PNG or JPEG format.
* Let’s say you have `~/Pictures/avatar.png`.

### 🛠️ 2. **Install accountsservice (if not already)**

```bash
sudo pacman -S accountsservice
```

And **enable** its service:

```bash
sudo systemctl enable --now accounts-daemon.service
```

---

### 🧑‍💻 3. **Copy the Avatar to the Correct Location**

```bash
sudo cp ~/Pictures/avatar.png /var/lib/AccountsService/icons/$(whoami)
sudo chmod 644 /var/lib/AccountsService/icons/$(whoami)
```

---

### 📝 4. **Create/Edit the User Info File**

Edit or create this file:

```
/var/lib/AccountsService/users/<your-username>
```

Example for user `vinayak`:

```bash
sudo nano /var/lib/AccountsService/users/vinayak
```

Put this inside:

```ini
[User]
Icon=/var/lib/AccountsService/icons/vinayak
```

Make sure permissions are correct:

```bash
sudo chmod 644 /var/lib/AccountsService/users/vinayak
```

---

### 🔁 5. **Restart accounts-daemon and relog**

```bash
sudo systemctl restart accounts-daemon.service
```

Then log out and log back in.

---

### ✅ 6. **Test It**

* If using **Hyprlock**, it should pick up the avatar automatically (especially if you use `$(whoami)` in the config).
* If not showing, try using the path explicitly in your config:

  ```ini
  image {
      path = /var/lib/AccountsService/icons/your-username
      ...
  }
  ```

---

## 🧩 Bonus: For LightDM, GDM, SDDM

They also read avatars from the same `accountsservice` location.

---

Let me know if you want per-user avatars on multi-user systems, fallback defaults, or using avatars from a web URL.
