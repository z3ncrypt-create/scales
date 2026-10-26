# Scales — Hosting & Deployment Guide

This guide covers deploying Scales to production hosting platforms, configuring custom domains, securing your repository, and disabling default host badges.

---

## 1. Initial Preparation: Create a Private GitHub Repository

Always use a **Private** repository when hosting your deployment to keep your commit history and project configuration private.

1. Log into your GitHub account.
2. Click **New repository**.
3. Name your repository (e.g. `my-store-catalogue`).
4. Select **Private** (do not choose Public).
5. Leave "Initialize with README" unchecked.
6. Click **Create repository**.
7. In your unzipped project folder on your computer, push your code to your private repository:
   ```bash
   git init
   git branch -M main
   git remote add origin https://github.com/your-username/my-store-catalogue.git
   git add .
   git commit -m "Initial commit"
   git push -u origin main
   ```

---

## 2. Deploying on Netlify

Netlify is the recommended host for Scales. It provides global CDN distribution, automatic SSL certificates, and 100 GB of monthly bandwidth.

### Step A: Connect Your Private Repository
1. Log into [Netlify](https://netlify.com).
2. Click **Add new site** ➔ **Import an existing project**.
3. Select **GitHub** and authorize Netlify to access your private repository.
4. Select your private `my-store-catalogue` repository.

### Step B: Build Settings
Netlify will automatically detect the settings from `netlify.toml`:
* **Branch to deploy**: `main`
* **Build command**: `npm run build`
* **Publish directory**: `dist`

### Step C: Environment Variables
Before deploying, click **Add environment variables** and enter your Supabase keys:
* Key: `VITE_SUPABASE_URL` ➔ Value: `https://your-project-ref.supabase.co`
* Key: `VITE_SUPABASE_ANON_KEY` ➔ Value: `your-anon-public-key`

Click **Deploy Scales**. Netlify will build and publish your site in approximately 30 seconds.

---

## 3. Disabling the "Powered by Netlify" Badge

To keep your customer storefront completely clean and unbranded:

1. Log in to your Netlify account and select your project.
2. Go to **Project configuration** ➔ **General** ➔ **Powered by Netlify badge**.
3. Turn the badge **Off**.
4. Click **Save** to apply your changes.

---

## 4. Setting Up a Custom Domain on Netlify

To point your own domain (e.g. `yourbrand.com` or `catalogue.yourbrand.com`) to your Netlify storefront:

### Step A: Add Your Domain in Netlify
1. In your Netlify site dashboard, go to **Domain management**.
2. Click **Add a domain** (or **Add custom domain**).
3. Enter your domain name:
   - For an apex domain: `yourbrand.com`
   - For a subdomain: `store.yourbrand.com`
4. Click **Verify** ➔ **Add domain**.

### Step B: Configure DNS Records at Your Domain Registrar
Log into the platform where you purchased your domain (GoDaddy, Namecheap, Cloudflare, Google Domains/Squarespace) and navigate to **DNS Management**:

* **If using a Subdomain (e.g. `store.yourbrand.com`)**:
  - Type: `CNAME`
  - Host / Name: `store`
  - Value / Target: `your-site-name.netlify.app`
  - TTL: Automatic or 3600

* **If using an Apex Domain (e.g. `yourbrand.com`)**:
  - Type: `A`
  - Host / Name: `@`
  - Value / Target: `75.2.60.5` (Netlify's load balancer IP)
  - Type: `CNAME`
  - Host / Name: `www`
  - Value / Target: `your-site-name.netlify.app`

### Step C: SSL Certificate
Netlify automatically provisions a free Let's Encrypt SSL certificate once DNS records propagate (typically within 5 to 30 minutes). Your store will be accessible via `https://`.

---

## 5. Alternative: Deploying on Cloudflare Pages

Cloudflare Pages offers unlimited bandwidth and global edge performance.

### Step A: Connect Private Repository
1. Log into the [Cloudflare Dashboard](https://dash.cloudflare.com/).
2. Navigate to **Workers & Pages** ➔ **Create application** ➔ **Pages** ➔ **Connect to Git**.
3. Authorize GitHub and select your private repository.

### Step B: Build Configuration
* **Project name**: `my-store`
* **Production branch**: `main`
* **Framework preset**: `Vite`
* **Build command**: `npm run build`
* **Build output directory**: `dist`

### Step C: Environment Variables
Under **Environment variables**, click **Add variable**:
* `VITE_SUPABASE_URL` = your Supabase Project URL
* `VITE_SUPABASE_ANON_KEY` = your Supabase Anon Key

Click **Save and Deploy**.

### Step D: Custom Domain on Cloudflare Pages
1. Go to your project dashboard on Cloudflare Pages.
2. Select the **Custom domains** tab.
3. Click **Set up a custom domain**.
4. Enter your domain (e.g. `store.yourbrand.com`).
5. If your domain is already managed by Cloudflare DNS, it configures the records automatically with one click.
6. If your domain is with another registrar, add the provided `CNAME` record pointing to `your-project.pages.dev`.

---

## 6. Post-Deployment Store Setup

Once deployed to production:

1. **Access Management**: Open `https://your-custom-domain.com/admin` in your browser.
2. **Authenticate**: Log in using the admin email and password created in your Supabase Auth dashboard.
3. **Store Branding**: Open **Store Settings** from the admin menu:
   - Enter your **Store Name**.
   - Upload your **Store Logo** (auto-optimized to WebP).
   - Enter your **WhatsApp Phone Number** including the country code (e.g. `+919876543210` or `+1234567890`). This is where incoming customer orders are routed.
   - Set your **Currency Symbol** (`₹`, `$`, `€`, `£`, etc.).
   - Choose your **Brand Accent Color**.
4. **Publish Inventory**:
   - Use **+ Add Category** to organize inventory.
   - Use **+ Add Product** to upload photos, define prices, and write descriptions.
5. **Verify Customer View**: Visit your public homepage (`https://your-custom-domain.com/`) to verify that products, category filters, and WhatsApp order buttons function as expected.
