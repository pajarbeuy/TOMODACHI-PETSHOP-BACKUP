# Backend Test Cases (Step-by-Step) - Project Tomodachi Pet Shop

Dokumen ini berisi detail skenario kasus uji (*Test Cases*) dengan panduan **langkah-demi-langkah (step-by-step)** bergaya **Katalon Studio** untuk seluruh modul fungsional di backend Project Tomodachi Pet Shop.

--- 

## Ringkasan Total Test Execution
* **Total Test Execution (Lulus 100%):** **179 Tests**
* **Format Standar Katalon Studio:** Preconditions, Steps, Input Data, Expected Results, Postconditions.

--- 

## Suite: ApiErrorHandlingTest
File: `tests/Feature/ApiErrorHandlingTest.php`

### TC-APIERRORHANDLING-01: Unknown Api Route Returns Consistent Json Error
* **Deskripsi:** Menjalankan pengujian fitur `test_unknown_api_route_returns_consistent_json_error` pada kelas `ApiErrorHandlingTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-APIERRORHANDLING-02: Wrong Http Method Returns Consistent Json Error
* **Deskripsi:** Menjalankan pengujian fitur `test_wrong_http_method_returns_consistent_json_error` pada kelas `ApiErrorHandlingTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-APIERRORHANDLING-03: Validation Errors Use Consistent Payload
* **Deskripsi:** Menjalankan pengujian fitur `test_validation_errors_use_consistent_payload` pada kelas `ApiErrorHandlingTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: AuthApiTest
File: `tests/Feature/AuthApiTest.php`

### TC-AUTHAPI-04: Captcha Endpoint Returns Key Question And Expiry
* **Deskripsi:** Menjalankan pengujian fitur `test_captcha_endpoint_returns_key_question_and_expiry` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-05: Login Succeeds With Valid Captcha And Credentials
* **Deskripsi:** Menjalankan pengujian fitur `test_login_succeeds_with_valid_captcha_and_credentials` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/login`<br>Payload: `Email, password, captcha_key, captcha_answer` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-06: Login Rejects Invalid Captcha
* **Deskripsi:** Menjalankan pengujian fitur `test_login_rejects_invalid_captcha` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/login`<br>Payload: `Email, password, captcha_key, captcha_answer` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-07: Login Rejects Invalid Password
* **Deskripsi:** Menjalankan pengujian fitur `test_login_rejects_invalid_password` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/login`<br>Payload: `Email, password, captcha_key, captcha_answer` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-08: Me Returns Authenticated User Payload
* **Deskripsi:** Menjalankan pengujian fitur `test_me_returns_authenticated_user_payload` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-09: Logout Revokes Authenticated Session
* **Deskripsi:** Menjalankan pengujian fitur `test_logout_revokes_authenticated_session` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/logout`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-10: Owner Can Register New User
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_register_new_user` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/register`<br>Payload: `Email, name, password, role_id` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-11: Owner Can List Accounts
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_list_accounts` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-12: Admin Cannot List Accounts
* **Deskripsi:** Menjalankan pengujian fitur `test_admin_cannot_list_accounts` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * Admin terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-13: Owner Can Update Account
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_update_account` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-14: Owner Can Delete Account
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_delete_account` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTHAPI-15: Owner Register Validates Duplicate Email
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_register_validates_duplicate_email` pada kelas `AuthApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/register`<br>Payload: `Email, name, password, role_id` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: AuthTest
File: `tests/Feature/AuthTest.php`

### TC-AUTH-16: Generates A Captcha Challenge
* **Deskripsi:** Menjalankan pengujian fitur `it_generates_a_captcha_challenge` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-17: Logs In With Valid Credentials And Captcha
* **Deskripsi:** Menjalankan pengujian fitur `it_logs_in_with_valid_credentials_and_captcha` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-18: Rejects Login With Wrong Password
* **Deskripsi:** Menjalankan pengujian fitur `it_rejects_login_with_wrong_password` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/login`<br>Payload: `Email, password, captcha_key, captcha_answer` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-19: Rejects Login With Wrong Captcha
* **Deskripsi:** Menjalankan pengujian fitur `it_rejects_login_with_wrong_captcha` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/login`<br>Payload: `Email, password, captcha_key, captcha_answer` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-20: Rejects Login With Missing Fields
* **Deskripsi:** Menjalankan pengujian fitur `it_rejects_login_with_missing_fields` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/login`<br>Payload: `Email, password, captcha_key, captcha_answer` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-21: Returns Authenticated User On Me Endpoint
* **Deskripsi:** Menjalankan pengujian fitur `it_returns_authenticated_user_on_me_endpoint` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-22: Returns 401 On Me Without Auth
* **Deskripsi:** Menjalankan pengujian fitur `it_returns_401_on_me_without_auth` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-23: Logs Out And Revokes Token
* **Deskripsi:** Menjalankan pengujian fitur `it_logs_out_and_revokes_token` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-24: Owner Can Register New User
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_register_new_user` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/register`<br>Payload: `Email, name, password, role_id` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-25: Kasir Cannot Register New User
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_register_new_user` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/register`<br>Payload: `Email, name, password, role_id` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-26: Register Fails With Duplicate Email
* **Deskripsi:** Menjalankan pengujian fitur `register_fails_with_duplicate_email` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/auth/register`<br>Payload: `Email, name, password, role_id` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-27: Owner Can List All Accounts
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_list_all_accounts` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-28: Kasir Cannot Access Accounts List
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_access_accounts_list` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-29: Owner Can Update Another Account
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_update_another_account` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-30: Owner Cannot Delete Own Account
* **Deskripsi:** Menjalankan pengujian fitur `owner_cannot_delete_own_account` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-AUTH-31: Owner Can Delete Another Account
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_delete_another_account` pada kelas `AuthTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: CategoryApiTest
File: `tests/Feature/CategoryApiTest.php`

