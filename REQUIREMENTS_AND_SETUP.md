# Scales — Requirements & Setup Guide

This guide walks you through setting up Scales using the official release package.

---

## 1. Prerequisites

Before starting, make sure you have:
* **Node.js** (v18.0.0 or higher) installed on your computer.
* A **[Supabase](https://supabase.com)** account (for cloud database & authentication).
* A terminal or code editor.

---

## 2. Unpack the Release

1. Download **`scales-v1.0.0.zip`** from the [Releases](https://github.com/z3ncrypt-create/scales/releases/latest) page.
2. Extract the ZIP file to a folder on your computer.
3. Open a terminal in that folder and install dependencies:
   ```bash
   npm install
   ```

---

## 3. Database Setup (Supabase)

1. Log into your [Supabase Dashboard](https://supabase.com/dashboard) and click **New project**.
2. Set a project name and database password.
3. Once the project is ready, open the **SQL Editor** from the left sidebar.
4. Click **New query**, paste the entire contents of [`supabase-schema.sql`](supabase-schema.sql), and click **Run**.

This script sets up:
- Tables: `stores`, `categories`, `products`, `product_images`.
- Performance indexes.
- Storage bucket: `catalogue-images` (for product photos and store logos).
- PostgreSQL Row Level Security (RLS) rules.

---

## 4. Create the Admin User

1. In your Supabase Dashboard, go to **Authentication** ➔ **Users**.
2. Click **Add user** ➔ **Create user**.
3. Enter your admin email and a strong password.
4. Click **Create user**.

---

## 5. Configure Environment Variables

1. In your unzipped project folder, copy `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```
2. Open `.env` and enter your Supabase project credentials (found in **Project Settings** ➔ **API**):
   ```env
   VITE_SUPABASE_URL=https://your-project-ref.supabase.co
   VITE_SUPABASE_ANON_KEY=your-anon-public-key
   ```

---

## 6. Run Scales Locally

Start the local development server:
```bash
npm run dev
```

* **Customer Storefront**: Open `http://localhost:5173/` in your browser.
* **Admin Management Portal**: Open `http://localhost:5173/admin` and sign in with the admin credentials created in Step 4.

---

## 7. Next Step

Follow our **[Hosting Guide](HOSTING_GUIDE.md)** to deploy Scales to production.
