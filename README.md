<div align="center">

# Scales

**Lightweight, secure, and zero-cost product catalogue with WhatsApp ordering and offline exports.**

[![License: MIT with Attribution](https://img.shields.io/badge/License-MIT%20with%20Attribution-blue.svg)](LICENSE)
[![React](https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black)](https://react.dev)
[![Vite](https://img.shields.io/badge/Vite-6-646CFF?logo=vite&logoColor=white)](https://vitejs.dev)
[![Tailwind CSS](https://img.shields.io/badge/TailwindCSS-3.4-38B2AC?logo=tailwind-css&logoColor=white)](https://tailwindcss.com)
[![Supabase](https://img.shields.io/badge/Supabase-Database%20%26%20Auth-3ECF8E?logo=supabase&logoColor=white)](https://supabase.com)
[![Developed by Zencrypt](https://img.shields.io/badge/Developed%20by-Zencrypt-0f172a?style=flat&logo=shield)](https://zencrypt.in)

[Download Release (ZIP)](#download-scales) • [Requirements & Setup](REQUIREMENTS_AND_SETUP.md) • [Hosting Guide](HOSTING_GUIDE.md) • [License](#license)

</div>

---

## Overview

Scales is an open-source product catalogue platform by Zencrypt specifically built for startups, ecommerces, and business developers. 

It provides two streamlined ways to showcase products and take orders without recurring platform fees:

* **Live Web Catalogue**: An online storefront connected to a Supabase database. Buyers browse products, filter categories, and order directly through WhatsApp with pre-filled details.
* **Offline HTML Catalogue**: Download your entire inventory into a single, self-contained HTML file with embedded images. Share it directly through WhatsApp or host it statically without bandwidth overhead.

---

## Download Scales

Scales is distributed as a clean, ready-to-deploy release package:

**[Download Latest Release: `scales-v1.0.0.zip`](https://github.com/z3ncrypt-create/scales/releases/latest)**

Unzip the package, configure your Supabase database keys, and launch.

---

## Core Features

* **Customer Storefront (`/`)**:
  - Mobile-first catalogue interface.
  - Category navigation, search, and image carousels.
  - Direct WhatsApp ordering button routing orders straight to your phone.
* **Admin Dashboard (`/admin`)**:
  - Dedicated management portal secured with Supabase Authentication.
  - Add and edit products, update pricing, toggle stock, and reorder categories.
  - Customize store name, logo, WhatsApp number, and brand colors.
* **Database Security**:
  - PostgreSQL Row Level Security (RLS) ensures full data protection.
* **Image Optimization**:
  - Uploaded images are automatically compressed and converted to WebP in the browser before storage.
* **Offline Export**:
  - Compile the entire catalogue into a single offline HTML file that opens on any device without internet.

---

## Architecture

```
                                  ┌───────────────────────────────┐
                                  │      SUPABASE POSTGRESQL      │
                                  │  (Stores, Products, Images)   │
                                  └───────────────┬───────────────┘
                                                  │
                      ┌───────────────────────────┴───────────────────────────┐
                      │                                                       │
                    Admin                                                 Customer
                      │                                                       │
                      ▼                                                       ▼
       ┌───────────────────────────────┐                       ┌───────────────────────────────┐
       │     ADMIN PORTAL (`/admin`)   │                       │    CUSTOMER STOREFRONT (`/`)  │
       │                               │                       │                               │
       │ • Supabase Authentication     │                       │ • Category Navigation         │
       │ • Add / Edit / Delete Items   │                       │ • Live Search                 │
       │ • Stock & Visibility Controls │                       │ • Product Details Modal       │
       │ • Store & Currency Settings   │                       │ • WhatsApp Order Action       │
       │ • Offline HTML Export         │                       │                               │
       └───────────────────────────────┘                       └───────────────────────────────┘
```

---

## Documentation

* **[Requirements & Setup Guide](REQUIREMENTS_AND_SETUP.md)**: Prerequisites, database setup, and local development.
* **[Hosting Guide](HOSTING_GUIDE.md)**: Deploying to Netlify, Cloudflare Pages, or Vercel.
* **[Database Schema](supabase-schema.sql)**: Complete PostgreSQL setup script.

---

## License

Scales is released under the **MIT License with Attribution Requirement**.

You are free to use, modify, redistribute, and commercially sell services around Scales. The only condition is that you **must retain the visible "Scales from Zencrypt" attribution notice** (linking to `https://zencrypt.in`) in the footer of customer-facing interfaces and exported documents.

See [`LICENSE`](LICENSE) for complete legal terms.

---

## Developed by Zencrypt

Scales is designed, maintained, and open-sourced by **[Zencrypt](https://zencrypt.in)**.