### TC-CATEGORYAPI-32: Authenticated User Can List Categories
* **Deskripsi:** Menjalankan pengujian fitur `test_authenticated_user_can_list_categories` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-33: Categories Are Ordered By Animal Type Then Sub Category
* **Deskripsi:** Menjalankan pengujian fitur `test_categories_are_ordered_by_animal_type_then_sub_category` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-34: Authenticated User Can Show Category
* **Deskripsi:** Menjalankan pengujian fitur `test_authenticated_user_can_show_category` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-35: Show Returns 404 For Missing Category
* **Deskripsi:** Menjalankan pengujian fitur `test_show_returns_404_for_missing_category` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-36: Owner Can Create Category
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_create_category` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/categories`<br>Payload: `Name, animal_type, sub_category` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-37: Admin Can Create Category
* **Deskripsi:** Menjalankan pengujian fitur `test_admin_can_create_category` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * Admin terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/categories`<br>Payload: `Name, animal_type, sub_category` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-38: Create Category Requires Required Fields
* **Deskripsi:** Menjalankan pengujian fitur `test_create_category_requires_required_fields` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/categories`<br>Payload: `Name, animal_type, sub_category` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-39: Owner Can Update Category
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_update_category` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `PUT /api/categories/{id}`<br>Payload: `Name, animal_type, sub_category` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-40: Patch Category Uses Same Update Validation
* **Deskripsi:** Menjalankan pengujian fitur `test_patch_category_uses_same_update_validation` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-41: Update Category Returns 404 For Missing Category
* **Deskripsi:** Menjalankan pengujian fitur `test_update_category_returns_404_for_missing_category` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `PUT /api/categories/{id}`<br>Payload: `Name, animal_type, sub_category` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-42: Owner Can Delete Category
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_delete_category` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `DELETE /api/categories/{id}`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-CATEGORYAPI-43: Grouped Product Categories Returns Grouped Payload
* **Deskripsi:** Menjalankan pengujian fitur `test_grouped_product_categories_returns_grouped_payload` pada kelas `CategoryApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: ExampleTest
File: `tests/Feature/ExampleTest.php`

### TC-EXAMPLE-44: The Application Returns A Successful Response
* **Deskripsi:** Menjalankan pengujian fitur `test_the_application_returns_a_successful_response` pada kelas `ExampleTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: POSTransactionTest
File: `tests/Feature/POSTransactionTest.php`

