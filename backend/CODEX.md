# CODEX.md

## Project Overview

Project Name: Smart Inventory AI

Academic Project:
Final Project (UAS) Rekayasa Sistem Informasi

Business Domain:
Petshop Inventory and Sales Management

Technology Stack:

* Flutter (Mobile App)
* Laravel 12 (REST API Backend)
* MySQL (Database)
* Docker & Docker Compose
* Ollama (Local LLM)
* Qwen 3 4B / Hermes 3 (Chatbot Model)

---

## Main Objective

Build an inventory management system for a petshop with AI-powered business analysis.

The AI must:

1. Analyze sales data.
2. Recommend products that should be restocked.
3. Explain recommendations in natural language.
4. Reject questions outside inventory and sales context.

This project DOES NOT train a custom machine learning model.

The system uses a pre-trained LLM combined with business rules and database analytics.

---

## Architecture

Flutter
↓
Laravel API
↓
MySQL

Laravel
↓
AI Service

AI Service
↓
Ollama
↓
Qwen / Hermes

---

## AI Rules

The AI assistant is restricted to:

* Inventory management
* Product stock
* Product sales
* Restock recommendations
* Sales reports
* Product performance
* Business insights

The AI MUST NOT answer:

* Politics
* Religion
* Entertainment
* Programming tutorials
* General knowledge
* Personal advice
* Mathematics
* Anything unrelated to inventory and sales

When a question is outside the domain:

Response:

"Maaf, saya hanya dapat membantu terkait stok, penjualan, dan analisis inventaris."

---

## Restock Recommendation Logic

The LLM is NOT responsible for calculating restock decisions.

Laravel must calculate first.

Example formula:

average_daily_sales = total_sales_last_30_days / 30

predicted_need_7_days =
average_daily_sales * 7

If:

current_stock < predicted_need_7_days

then:

status = RESTOCK

Else:

status = SAFE

The LLM only explains the result.

---

## API Structure

Authentication:

POST /api/auth/login
POST /api/auth/logout

Products:

GET /api/products
POST /api/products
PUT /api/products/{id}
DELETE /api/products/{id}

Sales:

GET /api/sales
POST /api/sales

AI:

POST /api/ai/chat

Dashboard:

GET /api/dashboard

---

## Database Tables

users

products

sales

sale_items

categories

suppliers

chat_histories

---

## Coding Standards

Backend:

* Follow Laravel Service Pattern.
* Business logic must not be placed in Controllers.
* Use Form Request Validation.
* Use Eloquent ORM.
* Use Repository Pattern when appropriate.

Frontend:

* Use Clean Architecture.
* Separate:

  * screens
  * widgets
  * services
  * models
  * providers

Avoid placing API calls directly inside UI widgets.

---

## Docker Requirements

Services:

* nginx
* laravel
* mysql
* ollama

Every service must run through docker-compose.

No local dependency outside Docker unless required for Flutter development.

---

## Security Rules

* JWT Authentication
* Password hashing using bcrypt
* Validate every request
* Prevent SQL Injection
* Never expose database credentials

---

## Expected Features

Owner:

* Login
* Manage Products
* Manage Sales
* View Dashboard
* Chat With AI

Employee:

* Login
* Record Sales
* View Products

AI Assistant:

* Analyze stock
* Recommend restock
* Explain recommendations
* Answer inventory questions
* Reject unrelated questions

---

## Priority Order

1. Authentication
2. Product Management
3. Sales Module
4. Dashboard
5. AI Chatbot
6. Docker Deployment

Always finish higher-priority tasks before implementing lower-priority tasks.
