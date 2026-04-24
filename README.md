# NexaFlow — Business Management Platform

<div align="center">

![NexaFlow Banner](https://img.shields.io/badge/NexaFlow-Business%20Platform-c9a84c?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIvPg==)

[![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/HTML)
[![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/CSS)
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)

**A modern, full-featured business web platform with landing page, authentication, user dashboard, and admin panel — built with pure HTML, CSS & JavaScript.**

[Live Demo](#getting-started) · [Report Bug](issues) · [Request Feature](issues)

</div>

---

## 📸 Screenshots

| Page | Preview |
|------|---------|
| 🏠 Landing Page | Elegant hero section with stats, features & CTA |
| 🔐 Auth Page | Dual-panel login/register with Google OAuth UI |
| 📊 Dashboard | KPI cards, revenue chart, tasks & activity feed |
| 🛡️ Admin Panel | User management table, system health & audit log |

---

## ✨ Features

### 🏠 Landing Page (`/landing-page`)
- Animated hero with gradient mesh background
- Live statistics bar (users, uptime, productivity metrics)
- Feature cards with hover animations
- Sticky navigation with CTA button
- Fully responsive layout

### 🔐 User Authentication (`/auth`)
- **Sign In** with email + password validation
- **Register** with first/last name, company, email & password
- Smart routing — `admin@nexaflow.com` → Admin Panel, others → Dashboard
- Google OAuth button (UI ready)
- Two-panel layout with trust badges (SSL, SOC 2, GDPR)
- Inline success/error feedback messages

### 📊 User Dashboard (`/dashboard`)
- **4 KPI Cards** — Revenue, Projects, Team Members, Task Completion
- **Revenue Bar Chart** — dynamically rendered with vanilla JS
- **Recent Activity Feed** — payments, alerts, project updates
- **Interactive Task Manager** — click to mark tasks done/undone
- Sticky sidebar with navigation sections
- Notification bell with badge indicator

### 🛡️ Admin Panel (`/admin`)
- **System-wide KPIs** — total users, MRR, uptime, support tickets
- **Full User Management Table** — searchable, with role/status badges
- **User Actions** — Edit and Ban controls per user
- **Real-time System Health** — CPU, memory, disk with progress bars
- **Live Audit Log** — color-coded INFO / WARN / ERROR / SUCCESS entries
- Restricted access badge in topbar

---

## 📁 Project Structure

```
nexaflow-business-platform/
│
├── 📂 landing-page/
│   └── index.html          # Public marketing page
│
├── 📂 auth/
│   └── index.html          # Login & Registration
│
├── 📂 dashboard/
│   └── index.html          # User dashboard (post-login)
│
├── 📂 admin/
│   └── index.html          # Admin control panel
│
└── README.md
```

---

## 🚀 Getting Started

### Option 1 — Open Directly
No server needed. Just open any HTML file directly in your browser:

```bash
# Clone the repository
git clone https://github.com/your-username/nexaflow-business-platform.git

# Navigate to the project
cd nexaflow-business-platform

# Open the landing page
open landing-page/index.html       # macOS
start landing-page/index.html      # Windows
xdg-open landing-page/index.html   # Linux
```

### Option 2 — Local Dev Server (Recommended)

**Using Python:**
```bash
cd nexaflow-business-platform
python3 -m http.server 8080
# Visit: http://localhost:8080/landing-page/
```

**Using Node.js (npx):**
```bash
npx serve .
# Visit the URL shown in terminal
```

**Using VS Code:**
Install the [Live Server](https://marketplace.visualstudio.com/items?itemName=ritwickdey.LiveServer) extension, right-click `landing-page/index.html` → **Open with Live Server**.

---

## 🔑 Demo Login Credentials

| Role | Email | Password | Redirects To |
|------|-------|----------|--------------|
| **Admin** | `admin@nexaflow.com` | any | Admin Panel |
| **User** | any valid email | any (8+ chars) | Dashboard |

> ⚠️ This is a frontend-only demo. No real authentication is implemented.

---

## 🎨 Design System

| Token | Value | Usage |
|-------|-------|-------|
| `--gold` | `#c9a84c` | Primary accent, CTAs |
| `--bg` | `#0a0a0f` | Page background |
| `--surface` | `#111118` | Cards, sidebar |
| `--text` | `#f0ede8` | Body text |
| `--muted` | `#6b6870` | Secondary text |
| `--green` | `#6ccea0` | Success, positive |
| `--red` | `#e06c6c` | Error, danger, admin |

**Fonts:** [Playfair Display](https://fonts.google.com/specimen/Playfair+Display) (headings) + [DM Sans](https://fonts.google.com/specimen/DM+Sans) (body)

---

## 🛠️ Tech Stack

- **HTML5** — Semantic markup
- **CSS3** — Custom properties, Grid, Flexbox, animations
- **Vanilla JavaScript** — DOM manipulation, routing logic, chart rendering
- **Google Fonts** — Playfair Display + DM Sans
- **No frameworks. No build tools. No dependencies.**

---

## 📱 Responsive Breakpoints

| Breakpoint | Layout Change |
|------------|---------------|
| `< 1100px` | Stats grid → 2 columns, side panels stack |
| `< 768px` | Sidebar hidden, stats → 2 columns |
| `< 480px` | Single column layout throughout |

---

## 🗺️ Page Navigation Flow

```
Landing Page (/)
    │
    ├── [Get Started / Login] ──→ Auth Page (/auth)
    │                                 │
    │                    ┌────────────┴────────────┐
    │                    ▼                         ▼
    │             Admin Login               Regular Login
    │                    │                         │
    │                    ▼                         ▼
    │            Admin Panel              User Dashboard
    │            (/admin)                 (/dashboard)
    │                    │                         │
    └────────────────────┴─────── [Sign Out] ──────┘
```

---

## 🔮 Roadmap

- [ ] Backend integration (Node.js / Express / MongoDB)
- [ ] Real JWT authentication with refresh tokens
- [ ] Live chart data from API
- [ ] Dark/Light theme toggle
- [ ] Email notifications
- [ ] Export reports as PDF/CSV
- [ ] Mobile sidebar drawer
- [ ] Multi-language (i18n) support

---

## 🤝 Contributing

Contributions are welcome!

1. Fork the repository
2. Create your feature branch: `git checkout -b feature/AmazingFeature`
3. Commit your changes: `git commit -m 'Add some AmazingFeature'`
4. Push to the branch: `git push origin feature/AmazingFeature`
5. Open a Pull Request

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

---

## 👤 Author

**Your Name**
- GitHub: [@your-username](https://github.com/your-username)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/your-profile)

---

<div align="center">
Made with ❤️ and a lot of ☕ — Give it a ⭐ if you found it useful!
</div>