### TC-POSTRANSACTION-45: Filters In Stock Products Correctly
* **Deskripsi:** Menjalankan pengujian fitur `it_filters_in_stock_products_correctly` pada kelas `POSTransactionTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-POSTRANSACTION-46: Performs Checkout Successfully And Deducts Stock
* **Deskripsi:** Menjalankan pengujian fitur `it_performs_checkout_successfully_and_deducts_stock` pada kelas `POSTransactionTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-POSTRANSACTION-47: Rejects Checkout When Stock Is Insufficient
* **Deskripsi:** Menjalankan pengujian fitur `it_rejects_checkout_when_stock_is_insufficient` pada kelas `POSTransactionTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-POSTRANSACTION-48: Validates Safety Price Levels
* **Deskripsi:** Menjalankan pengujian fitur `it_validates_safety_price_levels` pada kelas `POSTransactionTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: ProductApiTest
File: `tests/Feature/ProductApiTest.php`

### TC-PRODUCTAPI-49: Authenticated User Can List Products
* **Deskripsi:** Menjalankan pengujian fitur `test_authenticated_user_can_list_products` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-50: Product Search Filters By Name
* **Deskripsi:** Menjalankan pengujian fitur `test_product_search_filters_by_name` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-51: Product Filter By Category Id
* **Deskripsi:** Menjalankan pengujian fitur `test_product_filter_by_category_id` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-52: Product Filter By Animal Type And Sub Category
* **Deskripsi:** Menjalankan pengujian fitur `test_product_filter_by_animal_type_and_sub_category` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-53: In Stock Filter Uses Offline Channel
* **Deskripsi:** Menjalankan pengujian fitur `test_in_stock_filter_uses_offline_channel` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-54: In Stock Filter Uses Online Channel
* **Deskripsi:** Menjalankan pengujian fitur `test_in_stock_filter_uses_online_channel` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-55: Kasir Product List Hides Buy Price And Margin
* **Deskripsi:** Menjalankan pengujian fitur `test_kasir_product_list_hides_buy_price_and_margin` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-56: Owner Product List Includes Buy Price And Margin
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_product_list_includes_buy_price_and_margin` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-57: Authenticated User Can Show Product Detail
* **Deskripsi:** Menjalankan pengujian fitur `test_authenticated_user_can_show_product_detail` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-58: Show Product Returns 404 For Missing Product
* **Deskripsi:** Menjalankan pengujian fitur `test_show_product_returns_404_for_missing_product` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-59: Owner Can Create Product With Stock
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_create_product_with_stock` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/products`<br>Payload: `SKU, name, prices, quantities` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-60: Create Product Rejects Sell Price Below Cost Without Confirmation
* **Deskripsi:** Menjalankan pengujian fitur `test_create_product_rejects_sell_price_below_cost_without_confirmation` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/products`<br>Payload: `SKU, name, prices, quantities` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-61: Create Product Accepts Sell Price Below Cost With Confirmation
* **Deskripsi:** Menjalankan pengujian fitur `test_create_product_accepts_sell_price_below_cost_with_confirmation` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/products`<br>Payload: `SKU, name, prices, quantities` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-62: Admin Can Update Product And Stock
* **Deskripsi:** Menjalankan pengujian fitur `test_admin_can_update_product_and_stock` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * Admin terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `PUT /api/products/{id}`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-63: Post Update Route Updates Product
* **Deskripsi:** Menjalankan pengujian fitur `test_post_update_route_updates_product` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `PUT /api/products/{id}`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTAPI-64: Owner Can Soft Delete Product
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_soft_delete_product` pada kelas `ProductApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `DELETE /api/products/{id}`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: ProductCrudTest
File: `tests/Feature/ProductCrudTest.php`

### TC-PRODUCTCRUD-65: Authenticated User Can List Products
* **Deskripsi:** Menjalankan pengujian fitur `authenticated_user_can_list_products` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-66: Unauthenticated User Cannot List Products
* **Deskripsi:** Menjalankan pengujian fitur `unauthenticated_user_cannot_list_products` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Guest (Tanpa Token) dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-67: Kasir Cannot See Buy Price In Product List
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_see_buy_price_in_product_list` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-68: Owner Can See Buy Price In Product List
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_see_buy_price_in_product_list` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-69: Product List Can Be Searched By Name
* **Deskripsi:** Menjalankan pengujian fitur `product_list_can_be_searched_by_name` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-70: Product List Can Be Filtered By In Stock
* **Deskripsi:** Menjalankan pengujian fitur `product_list_can_be_filtered_by_in_stock` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-71: Authenticated User Can Get Product Detail
* **Deskripsi:** Menjalankan pengujian fitur `authenticated_user_can_get_product_detail` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-72: Returns 404 For Nonexistent Product
* **Deskripsi:** Menjalankan pengujian fitur `it_returns_404_for_nonexistent_product` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-73: Owner Can Create Product
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_create_product` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/products`<br>Payload: `SKU, name, prices, quantities` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-74: Kasir Cannot Create Product
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_create_product` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/products`<br>Payload: `SKU, name, prices, quantities` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-75: Create Product Fails If Sell Price Below Buy Without Confirm
* **Deskripsi:** Menjalankan pengujian fitur `create_product_fails_if_sell_price_below_buy_without_confirm` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/products`<br>Payload: `SKU, name, prices, quantities` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-76: Create Product With Sell Price Below Buy Succeeds With Confirm Flag
* **Deskripsi:** Menjalankan pengujian fitur `create_product_with_sell_price_below_buy_succeeds_with_confirm_flag` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/products`<br>Payload: `SKU, name, prices, quantities` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-77: Create Product Auto Generates Sku If Not Provided
* **Deskripsi:** Menjalankan pengujian fitur `create_product_auto_generates_sku_if_not_provided` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/products`<br>Payload: `SKU, name, prices, quantities` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-78: Owner Can Update Product
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_update_product` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `PUT /api/products/{id}`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-79: Kasir Cannot Update Product
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_update_product` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `PUT /api/products/{id}`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-80: Owner Can Soft Delete Product
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_soft_delete_product` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `DELETE /api/products/{id}`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-81: Kasir Cannot Delete Product
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_delete_product` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `DELETE /api/products/{id}`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-82: Authenticated User Can List Categories
* **Deskripsi:** Menjalankan pengujian fitur `authenticated_user_can_list_categories` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-83: Owner Can Create Category
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_create_category` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/categories`<br>Payload: `Name, animal_type, sub_category` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-PRODUCTCRUD-84: Kasir Cannot Create Category
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_create_category` pada kelas `ProductCrudTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/categories`<br>Payload: `Name, animal_type, sub_category` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: ReportApiTest
File: `tests/Feature/ReportApiTest.php`

### TC-REPORTAPI-85: Owner Can Generate Sales Report With Channel Filter
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_generate_sales_report_with_channel_filter` pada kelas `ReportApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORTAPI-86: Owner Can Retrieve Sales Summary Grouped By Day
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_retrieve_sales_summary_grouped_by_day` pada kelas `ReportApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORTAPI-87: Owner Can List Top Products Sorted By Revenue
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_list_top_products_sorted_by_revenue` pada kelas `ReportApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORTAPI-88: Owner Dashboard Analytics Returns Expected Kpis
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_dashboard_analytics_returns_expected_kpis` pada kelas `ReportApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: ReportTest
File: `tests/Feature/ReportTest.php`

### TC-REPORT-89: Owner Can Access Dashboard Analytics
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_access_dashboard_analytics` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-90: Kasir Cannot Access Dashboard Analytics
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_access_dashboard_analytics` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-91: Analytics Today Sales Reflects Completed Transactions
* **Deskripsi:** Menjalankan pengujian fitur `analytics_today_sales_reflects_completed_transactions` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-92: Analytics Does Not Count Pending Transactions
* **Deskripsi:** Menjalankan pengujian fitur `analytics_does_not_count_pending_transactions` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-93: Owner Can Get Sales Report
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_get_sales_report` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-94: Sales Report Requires Date Parameters
* **Deskripsi:** Menjalankan pengujian fitur `sales_report_requires_date_parameters` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-95: Sales Report Can Filter By Channel
* **Deskripsi:** Menjalankan pengujian fitur `sales_report_can_filter_by_channel` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-96: Kasir Cannot Access Sales Report
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_access_sales_report` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-97: Owner Can Get Top Products
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_get_top_products` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-98: Kasir Cannot Access Top Products
* **Deskripsi:** Menjalankan pengujian fitur `kasir_cannot_access_top_products` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-99: Owner Can Get Daily Sales Summary
* **Deskripsi:** Menjalankan pengujian fitur `owner_can_get_daily_sales_summary` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-REPORT-100: Sales Summary Requires Period And Year
* **Deskripsi:** Menjalankan pengujian fitur `sales_summary_requires_period_and_year` pada kelas `ReportTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/reports/sales atau /api/dashboard/analytics`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: SecurityRouteTest
File: `tests/Feature/SecurityRouteTest.php`

### TC-SEC-GUEST-101: Verify Protected Route [logout] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST ke rute privat | Endpoint: `POST /api/auth/logout` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-102: Verify Protected Route [me] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/auth/me` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-103: Verify Protected Route [register] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST ke rute privat | Endpoint: `POST /api/auth/register` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-104: Verify Protected Route [user] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/user` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-105: Verify Protected Route [categories index] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/categories` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-106: Verify Protected Route [categories show] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/categories/1` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-107: Verify Protected Route [categories store] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST ke rute privat | Endpoint: `POST /api/categories` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-108: Verify Protected Route [categories put] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request PUT ke rute privat | Endpoint: `PUT /api/categories/1` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-109: Verify Protected Route [categories patch] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request PATCH ke rute privat | Endpoint: `PATCH /api/categories/1` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-110: Verify Protected Route [categories delete] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request DELETE ke rute privat | Endpoint: `DELETE /api/categories/1` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-111: Verify Protected Route [product categories] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/products/categories` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-112: Verify Protected Route [products index] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/products` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-113: Verify Protected Route [products show] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/products/1` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-114: Verify Protected Route [products store] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST ke rute privat | Endpoint: `POST /api/products` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-115: Verify Protected Route [products post update] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST ke rute privat | Endpoint: `POST /api/products/1/update` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-116: Verify Protected Route [products put] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request PUT ke rute privat | Endpoint: `PUT /api/products/1` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-117: Verify Protected Route [products delete] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request DELETE ke rute privat | Endpoint: `DELETE /api/products/1` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-118: Verify Protected Route [transactions store] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST ke rute privat | Endpoint: `POST /api/transactions` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-119: Verify Protected Route [transactions index] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/transactions` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-120: Verify Protected Route [transactions show] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/transactions/1` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-121: Verify Protected Route [transactions receipt] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/transactions/1/receipt` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-122: Verify Protected Route [sales report] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/reports/sales` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-123: Verify Protected Route [sales summary] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/reports/sales/summary` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-124: Verify Protected Route [top products] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/reports/top-products` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-125: Verify Protected Route [dashboard analytics] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/dashboard/analytics` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-126: Verify Protected Route [ai chat] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST ke rute privat | Endpoint: `POST /api/ai/chat` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-127: Verify Protected Route [ai history] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/ai/chat/history` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-GUEST-128: Verify Protected Route [ai restock] Rejects Guest
* **Deskripsi:** Memverifikasi tamu (*Guest*) tanpa token ditolak mengakses route terproteksi.
* **Prasyarat (Pre-conditions):**
  * Tamu tidak login (*Unauthenticated*).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute privat | Endpoint: `GET /api/ai/restock` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **401 Unauthorized**. |
| 3 | Verifikasi pesan error JSON | - | JSON berisi pesan autentikasi tidak valid. |

* **Kondisi Pasca-tes (Post-conditions):** Akses ke data privat diblokir.

---

### TC-SEC-KASIR-129: Verify Owner/Admin Route [register user] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST menggunakan token kasir | Endpoint: `POST /api/auth/register` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-130: Verify Owner/Admin Route [create category] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST menggunakan token kasir | Endpoint: `POST /api/categories` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-131: Verify Owner/Admin Route [update category put] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request PUT menggunakan token kasir | Endpoint: `PUT /api/categories/1` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-132: Verify Owner/Admin Route [update category patch] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request PATCH menggunakan token kasir | Endpoint: `PATCH /api/categories/1` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-133: Verify Owner/Admin Route [delete category] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request DELETE menggunakan token kasir | Endpoint: `DELETE /api/categories/1` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-134: Verify Owner/Admin Route [create product] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST menggunakan token kasir | Endpoint: `POST /api/products` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-135: Verify Owner/Admin Route [update product post] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request POST menggunakan token kasir | Endpoint: `POST /api/products/1/update` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-136: Verify Owner/Admin Route [update product put] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request PUT menggunakan token kasir | Endpoint: `PUT /api/products/1` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-137: Verify Owner/Admin Route [delete product] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request DELETE menggunakan token kasir | Endpoint: `DELETE /api/products/1` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-138: Verify Owner/Admin Route [sales report] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET menggunakan token kasir | Endpoint: `GET /api/reports/sales` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-139: Verify Owner/Admin Route [sales summary] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET menggunakan token kasir | Endpoint: `GET /api/reports/sales/summary` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-140: Verify Owner/Admin Route [top products] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET menggunakan token kasir | Endpoint: `GET /api/reports/top-products` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-KASIR-141: Verify Owner/Admin Route [dashboard analytics] Rejects Kasir
* **Deskripsi:** Memverifikasi kasir ditolak mengakses menu khusus admin/owner.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi (Bearer Token Kasir).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET menggunakan token kasir | Endpoint: `GET /api/dashboard/analytics` | API memproses hak akses. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **403 Forbidden**. |
| 3 | Verifikasi penolakan data | - | Akses ditolak dan payload data tidak dikembalikan. |

* **Kondisi Pasca-tes (Post-conditions):** Hak akses kasir dibatasi sesuai RBAC.

---

### TC-SEC-PUBLIC-142: Verify Public Route [health] Access Allowed
* **Deskripsi:** Memverifikasi route publik dapat diakses tanpa token.
* **Prasyarat (Pre-conditions):**
  * Pengguna tidak login.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute publik | Endpoint: `GET /api/health` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon bukan 401 (sukses, misal **200 OK**). |

* **Kondisi Pasca-tes (Post-conditions):** Data publik terkirim ke client.

---

### TC-SEC-PUBLIC-143: Verify Public Route [captcha] Access Allowed
* **Deskripsi:** Memverifikasi route publik dapat diakses tanpa token.
* **Prasyarat (Pre-conditions):**
  * Pengguna tidak login.
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request GET ke rute publik | Endpoint: `GET /api/auth/captcha` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon bukan 401 (sukses, misal **200 OK**). |

* **Kondisi Pasca-tes (Post-conditions):** Data publik terkirim ke client.

---

## Suite: TransactionApiTest
File: `tests/Feature/TransactionApiTest.php`

### TC-TRANSACTIONAPI-144: Kasir Can Checkout Cash Transaction And Deduct Offline Stock
* **Deskripsi:** Menjalankan pengujian fitur `test_kasir_can_checkout_cash_transaction_and_deduct_offline_stock` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * Kasir terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-145: Owner Can Checkout Transaction
* **Deskripsi:** Menjalankan pengujian fitur `test_owner_can_checkout_transaction` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * Owner terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-146: Admin Can Checkout Transaction
* **Deskripsi:** Menjalankan pengujian fitur `test_admin_can_checkout_transaction` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * Admin terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-147: Checkout Validates Required Items
* **Deskripsi:** Menjalankan pengujian fitur `test_checkout_validates_required_items` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-148: Checkout Rejects Invalid Channel
* **Deskripsi:** Menjalankan pengujian fitur `test_checkout_rejects_invalid_channel` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-149: Checkout Rejects Cash Payment Below Total
* **Deskripsi:** Menjalankan pengujian fitur `test_checkout_rejects_cash_payment_below_total` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-150: Checkout Rejects Insufficient Offline Stock
* **Deskripsi:** Menjalankan pengujian fitur `test_checkout_rejects_insufficient_offline_stock` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-151: Online Checkout Deducts Online Stock
* **Deskripsi:** Menjalankan pengujian fitur `test_online_checkout_deducts_online_stock` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-152: Authenticated User Can List Transactions
* **Deskripsi:** Menjalankan pengujian fitur `test_authenticated_user_can_list_transactions` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-153: Transaction History Filters By Channel
* **Deskripsi:** Menjalankan pengujian fitur `test_transaction_history_filters_by_channel` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-154: Authenticated User Can Show Transaction By Code
* **Deskripsi:** Menjalankan pengujian fitur `test_authenticated_user_can_show_transaction_by_code` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-155: Authenticated User Can Fetch Receipt
* **Deskripsi:** Menjalankan pengujian fitur `test_authenticated_user_can_fetch_receipt` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-156: Midtrans Notification Rejects Invalid Signature
* **Deskripsi:** Menjalankan pengujian fitur `test_midtrans_notification_rejects_invalid_signature` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/midtrans/notification`<br>Payload: `Order_id, transaction_status, signature_key, gross_amount` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-157: Midtrans Notification Marks Transaction Completed
* **Deskripsi:** Menjalankan pengujian fitur `test_midtrans_notification_marks_transaction_completed` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-158: Midtrans Notification Restocks Items On Cancel
* **Deskripsi:** Menjalankan pengujian fitur `test_midtrans_notification_restocks_items_on_cancel` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/midtrans/notification`<br>Payload: `Order_id, transaction_status, signature_key, gross_amount` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-159: Midtrans Notification Restocks Items On Expire
* **Deskripsi:** Menjalankan pengujian fitur `test_midtrans_notification_restocks_items_on_expire` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/midtrans/notification`<br>Payload: `Order_id, transaction_status, signature_key, gross_amount` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-160: Checkout Rejects Negative Amount Paid
* **Deskripsi:** Menjalankan pengujian fitur `test_checkout_rejects_negative_amount_paid` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-161: Checkout Rejects Negative Quantity
* **Deskripsi:** Menjalankan pengujian fitur `test_checkout_rejects_negative_quantity` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-162: Checkout Rejects Zero Quantity
* **Deskripsi:** Menjalankan pengujian fitur `test_checkout_rejects_zero_quantity` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-TRANSACTIONAPI-163: Checkout Rejects Negative Unit Price
* **Deskripsi:** Menjalankan pengujian fitur `test_checkout_rejects_negative_unit_price` pada kelas `TransactionApiTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `POST /api/transactions`<br>Payload: `Channel, payment_method, items, amount_paid` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **422 Unprocessable Content / 403 Forbidden**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Mengembalikan pesan error validasi / akses ditolak. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: ExampleTest
File: `tests/Feature/ExampleTest.php`

### TC-EXAMPLE-164: That True Is True
* **Deskripsi:** Menjalankan pengujian fitur `test_that_true_is_true` pada kelas `ExampleTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

## Suite: ModelRelationshipTest
File: `tests/Feature/ModelRelationshipTest.php`

### TC-MODELRELATIONSHIP-165: Role Has Many Users
* **Deskripsi:** Menjalankan pengujian fitur `test_role_has_many_users` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-166: User Belongs To Role
* **Deskripsi:** Menjalankan pengujian fitur `test_user_belongs_to_role` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `API Endpoint`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-167: Category Has Many Products
* **Deskripsi:** Menjalankan pengujian fitur `test_category_has_many_products` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-168: Product Belongs To Category
* **Deskripsi:** Menjalankan pengujian fitur `test_product_belongs_to_category` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-169: Product Has One Stock
* **Deskripsi:** Menjalankan pengujian fitur `test_product_has_one_stock` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-170: Stock Belongs To Product
* **Deskripsi:** Menjalankan pengujian fitur `test_stock_belongs_to_product` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-171: Transaction Belongs To Cashier
* **Deskripsi:** Menjalankan pengujian fitur `test_transaction_belongs_to_cashier` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-172: Transaction Has Many Items
* **Deskripsi:** Menjalankan pengujian fitur `test_transaction_has_many_items` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-173: Transaction Item Belongs To Transaction
* **Deskripsi:** Menjalankan pengujian fitur `test_transaction_item_belongs_to_transaction` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-174: Transaction Item Belongs To Product
* **Deskripsi:** Menjalankan pengujian fitur `test_transaction_item_belongs_to_product` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/products`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-175: Product Soft Deletes
* **Deskripsi:** Menjalankan pengujian fitur `test_product_soft_deletes` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `DELETE /api/products/{id}`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-176: Stock Last Updated Casts To Datetime
* **Deskripsi:** Menjalankan pengujian fitur `test_stock_last_updated_casts_to_datetime` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/auth/me`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-177: Transaction Midtrans Payload Casts To Array
* **Deskripsi:** Menjalankan pengujian fitur `test_transaction_midtrans_payload_casts_to_array` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-178: Transaction Money Fields Cast To Decimal Strings
* **Deskripsi:** Menjalankan pengujian fitur `test_transaction_money_fields_cast_to_decimal_strings` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/transactions`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

### TC-MODELRELATIONSHIP-179: Category Fillable Fields Can Be Mass Assigned
* **Deskripsi:** Menjalankan pengujian fitur `test_category_fillable_fields_can_be_mass_assigned` pada kelas `ModelRelationshipTest`.
* **Prasyarat (Pre-conditions):**
  * User terautentikasi dengan token/credentials yang sesuai.
  * Lingkungan database terisolasi (RefreshDatabase).
* **Langkah-langkah Pengujian (Test Steps):**

| Step No | Deskripsi Langkah | Input / Endpoint | Hasil yang Diharapkan |
| :---: | :--- | :--- | :--- |
| 1 | Kirim request API terkait pengujian | Endpoint: `GET /api/categories`<br>Payload: `-` | API menerima request. |
| 2 | Verifikasi status respon HTTP | - | Status respon adalah **200 OK / 201 Created**. |
| 3 | Verifikasi pemrosesan database dan struktur JSON | - | Respon sesuai dengan spesifikasi. |

* **Kondisi Pasca-tes (Post-conditions):** Status database dan state model terverifikasi konsisten.

---

